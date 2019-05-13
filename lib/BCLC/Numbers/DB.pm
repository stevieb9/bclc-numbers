package BCLC::Numbers::DB;

use warnings;
use strict;

use Carp qw(croak);
use DBI qw(:sql_types);

our $VERSION = '0.01';

sub new {
    my ($class, $db_file) = @_;

    my $self = bless {}, $class;

    if (! defined $db_file){
        croak "new() requires a database file name to be sent in...";
    }

    $self->{db} = DBI->connect(
        "dbi:SQLite:dbname=$db_file",
        '',
        '',
        {
            #sqlite_use_immediate_transaction => 1,
            #sqlite_see_if_its_a_number => 1,
            RaiseError => $self->{db_err},
            AutoCommit => 1
        }
    ) or die $DBI::errstr;

    return $self;
}

sub retrieve {
    my ($self, %args) = @_;

    my $table = $args{table};

    if (! defined $table){
        croak "retrieve() requires a table name sent in...";
    }

    my $sth = $self->db->prepare("SELECT * FROM $table");

    $sth->execute;

    return $sth->fetchall_arrayref({});
}

sub _db {
    return $_[0]->{db};
}
1;

__END__

=head1 NAME

BCLC::Numbers::DB - Provides database backend support for L<BCLC::Numbers>
L<Dancer2> web application

=head1 DESCRIPTION

Object Oriented module that provides database access for L<BCLC::Numbers>

=head1 METHODS

=head2 new($db_file)

Instantiates and returns a new L<BCLC::Numbers::DB> object, ready to process
requests.

Parameters:

    $db_file

Mandatory, String: The path and file name of the SQLite database file.

Return: An object of class L<BCLC::Numbers::DB>

=head2 retrieve(%args)

Compiles the entire Lotto 649 historical draw information.

Parameters:

All parameters are sent in as a hash.

    table => 'table_name'

Mandatory, String: The name of the database table to operate on.

Return: An Array Reference of Hash References, where each hash ref contains
the dataset's column name as the key, and its associated value as the value.

=head1 PRIVATE METHODS

=head2 _db

Returns the SQLite database connected object stored within the object.

Takes no parameters.

=head1 AUTHOR

Steve Bertrand, C<< <steve.bertrand at gmail.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2019 Steve Bertrand.

Released under the Apache License, Version 2

