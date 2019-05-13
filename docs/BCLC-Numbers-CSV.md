# NAME

BCLC::Numbers::CSV - Provides CSV file backend support for [BCLC::Numbers](https://metacpan.org/pod/BCLC::Numbers)
[Dancer2](https://metacpan.org/pod/Dancer2) web application

# DESCRIPTION

Object Oriented module that provides CSV file access for [BCLC::Numbers](https://metacpan.org/pod/BCLC::Numbers)

# METHODS

## new($csv\_file)

Instantiates and returns a new [BCLC::Numbers::CSV](https://metacpan.org/pod/BCLC::Numbers::CSV) object, ready to process
requests.

Parameters:

    $csv_file

Mandatory, String: The path and file name of the CSV file.

Return: An object of class [BCLC::Numbers::CSV](https://metacpan.org/pod/BCLC::Numbers::CSV)

## retrieve

Compiles the entire Lotto 649 historical draw information, using the CSV file.

Takes no parameters.

Return: An Array Reference of Hash References, where each hash ref contains
the dataset's column name as the key, and its associated value as the value.

# AUTHOR

Steve Bertrand, `<steve.bertrand at gmail.com>`

# LICENSE AND COPYRIGHT

Copyright 2019 Steve Bertrand.

Released under the Apache License, Version 2
