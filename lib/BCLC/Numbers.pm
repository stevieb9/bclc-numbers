package BCLC::Numbers;

use strict;
use warnings;

our $VERSION = '0.01';

use BCLC::Numbers::DB;
use Dancer2;
use Dancer2::Core::Request;
use Data::Dumper;
use Number::Format qw(:subs);

my $db_file = 'data/649.db';
my $db = BCLC::Numbers::DB->new($db_file);

my $payout_table = _payout_table();

get '/' => sub {
    return template 'main';
};

get '/fetch_data/:numbers' => sub {
    my $numbers = from_json(param("numbers"));
    return to_json fetch($numbers);
};

sub fetch {
    my $player_numbers = shift;

    my $results = $db->retrieve(
        table   => 'historical',
        numbers => $player_numbers,
    );

    my @all_draws;

    for my $draw (@$results){
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
              = _convert_to_dollar(_calculate_win_value($draw));
        }

        push @all_draws, $draw;
    }

    my $aggregate_data = _tally_data(\@all_draws);

    return $aggregate_data;
}

sub _convert_to_dollar {
    my ($int) = @_;
    return format_price($int, 2, '$');
}

sub _tally_data {
    my ($all_draws) = @_;

    my @winning_draws;
    my $total_number_payout;

    for my $draw (@$all_draws) {

        #FIXME: Tally ticket purchases here!

        next if $draw->{NUMBER_MATCHES} < 2;

        # running total of all wins

        $total_number_payout += _draw_payout($draw);

        # $85+

        if ($draw->{NUMBER_MATCHES} >= 4){
            push @winning_draws, $draw;
        }
    }

    my $data = {
        winning_draws     => \@winning_draws,
        total_number_payout => _convert_to_dollar($total_number_payout, 2, '$'),
        total_draw_income => undef,
    };

    return $data;
}

sub _draw_payout {
    my ($draw) = @_;
    return _calculate_win_value($draw);
}

sub _calculate_win_value {
    my ($draw, $dollar_value) = @_;

    $dollar_value //= 1;

    my $payout_key = $draw->{NUMBER_MATCHES};

    if ($payout_key && ($payout_key == 2 || $payout_key == 5)){
        $payout_key . '+' if $draw->{BONUS_MATCH};
    }

    return $payout_table->{$payout_key};
}

sub _payout_table {
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

1;

__END__

=head1 NAME

BCLC::Numbers - Calculate 649 historical wins

=head1 AUTHOR

Steve Bertrand, C<< <steve.bertrand at gmail.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2019 Steve Bertrand.

