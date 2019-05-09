use strict;
use warnings;

use Data::Dumper;
use Test::More;

use BCLC::Numbers::DB;

my $db;

my $obj_creation_ok = eval {
    $db = BCLC::Numbers::DB->new;
    1;
};

is $obj_creation_ok, undef, "new() croaks if db name not sent in";

$db = BCLC::Numbers::DB->new('data/649.db');

isa_ok $db, 'BCLC::Numbers::DB', "object is in the correct class";

my $sth;

$sth = $db->db->prepare(
#    "SELECT * FROM historical"
    "SELECT * FROM historical where [DRAW NUMBER] = ?"
);

for (1..100){
    $sth->execute($_);
    is $sth->fetchrow_hashref->{'DRAW NUMBER'}, $_, "draw num $_ returns ok";
}

done_testing();



