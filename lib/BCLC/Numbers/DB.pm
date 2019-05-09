package BCLC::Numbers::DB;

use warnings;
use strict;

use Carp qw(croak);
use DBI;

our $VERSION = '0.01';

sub new {
    my ($class, $db_file) = @_;

    my $self = bless {}, $class;

    if (! defined $db_file){
        croak "new() requires a database file name to be sent in...";
    }

    $self->{db} = DBI->connect(
        "dbi:SQLite:dbname=$db_file",
        "",
        "",
        {
            #sqlite_use_immediate_transaction => 1,
            RaiseError => $self->{db_err},
            AutoCommit => 1
        }
    ) or die $DBI::errstr;

    return $self->{db};
}
