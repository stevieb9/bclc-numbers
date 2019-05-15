# BCLC Numbers

A Perl, [Dancer2](https://metacpan.org/pod/Dancer2)-based web application with a
front-end that allows a user to input the six numbers related to BCLC's Lotto
6/49 draws, and returns historical win/loss information back to 1982.

## Table of Contents

- [Installation](#installation)
- [Using the UI](#using-the-ui)
- [Options](#options)
- [Documentation](#documentation)

## Installation

- Download the application's [zip file](https://github.com/ddejarisco/codechallenge-REQ59847-00003/archive/master.zip)
- Unzip the archive
- Change into the extracted directory
- `perl Makefile.PL`
- `make`
- `make test`
- `make install`
- Install [Plack](https://metacpan.org/pod/Plack) using `cpanm Plack`
- Start the minimal web server: `plackup bin/app.pl`

## Using the UI

- Go to the web page [http://localhost:5000](http://localhost:5000) (replace `localhost` with your 
server's IP/DNS name if required)
- Type in six unique number into each one of the input text boxes. The border of
each box will turn green if the number is valid, and red if not. Warnings will
also be displayed dynamically to explain the specific problem
- The results are shown dynamically, immediately after we've collected six valid
numbers
- There is no submit button. For a new set of results, simply change one or more
of the previously entered numbers
- To reset all [Options](#options) listed on the page, as well as all of the
previously entered numbers, simply click the `Reset/Clear` button

## Options

There are a few options available on the page. Simply hover over the "Options"
in the top menu bar to access them.

#### Data Source

This option provides the user the ability to change between operating on either
the original CSV file of historical data, or a previously compiled SQLite 
database with the same CSV data.

##### Values

    CSV
    
Use the original CSV file as the data source. This is the default.

    DB
    
Use the previously compiled SQLite database for all operations.

#### Display UI Help

This checkbox toggles a basic list of help items on the screen dynamically.

#### Include wins less than $85

By default, we list in the results, wins that are $85 and up. Check this
checkbox to display all wins, regardless of the value.        

## Documentation

The various code files each have their own documentation in either markdown or
HTML format, in the `docs/md` and `public/docs` directories respectively.
Normally, Perl documentation is written in POD format, viewed cleanly on
MetaCPAN, but alas; this software is not published publicly. The POD format is
however available in code form, within the respective module files (there's
also a POD file for the `core.js` script, in the `docs/pod` directory).

##### [BCLC::Numbers](http://24.67.48.97:5000/docs/BCLC-Numbers.html)

This module houses the core REST API backend, and performs all of the
calculations and backend validation for the project.

##### [BCLC::Numbers::CSV](http://24.67.48.97:5000/docs/BCLC-Numbers-CSV.html)

The `CSV` module/class is responsible for reading in the historical CSV file,
and returning the aggregated data.

##### [BCLC::Numbers::DB](http://24.67.48.97:5000/docs/BCLC-Numbers-DB.html)

The `DB` module/class is responsible for performing the queries on the SQLite
database and returning the aggregated data.

##### [core.js](http://24.67.48.97:5000/docs/core.js.html)

This is the front-end, user-side script that performs all of the necessary
dynamic rendering of the UI, as well as provides live-time validation and
error/warning reporting directly to the user.



REQ59847, IS27 Full Stack Developer
Due date: May 15, 2019 at 1:00 pm Pacitic Time
For questions, please email: Dea.DeJarisco@gov.bc.ca
