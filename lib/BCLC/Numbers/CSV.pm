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
