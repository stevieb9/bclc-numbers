# NAME

BCLC::Numbers::core.js - Provides front-end UI logic for the [BCLC::Numbers](https://metacpan.org/pod/BCLC::Numbers) [Dancer2](https://metacpan.org/pod/Dancer2) web
application

# DESCRIPTION

Automation and REST API client which takes care of the various dynamic UI
components.

# FUNCTIONS

## display\_data

Compiles the REST API call parameters, performs user-side number validation,
retrieves the relevant data and information from the REST API, and is
responsible for hiding and displaying the various data tables dynamically, on
the fly.

Takes no parameters, returns `false` while not displaying anything to the page
if any errors are found.

## validate\_number(id, num)

Maintains a global lottery numbers object (hash containing the page element ID
as the keys, and the lotto number associate it with it as the value), and
verifies that the numbers are a) within the range of 1-49, and ensures there
are no duplicates.

Return: `true` if the number is clean, and `false` if it's either out of
range, or a duplicate of a previously supplied number.

# AUTHOR

Steve Bertrand, `<steve.bertrand at gmail.com>`

# LICENSE AND COPYRIGHT

Copyright 2019 Steve Bertrand.

Released under the Apache License, Version 2
