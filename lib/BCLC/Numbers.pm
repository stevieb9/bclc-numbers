package BCLC::Numbers;

use warnings;
use strict;

our $VERSION = '0.01';

use BCLC::Numbers::CSV;
use BCLC::Numbers::DB;
use Dancer2;
use Dancer2::Core::Request;
use Number::Format qw(:subs :vars);

my $db_file = 'data/649.db';
my $csv_file = 'data/649.csv';

my $csv = BCLC::Numbers::CSV->new($csv_file);
my $db = BCLC::Numbers::DB->new($db_file);

my $payout_table = payout_table();

get '/' => sub {
    return template 'main';
};

get '/fetch_data/:params' => sub {
    my $params = from_json param("params");

    my $numbers = $params->{numbers};
    my $display_all = $params->{display_all};
    my $csv_source = $params->{csv_source};

    return to_json fetch_data($numbers, $display_all, $csv_source);
};

sub calculate_win_value {
    my ($draw) = @_;

    my $payout_key = $draw->{NUMBER_MATCHES};

    if ($payout_key && ($payout_key == 2 || $payout_key == 5)){
        if ($draw->{BONUS_MATCH}){
            $payout_key .= '+';
        }
    }

    return $payout_table->{$payout_key};
}

sub compile_data {
    my ($all_draws, $display_all) = @_;

    my @winning_draws;
    my $total_spent_on_tickets;
    my $total_number_payout;

    for my $draw (@$all_draws) {

        $total_spent_on_tickets += ticket_price($draw);

        next if $draw->{NUMBER_MATCHES} < 2;

        $total_number_payout += draw_payout($draw);

        if ($display_all){
            push @winning_draws, $draw;
        }
        elsif ($draw->{NUMBER_MATCHES} >= 4){
            # $85+
            push @winning_draws, $draw;
        }
    }

    my $net_win_loss
      = convert_to_dollar($total_number_payout - $total_spent_on_tickets);

    my $data = {
        winning_draws     => \@winning_draws,
        total_spent_on_tickets => convert_to_dollar($total_spent_on_tickets),
        total_number_payout => convert_to_dollar($total_number_payout),
        net_win_loss => $net_win_loss,
        total_draw_income => undef,
    };

    return $data;
}

sub convert_to_dollar {
    my ($int) = @_;
    return format_price($int //= 0, 2, '$');
}

sub draw_payout {
    my ($draw) = @_;
    return calculate_win_value($draw);
}

sub fetch_data {
    my ($player_numbers, $display_all, $csv_source) = @_;

    $csv_source //= 1;

    my $draws;

    if ($csv_source){
        $draws = $csv->retrieve;
    }
    else {
        $draws = $db->retrieve(table => 'historical');
    }

    my @valid_draws;

    for my $draw (@$draws){

        next if filter($draw);

        my %winning_numbers;
        my $bonus_number;

        for (1..6){
            my $column = "NUMBER DRAWN $_";
            $winning_numbers{$draw->{$column}} = 1;
        }

        $bonus_number = $draw->{'BONUS NUMBER'};

        my $match_count = 0;
        my $match_bonus = 0;

        for my $player_number (@$player_numbers){
            if ($winning_numbers{$player_number}){
                $match_count++;
            }
            $match_bonus++ if $player_number == $bonus_number;
        }

        $draw->{NUMBER_MATCHES} = $match_count;
        $draw->{BONUS_MATCH} = $match_bonus;

        if ($draw->{NUMBER_MATCHES}){
            $draw->{WIN_AMOUNT}
              = convert_to_dollar(calculate_win_value($draw));
        }

        push @valid_draws, $draw;
    }

    my $aggregate_data = compile_data(\@valid_draws, $display_all);

    return $aggregate_data;
}

sub filter {
    my ($draw) = @_;

    if ($draw->{'SEQUENCE NUMBER'} != 0 || $draw->{'DRAW NUMBER'} > 3620){
        return 1;
    }

    return 0;
}

sub payout_table {
    return {
        '2'  => 3,
        '2+' => 5,
        '3'  => 10,
        '4'  => 85,
        '5'  => 3000,
        '5+' => 250000,
        '6'  => 5000000,
    };
}

sub ticket_price {
    my ($draw) = @_;

    my $draw_number = $draw->{'DRAW NUMBER'};

    return 1 if $draw_number <= 2124;
    return 2 if $draw_number <= 2989;
    return 3;
}

1;

__END__

=head1 NAME

BCLC::Numbers - Calculate 649 historical wins

=head1 AUTHOR

Steve Bertrand, C<< <steve.bertrand at gmail.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2019 Steve Bertrand.

