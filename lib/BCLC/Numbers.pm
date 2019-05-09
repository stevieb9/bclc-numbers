package BCLC::Numbers;

use strict;
use warnings;

our $VERSION = '0.01';

use BCLC::Numbers::DB;
use Dancer2;
use Dancer2::Core::Request;

my $db_file = 'data/649.db';

my $db = BCLC::Numbers::DB->new($db_file);

get '/' => sub {
    return template 'main';
};

1;

__END__

=head1 NAME

BCLC::Numbers - Calculate 649 historical wins

=head1 AUTHOR

Steve Bertrand, C<< <steve.bertrand at gmail.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2019 Steve Bertrand.

