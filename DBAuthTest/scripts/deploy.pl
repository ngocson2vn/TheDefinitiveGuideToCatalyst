#!/usr/bin/env perl

use strict;
use warnings;

## Tell perl which directory Auth::Schema is in:
use FindBin qw($Bin);
use lib "$Bin/../lib";
use Auth::Schema;

## Collect the database type, name, user, and password
## from the command line:
my $newdb_type = shift;
my $newdb_name = shift;
my $newdb_user = shift;
my $newdb_pass = shift;

## Create the schema object using the database connection info from above:
my $schema = Auth::Schema->connect(
							"dbi:${newdb_type}:${newdb_name}", 
							$newdb_user, $newdb_pass);

## Call the deploy method on the schema object:
$schema->deploy();
