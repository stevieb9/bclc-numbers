use strict;
use warnings;

use Data::Dumper;
use Test::More;

use BCLC::Numbers;

my $draw;

for (1..2124){
    $draw->{'DRAW NUMBER'} = $_;
    is
        BCLC::Numbers::ticket_price($draw),
        1,
        "draw $_ returns correct ticket price (1)";
}

for (2125..2989){
    $draw->{'DRAW NUMBER'} = $_;
    is
        BCLC::Numbers::ticket_price($draw),
        2,
        "draw $_ returns correct ticket price (2)";
}

for (2990..3621){
    $draw->{'DRAW NUMBER'} = $_;
    is
        BCLC::Numbers::ticket_price($draw),
        3,
        "draw $_ returns correct ticket price (3)";
}

done_testing();



