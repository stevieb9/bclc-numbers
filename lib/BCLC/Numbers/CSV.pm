package BCLC::Numbers::CSV;

use warnings;
use strict;

use Carp qw(croak);
use Data::Dumper;

our $VERSION = '0.01';

sub new {
    my ($class, $csv_file) = @_;

    if (! defined $csv_file){
        croak "new() requires a CSV file name to be sent in...";
    }

    my $self = bless {csv => $csv_file}, $class;

    return $self;
}

sub retrieve {
    my ($self) = @_;

    open my $csv_fh, '<', $self->{csv}
      or die "can't open CSV file $self->{csv}: $!";

    my @draws;
    my @headings;

    while (my $line = <$csv_fh>){
        chomp $line;

        if ($. == 1){
            @headings = split /,/, $line;
            next;
        }

        my %draw;

        @draw{@headings} = split /,/, $line;

        push @draws, \%draw;
    }

    return \@draws;
}

1;

__END__

=head1 NAME

BCLC::Numbers::CSV - Provides CSV file backend support for L<BCLC::Numbers>
L<Dancer2> web application

=head1 DESCRIPTION

Object Oriented module that provides CSV file access for L<BCLC::Numbers>

=head1 METHODS

=head2 new($csv_file)

Instantiates and returns a new L<BCLC::Numbers::CSV> object, ready to process
requests.

Parameters:

    $csv_file

Mandatory, String: The path and file name of the CSV file.

Return: An object of class L<BCLC::Numbers::CSV>

=head2 retrieve

Compiles the entire Lotto 649 historical draw information, using the CSV file.

Takes no parameters.

Return: An Array Reference of Hash References, where each hash ref contains
the dataset's column name as the key, and its associated value as the value.

=head1 AUTHOR

Steve Bertrand, C<< <steve.bertrand at gmail.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2019 Steve Bertrand.

Released under the Apache License, Version 2
