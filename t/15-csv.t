use strict;
use warnings;

use Data::Dumper;
use Test::More;

use BCLC::Numbers;
use BCLC::Numbers::CSV;

my $csv;

my $obj_creation_ok = eval {
    $csv = BCLC::Numbers::CSV->new;
    1;
};

is $obj_creation_ok, undef, "new() croaks if CSV file name not sent in";

my $valid_file = eval {
    $csv = BCLC::Numbers::CSV->new('data/none');
    $csv->retrieve;
    1;
};

is $valid_file, undef, "new() croaks if CSV file can't be opened/read";

$csv = BCLC::Numbers::CSV->new('data/649.csv');

isa_ok $csv, 'BCLC::Numbers::CSV', "object is in the correct class";

{ # file data access

    my $draws = $csv->retrieve;

}

{
    # check rows integrity

    $csv = BCLC::Numbers::CSV->new('data/649.csv');
    my $data = $csv->retrieve;

    my @invalid_sequence_draws_found;
    my @invalid_draw_number_draws_found;
    my @valid_draws;

    for (@$data) {

        if (BCLC::Numbers::filter($_)){
            next;
        }

        if ($_->{'SEQUENCE NUMBER'} != 0) {
            push @invalid_sequence_draws_found, $_->{'DRAW NUMBER'};
        }

        if ($_->{'DRAW NUMBER'} > 3620){
            push @invalid_draw_number_draws_found, $_->{'DRAW NUMBER'};
        }

        push @valid_draws, $_;
    }

    is
        scalar @invalid_sequence_draws_found,
            0,
            "no draws with invalid sequence found";

    is
        scalar @invalid_draw_number_draws_found,
            0,
            "no draws with invalid draw number found";

    is scalar @valid_draws, 3620, "total number of draws ok";

    my $i = 1;

    for (@valid_draws){
#        is
#            $_->{'DRAW NUMBER'},
#            $i,
#            "draw number $_->{'DRAW NUMBER'} has correct num $i";

        $i++;
    }
}

done_testing();
