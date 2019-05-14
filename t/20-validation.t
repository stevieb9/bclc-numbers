use strict;
use warnings;

use BCLC::Numbers;
use Data::Dumper;
use Test::More;

{
    # CSV

    my $ret;

    my @nums = qw(1 2 3 4 5 6);

    $ret = BCLC::Numbers::fetch_data(\@nums);

    is $ret->{data_source}, 'CSV', "source: CSV ok";
    is ref $ret->{winning_draws}, 'ARRAY', "with ok nums, we get a proper href";
    is exists $ret->{total_number_payout}, 1, "total payout key exists";
    is exists $ret->{total_spent_on_tickets}, 1, "total spent on tickets exists";
    is $ret->{error}, 0, "no errors were flagged in the backend";
    is $ret->{total_spent_on_tickets}, '$5,747.00', "total spent on tix value ok";

    for (50 .. 101) {
        my $ret = BCLC::Numbers::fetch_data([ 1, 2, 3, 4, 5, $_ ]);
        is $ret->{error}, 1, "with $_ as a num, a backend error is flagged";
        like $ret->{error_msg}, qr/One or more numbers/, "...and error msg is sane";
    }

    for (1 .. 49) {
        my $ret = BCLC::Numbers::fetch_data([ $_, 2, 3, 4, 5, $_ ]);
        is $ret->{error}, 1, "with $_ as dup, a backend error is flagged";
        like $ret->{error_msg}, qr/One or more numbers/, "...and error msg is sane";
    }

    my $stop = 0;
    my $num = 6;

    while (!$stop) {
        my $ret = BCLC::Numbers::fetch_data([ 1, 2, 3, 4, 5, $num ]);

        is $ret->{data_source}, 'CSV', "source: CSV ok";
        is ref $ret->{winning_draws}, 'ARRAY', "$num: we get a proper href";
        is exists $ret->{total_number_payout}, 1, "$num: total payout key exists";
        is exists $ret->{total_spent_on_tickets}, 1, "$num: total spent on tickets exists";
        is $ret->{error}, 0, "$num: no errors were flagged in the backend";
        is $ret->{total_spent_on_tickets}, '$5,747.00', "$num: total spent on tix value ok";

        $stop = 1 if $num == 49;

        $num++;
    }
}

{ # DB

    my $ret;

    my @nums = qw(1 2 3 4 5 6);

    $ret = BCLC::Numbers::fetch_data(\@nums, 0, 0);

    is $ret->{data_source}, 'DB', "source: DB ok";
    is ref $ret->{winning_draws}, 'ARRAY', "with ok nums, we get a proper href";
    is exists $ret->{total_number_payout}, 1, "total payout key exists";
    is exists $ret->{total_spent_on_tickets}, 1, "total spent on tickets exists";
    is $ret->{error}, 0, "no errors were flagged in the backend";
    is $ret->{total_spent_on_tickets}, '$5,747.00', "total spent on tix value ok";

    for (50 .. 101) {
        my $ret = BCLC::Numbers::fetch_data([ 1, 2, 3, 4, 5, $_ ], 0, 0);
        is $ret->{error}, 1, "with $_ as a num, a backend error is flagged";
        like $ret->{error_msg}, qr/One or more numbers/, "...and error msg is sane";
    }

    for (1 .. 49) {
        my $ret = BCLC::Numbers::fetch_data([ $_, 2, 3, 4, 5, $_ ], 0, 0);
        is $ret->{error}, 1, "with $_ as dup, a backend error is flagged";
        like $ret->{error_msg}, qr/One or more numbers/, "...and error msg is sane";
    }

    my $stop = 0;
    my $num = 6;

    while (!$stop) {
        my $ret = BCLC::Numbers::fetch_data([ 1, 2, 3, 4, 5, $num ], 0, 0);

        is $ret->{data_source}, 'DB', "source: DB ok";
        is ref $ret->{winning_draws}, 'ARRAY', "$num: we get a proper href";
        is exists $ret->{total_number_payout}, 1, "$num: total payout key exists";
        is exists $ret->{total_spent_on_tickets}, 1, "$num: total spent on tickets exists";
        is $ret->{error}, 0, "$num: no errors were flagged in the backend";
        is $ret->{total_spent_on_tickets}, '$5,747.00', "$num: total spent on tix value ok";

        $stop = 1 if $num == 49;

        $num++;
    }
}

done_testing();
