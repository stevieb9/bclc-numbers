use strict;
use warnings;

use Data::Dumper;
use Test::More;

use BCLC::Numbers;
use BCLC::Numbers::DB;

$| = 1;

my $db;

my $obj_creation_ok = eval {
    $db = BCLC::Numbers::DB->new;
    1;
};

is $obj_creation_ok, undef, "new() croaks if db name not sent in";

$db = BCLC::Numbers::DB->new('data/649.db');

isa_ok $db, 'BCLC::Numbers::DB', "object is in the correct class";

{ # db access
    my $sth;

    $sth = $db->_db->prepare(
        #    "SELECT * FROM historical"
        "SELECT * FROM historical where [DRAW NUMBER] = ?"
    );

    for (1 .. 100) {
        $sth->execute($_);
        is $sth->fetchrow_hashref->{'DRAW NUMBER'}, $_, "draw num $_ returns ok";
    }
}

{
    # check rows integrity

    $db = BCLC::Numbers::DB->new('data/649.db');
    my $data = $db->retrieve(table => 'historical');

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
