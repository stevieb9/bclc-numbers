# NAME

BCLC::Numbers::DB - Provides database backend support for [BCLC::Numbers](https://metacpan.org/pod/BCLC::Numbers)
[Dancer2](https://metacpan.org/pod/Dancer2) web application

# DESCRIPTION

Object Oriented module that provides database access for [BCLC::Numbers](https://metacpan.org/pod/BCLC::Numbers)

# METHODS

## new($db\_file)

Instantiates and returns a new [BCLC::Numbers::DB](https://metacpan.org/pod/BCLC::Numbers::DB) object, ready to process
requests.

Parameters:

    $db_file

Mandatory, String: The path and file name of the SQLite database file.

Return: An object of class [BCLC::Numbers::DB](https://metacpan.org/pod/BCLC::Numbers::DB)

## retrieve(%args)

Compiles the entire Lotto 649 historical draw information.

Parameters:

All parameters are sent in as a hash.

    table => 'table_name'

Mandatory, String: The name of the database table to operate on.

Return: An Array Reference of Hash References, where each hash ref contains
the dataset's column name as the key, and its associated value as the value.

# PRIVATE METHODS

## \_db

Returns the SQLite database connected object stored within the object.

Takes no parameters.

# AUTHOR

Steve Bertrand, `<steve.bertrand at gmail.com>`

# LICENSE AND COPYRIGHT

Copyright 2019 Steve Bertrand.

Released under the Apache License, Version 2
