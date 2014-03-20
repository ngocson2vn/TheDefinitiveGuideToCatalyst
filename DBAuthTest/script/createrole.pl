#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";
use Auth::Schema;
use Data::Dumper;

## Get the name of the new role from the command line:
my $rolename = shift;

## Now create a schema object, by passing the database connection information:
my $schema = Auth::Schema->connect('dbi:SQLite:db/auth.db');

## Fetch the ResultSet for the Role class:
my $roles_rs = $schema->resultset('Role');

## This is the equivalent to the catalyst model code:
# my $roles_rs = $c->model('AuthDB::Role');

## Create the role row in the database:
my $newrole = $roles_rs->create({ role => $rolename });

## Print the results just to check:
print "Created role: ", Dumper({ $newrole->get_columns });
