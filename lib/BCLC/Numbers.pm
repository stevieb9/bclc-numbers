package BCLC::Numbers;

use strict;
use warnings;

use Data::Dumper;

our $VERSION = '0.01';

use BCLC::Numbers::DB;
use Dancer2;
use Dancer2::Core::Request;

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

    my @winning_draws;

    for my $draw (@$results){
        my %winning_numbers;
        my $bonus_number;

        for (1..6){
            my $column = "NUMBER DRAWN $_";
            $winning_numbers{$draw->{$column}} = 1;
        }

        $bonus_number = $draw->{'BONUS NUMBER'};

        my $match_count;
        my $match_bonus;


        for my $player_number (@$player_numbers){
            if ($winning_numbers{$player_number}){
                $match_count++;
            }
            $match_bonus++ if $player_number == $bonus_number;
        }

        if ($match_count >= 4){
            $draw->{NUMBER_MATCHES} = $match_count;
            $draw->{BONUS_MATCH} = $match_bonus;

            $draw->{WIN_AMOUNT} = _calculate_win_value($draw);

            push @winning_draws, $draw;
        }
    }

    print Dumper \@winning_draws;
}

sub _calculate_win_value {
    my ($draw) = @_;

    my $payout_key = $draw->{NUMBER_MATCHES};

    if ($payout_key == 2 || $payout_key == 5){
        $payout_key . '+' if $draw->{BONUS_MATCH};
    }

    return $payout_table->{$payout_key};
}

sub _payout_table {
    return {
        '2'  => '$3',
        '2+' => '$5',
        '3'  => '$10',
        '4'  => '$85',
        '5'  => '$3,000',
        '5+' => '$250,000',
        '6'  => '$5,000,000',
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

