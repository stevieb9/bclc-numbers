package BCLC::Numbers;

use warnings;
use strict;

our $VERSION = '0.01';

use BCLC::Numbers::CSV;
use BCLC::Numbers::DB;
use Dancer2;
use Dancer2::Core::Request;
use Number::Format qw(:subs :vars);

use constant {
    MAX_DRAW_NUMBER       => 3620,
    VALID_SEQUENCE_NUMBER => => 0,
};

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

sub convert_to_dollar {
    my ($int) = @_;
    return format_price($int //= 0, 2, '$');
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

        my %validate_numbers;
        my $backend_error = 0;

        my $match_count = 0;
        my $match_bonus = 0;

        for my $player_number (@$player_numbers){
            if (! $validate_numbers{$player_number}){
                $validate_numbers{$player_number} = 1;
            }
            else {
                $backend_error = 1;
            }

            $backend_error = 1 if $player_number > 49;

            if ($backend_error){
                return {
                    error     => 1,
                    error_msg =>
                        "One or more numbers are either out of range, " .
                        "or is a duplicate. Please hit the Reset " .
                        "and try again!",
                }
            }
            if ($winning_numbers{$player_number}){
                $match_count++;
            }
            $match_bonus++ if $player_number == $bonus_number;
        }

        $draw->{NUMBER_MATCHES} = $match_count;
        $draw->{BONUS_MATCH} = $match_bonus;

        if ($draw->{NUMBER_MATCHES}){
            $draw->{WIN_AMOUNT}
              = convert_to_dollar(_calculate_win_value($draw));
        }

        push @valid_draws, $draw;
    }

    my $aggregate_data = _compile_data(\@valid_draws, $display_all);

    $aggregate_data->{error} = 0;

    # tag the data with its source

    $aggregate_data->{data_source} = $csv_source ? 'CSV' : 'DB';

    return $aggregate_data;
}

sub filter {
    my ($draw) = @_;

    if ($draw->{'SEQUENCE NUMBER'} != VALID_SEQUENCE_NUMBER
        || $draw->{'DRAW NUMBER'} > MAX_DRAW_NUMBER){
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

sub _calculate_win_value {
    my ($draw) = @_;

    my $payout_key = $draw->{NUMBER_MATCHES};

    if ($payout_key && ($payout_key == 2 || $payout_key == 5)){
        if ($draw->{BONUS_MATCH}){
            $payout_key .= '+';
        }
    }

    return $payout_table->{$payout_key};
}

sub _compile_data {
    my ($all_draws, $display_all) = @_;

    my @winning_draws;
    my $total_spent_on_tickets;
    my $total_number_payout;

    for my $draw (@$all_draws) {

        $total_spent_on_tickets += ticket_price($draw);

        next if $draw->{NUMBER_MATCHES} < 2;

        $total_number_payout += _draw_payout($draw);

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
    };

    return $data;
}

sub _draw_payout {
    my ($draw) = @_;
    return _calculate_win_value($draw);
}

1;

__END__

=head1 NAME

BCLC::Numbers - Calculate Lotto 649 historical win information

=head1 DESCRIPTION

Using historical data (CSV or SQLite database), calculate and display win
information based on six unique numbers entered via a web UI.

=head1 REST ROUTES

=head2 /

Landing page. Loads up the C<main> L<Template::Toolkit> template that provides
the number inputs and various options.

This route is a C<get> request.

Takes no parameters, has no return.

=head2 /fetch_data/:params

This route front-ends the core workload of the application. It fetches and
returns all calculated draw information based on the numbers provided.

Parameters:

All parameters are passed in as a JSON string, converted to a Perl hash.

    numbers => [1, 2, 3, 4, 5, 6]

Six unique numbers within the range 1-49. Will C<croak()> if any of the numbers
are out of range, or non-unique.

    display_all => bool

By default, only wins $85 or higher will be displayed in the UI. Set this to
true to have all wins regardless of the value displayed on-screen.

Default: false

    csv_source => bool

This software has the optional ability to read directly from the CSV file
provided by BCLC, or an SQLite database containing the same data. Set this param
to C<true> to use the CSV reader.

Default: false

=head1 FUNCTIONS

=head2 convert_to_dollar($int)

Using L<Number::Format> convert an integer into a properly formatted dollar
string (eg: C<3000> becomes C<$3,000.00>).

Parameters:

    $int

Mandatory, Integer (or float): The integer or float you want converted to a
dollar string.

Return: Formatted dollar string.

=head2 fetch_data($player_numbers, $display_all, $csv_source)

Fetches, compiles, filters and aggregates all draw data.

Parameters:

    $player_numbers

Mandatory, Array Reference: An array reference of the six unique lotto numbers
between C<1> and C<49>.

    $display_all

Optional, bool: Set this to true to have all wins returned. By default, we only
calculate wins C<$85> or more as valid. Defaults to C<true> (C<1>).

    $csv_source

Optional, bool: Set to C<true> (C<1>), and we'll read our draw information from
BCLC's Lotto 649 historical CSV file directly. Send in C<false> (C<0>) to
read from a pre-compiled SQLite database containing the contents of the CSV.
Defaults to C<true>.

Return: Hash Reference. If any errors occurred, you'll receive two key/value
pairs: C<error => 1, error_message => "string">. Otherwise you'll receive a
valid data-filled href ready for processing.

=head2 filter($draw)

Performs any/all necessary filtering of draws from the aggregate pool.

Parameters:

    $draw

Mandatory, hash reference: A Lotto 649 draw hash reference as returned within
the array reference from the C<retrieve()> function from either L<BCLC::DB> or
L<BCLC::CSV>.

Return: C<1> (C<true>) if the draw sent in should be filtered out/skipped, and
C<0> (C<false) if it's a valid draw.

=head2 payout_table

Returns a hash reference where the keys are the possible number match
combinations, and the values the dollar amount for each.

Takes no parameters.

Return: Hash Reference

=head2 ticket_price($draw)

Calculates the price of a ticket for an individual draw.

Parameters:

    $draw

Mandatory, hash reference: A Lotto 649 draw hash reference as returned within
the array reference from the C<retrieve()> function from either L<BCLC::DB> or
L<BCLC::CSV>.

Return, Integer: The cost of an individual draw's ticket.

=head1 PRIVATE FUNCTIONS

=head2 _calculate_win_value($draw)

Calculates the win value of a single draw.

Parameters:

    $draw

Mandatory, hash reference: A Lotto 649 draw hash reference as returned within
the array reference from the C<retrieve()> function from either L<BCLC::DB> or
L<BCLC::CSV>.

Return: An integer representing the dollar amount of the win for the draw
specified. Returns C<0> if no wins resulted.

=head2 _compile_data($all_draws, $display_all)

Compiles all the various data related to all draws.

Parameters:

    $all_draws

Mandatory, Array of Hashes: An array containing the full list of all draws as
returned by the C<retrieve()> method in L<BCLC::DB> or L<BCLC::CSV>.

    $display_all

Optional, bool: Send in a true value (eg C<1>) to have all wins compiled as
opposed to the default wins of $85 or higher. Defaults to false.

Return: A hash reference in the following format:

    winning_draws           => \@winning_draws,
    total_spent_on_tickets  => convert_to_dollar($total_spent_on_tickets),
    total_number_payout     => convert_to_dollar($total_number_payout),
    net_win_loss            => $net_win_loss,

=head2 _draw_payout($draw)

Returns the calculated payout of an individual draw.

Parameters:

    $draw

Mandatory, hash reference: A Lotto 649 draw hash reference as returned within
the array reference from the C<retrieve()> function from either L<BCLC::DB> or
L<BCLC::CSV>.

Return: Integer, the dollar amount won in the draw.

=head1 AUTHOR

Steve Bertrand, C<< <steve.bertrand at gmail.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2019 Steve Bertrand.

Released under the Apache License, Version 2

