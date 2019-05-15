# BCLC Numbers

A Perl, [Dancer2](https://metacpan.org/pod/Dancer2)-based web application with a
front-end that allows a user to input the six numbers related to BCLC's Lotto
6/49 draws, and returns historical win/loss information back to 1982.

## Table of Contents

- [Installation](#installation)
- [Using the UI](#using-the-ui)
- [Options](#options)

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

- Go to the web page `http://localhost:5000` (replace `localhost` with your 
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

REQ59847, IS27 Full Stack Developer
Due date: May 15, 2019 at 1:00 pm Pacitic Time
For questions, please email: Dea.DeJarisco@gov.bc.ca
