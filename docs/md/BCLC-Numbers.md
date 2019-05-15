# NAME

BCLC::Numbers - Calculate Lotto 649 historical win information

# DESCRIPTION

Using historical data (CSV or SQLite database), calculate and display win
information based on six unique numbers entered via a web UI.

# REST ROUTES

## /

Landing page. Loads up the `main` [Template::Toolkit](https://metacpan.org/pod/Template::Toolkit) template that provides
the number inputs and various options.

This route is a `get` request.

Takes no parameters, has no return.

## /fetch\_data/:params

This route front-ends the core workload of the application. It fetches and
returns all calculated draw information based on the numbers provided.

Parameters:

All parameters are passed in as a JSON string, converted to a Perl hash.

    numbers => [1, 2, 3, 4, 5, 6]

Six unique numbers within the range 1-49. Will `croak()` if any of the numbers
are out of range, or non-unique.

    display_all => bool

By default, only wins $85 or higher will be displayed in the UI. Set this to
true to have all wins regardless of the value displayed on-screen.

Default: false

    csv_source => bool

This software has the optional ability to read directly from the CSV file
provided by BCLC, or an SQLite database containing the same data. Set this param
to `true` to use the CSV reader.

Default: false

# FUNCTIONS

## convert\_to\_dollar($int)

Using [Number::Format](https://metacpan.org/pod/Number::Format) convert an integer into a properly formatted dollar
string (eg: `3000` becomes `$3,000.00`).

Parameters:

    $int

Mandatory, Integer (or float): The integer or float you want converted to a
dollar string.

Return: Formatted dollar string.

## fetch\_data($player\_numbers, $display\_all, $csv\_source)

Fetches, compiles, filters and aggregates all draw data.

Parameters:

    $player_numbers

Mandatory, Array Reference: An array reference of the six unique lotto numbers
between `1` and `49`.

    $display_all

Optional, bool: Set this to true to have all wins returned. By default, we only
calculate wins `$85` or more as valid. Defaults to `true` (`1`).

    $csv_source

Optional, bool: Set to `true` (`1`), and we'll read our draw information from
BCLC's Lotto 649 historical CSV file directly. Send in `false` (`0`) to
read from a pre-compiled SQLite database containing the contents of the CSV.
Defaults to `true`.

## filter($draw)

Performs any/all necessary filtering of draws from the aggregate pool.

Parameters:

    $draw

Mandatory, hash reference: A Lotto 649 draw hash reference as returned within
the array reference from the `retrieve()` function from either [BCLC::DB](https://metacpan.org/pod/BCLC::DB) or
[BCLC::CSV](https://metacpan.org/pod/BCLC::CSV).

Return: `1` (`true`) if the draw sent in should be filtered out/skipped, and
`0` (`false) if it's a valid draw.`

## payout\_table

Returns a hash reference where the keys are the possible number match
combinations, and the values the dollar amount for each.

Takes no parameters.

Return: Hash Reference

## ticket\_price($draw)

Calculates the price of a ticket for an individual draw.

Parameters:

    $draw

Mandatory, hash reference: A Lotto 649 draw hash reference as returned within
the array reference from the `retrieve()` function from either [BCLC::DB](https://metacpan.org/pod/BCLC::DB) or
[BCLC::CSV](https://metacpan.org/pod/BCLC::CSV).

Return, Integer: The cost of an individual draw's ticket.

# PRIVATE FUNCTIONS

## \_calculate\_win\_value($draw)

Calculates the win value of a single draw.

Parameters:

    $draw

Mandatory, hash reference: A Lotto 649 draw hash reference as returned within
the array reference from the `retrieve()` function from either [BCLC::DB](https://metacpan.org/pod/BCLC::DB) or
[BCLC::CSV](https://metacpan.org/pod/BCLC::CSV).

Return: An integer representing the dollar amount of the win for the draw
specified. Returns `0` if no wins resulted.

## \_compile\_data($all\_draws, $display\_all)

Compiles all the various data related to all draws.

Parameters:

    $all_draws

Mandatory, Array of Hashes: An array containing the full list of all draws as
returned by the `retrieve()` method in [BCLC::DB](https://metacpan.org/pod/BCLC::DB) or [BCLC::CSV](https://metacpan.org/pod/BCLC::CSV).

    $display_all

Optional, bool: Send in a true value (eg `1`) to have all wins compiled as
opposed to the default wins of $85 or higher. Defaults to false.

Return: A hash reference in the following format:

    winning_draws           => \@winning_draws,
    total_spent_on_tickets  => convert_to_dollar($total_spent_on_tickets),
    total_number_payout     => convert_to_dollar($total_number_payout),
    net_win_loss            => $net_win_loss,

## \_draw\_payout($draw)

Returns the calculated payout of an individual draw.

Parameters:

    $draw

Mandatory, hash reference: A Lotto 649 draw hash reference as returned within
the array reference from the `retrieve()` function from either [BCLC::DB](https://metacpan.org/pod/BCLC::DB) or
[BCLC::CSV](https://metacpan.org/pod/BCLC::CSV).

Return: Integer, the dollar amount won in the draw.

# AUTHOR

Steve Bertrand, `<steve.bertrand at gmail.com>`

# LICENSE AND COPYRIGHT

Copyright 2019 Steve Bertrand.

Released under the Apache License, Version 2

# POD ERRORS

Hey! **The above document had some coding errors, which are explained below:**

- Around line 295:

    Unterminated C<...> sequence
