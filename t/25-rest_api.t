use strict;
use warnings;

use BCLC::Numbers;
use Data::Dumper;
use JSON;
use Test::More;

eval "use REST::Client";

plan skip_all => "REST::Client not installed"  if $@;

my $c = REST::Client->new();

#
# CSV
#

{ # fetch_data/:params

    my $perl = {
        numbers         => [ qw(1 2 3 4 5) ],
        display_all => 0,
        csv_source  => 1,
    };

    my $json = to_json $perl;

    $c->GET("http://localhost:5000/fetch_data/$json");

    my $ret = from_json $c->responseContent;

    is $ret->{data_source}, 'CSV', "source: CSV ok";
    is ref $ret->{winning_draws}, 'ARRAY', "with ok nums, we get a proper href";
    is exists $ret->{total_number_payout}, 1, "total payout key exists";
    is exists $ret->{total_spent_on_tickets}, 1, "total spent on tickets exists";
    is $ret->{error}, 0, "no errors were flagged in the backend";
    is $ret->{total_spent_on_tickets}, '$5,747.00', "total spent on tix value ok";

    for (50 .. 101) {
        $perl = {
            numbers     => [1, 2, 3, 4, $_],
            display_all => 0,
            csv_source  => 1,
        };

        $json = to_json $perl;

        $c->GET("http://localhost:5000/fetch_data/$json");

        $ret = from_json $c->responseContent;

        is $ret->{error}, 1, "with $_ as a num, a backend error is flagged";
        like $ret->{error_msg}, qr/One or more numbers/, "...and error msg is sane";
    }

    for (1 .. 49) {
        $perl = {
            numbers     => [1, 2, 3, $_, $_],
            display_all => 0,
            csv_source  => 1,
        };

        $json = to_json $perl;

        $c->GET("http://localhost:5000/fetch_data/$json");

        $ret = from_json $c->responseContent;

        is $ret->{error}, 1, "with $_ as dup, a backend error is flagged";
        like $ret->{error_msg}, qr/One or more numbers/, "...and error msg is sane";
    }

    my $stop = 0;
    my $num = 6;

    while (!$stop) {
        $perl = {
            numbers     => [1, 2, 3, 4, $num],
            display_all => 0,
            csv_source  => 1,
        };

        $json = to_json $perl;

        $c->GET("http://localhost:5000/fetch_data/$json");

        $ret = from_json $c->responseContent;

        is $ret->{data_source}, 'CSV', "source: CSV ok";
        is ref $ret->{winning_draws}, 'ARRAY', "$num: we get a proper href";
        is exists $ret->{total_number_payout}, 1, "$num: total payout key exists";
        is exists $ret->{total_spent_on_tickets}, 1, "$num: total spent on tickets exists";
        is $ret->{error}, 0, "$num: no errors were flagged in the backend";
        is $ret->{total_spent_on_tickets}, '$5,747.00', "$num: total spent on tix value ok";

        $stop = 1 if $num == 49;

        $num++;
    }

     {
        $perl = {
            numbers     => [ 1, 2, 3, 4, $_ ],
            display_all => 1,
            csv_source  => 1,
        };

        $json = to_json $perl;

        $c->GET("http://localhost:5000/fetch_data/$json");

        my $ret_all = from_json $c->responseContent;

        $perl = {
            numbers     => [ 1, 2, 3, 4, $_ ],
            display_all => 0,
            csv_source  => 0,
        };

        $json = to_json $perl;

        $c->GET("http://localhost:5000/fetch_data/$json");

        my $ret_85 = from_json $c->responseContent;

        is
            scalar @{$ret_all->{winning_draws}} > scalar @{$ret_85->{winning_draws}},
            1,
            "when display_all param sent to the fetch_data route, we get more draws";
    }
}

#
# DB
#

{ # fetch_data/:params DB

    my $perl = {
        numbers         => [ qw(1 2 3 4 5) ],
        display_all => 0,
        csv_source  => 0,
    };

    my $json = to_json $perl;

    $c->GET("http://localhost:5000/fetch_data/$json");

    my $ret = from_json $c->responseContent;

    is $ret->{data_source}, 'DB', "source: DB ok";
    is ref $ret->{winning_draws}, 'ARRAY', "with ok nums, we get a proper href";
    is exists $ret->{total_number_payout}, 1, "total payout key exists";
    is exists $ret->{total_spent_on_tickets}, 1, "total spent on tickets exists";
    is $ret->{error}, 0, "no errors were flagged in the backend";
    is $ret->{total_spent_on_tickets}, '$5,747.00', "total spent on tix value ok";

    for (50 .. 101) {
        $perl = {
            numbers     => [1, 2, 3, 4, $_],
            display_all => 0,
            csv_source  => 0,
        };

        $json = to_json $perl;

        $c->GET("http://localhost:5000/fetch_data/$json");

        $ret = from_json $c->responseContent;

        is $ret->{error}, 1, "with $_ as a num, a backend error is flagged";
        like $ret->{error_msg}, qr/One or more numbers/, "...and error msg is sane";
    }

    for (1 .. 49) {
        $perl = {
            numbers     => [1, 2, 3, $_, $_],
            display_all => 0,
            csv_source  => 0,
        };

        $json = to_json $perl;

        $c->GET("http://localhost:5000/fetch_data/$json");

        $ret = from_json $c->responseContent;

        is $ret->{error}, 1, "with $_ as dup, a backend error is flagged";
        like $ret->{error_msg}, qr/One or more numbers/, "...and error msg is sane";
    }

    my $stop = 0;
    my $num = 6;

    while (!$stop) {
        $perl = {
            numbers     => [1, 2, 3, 4, $num],
            display_all => 0,
            csv_source  => 0,
        };

        $json = to_json $perl;

        $c->GET("http://localhost:5000/fetch_data/$json");

        $ret = from_json $c->responseContent;

        is $ret->{data_source}, 'DB', "source: DB ok";
        is ref $ret->{winning_draws}, 'ARRAY', "$num: we get a proper href";
        is exists $ret->{total_number_payout}, 1, "$num: total payout key exists";
        is exists $ret->{total_spent_on_tickets}, 1, "$num: total spent on tickets exists";
        is $ret->{error}, 0, "$num: no errors were flagged in the backend";
        is $ret->{total_spent_on_tickets}, '$5,747.00', "$num: total spent on tix value ok";

        $stop = 1 if $num == 49;

        $num++;
    }

    {
        $perl = {
            numbers     => [ 1, 2, 3, 4, $_ ],
            display_all => 1,
            csv_source  => 0,
        };

        $json = to_json $perl;

        $c->GET("http://localhost:5000/fetch_data/$json");

        my $ret_all = from_json $c->responseContent;

        $perl = {
            numbers     => [ 1, 2, 3, 4, $_ ],
            display_all => 0,
            csv_source  => 0,
        };

        $json = to_json $perl;

        $c->GET("http://localhost:5000/fetch_data/$json");

        my $ret_85 = from_json $c->responseContent;

        is
            scalar @{$ret_all->{winning_draws}} > scalar @{$ret_85->{winning_draws}},
            1,
            "when display_all param sent to the fetch_data route, we get more draws";
    }
}

done_testing;

