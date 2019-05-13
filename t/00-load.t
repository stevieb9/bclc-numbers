use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'BCLC::Numbers' ) || print "Bail out!\n";
}

diag( "Testing BCLC::Numbers $BCLC::Numbers::VERSION, Perl $], $^X" );
