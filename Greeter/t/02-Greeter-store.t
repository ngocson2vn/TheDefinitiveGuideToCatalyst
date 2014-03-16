#!/usr/bin/env perl

use warnings;
use strict;
use Test::More tests => 12;

BEGIN {
	use_ok('Greeter');
}

use Greeter::Member;
my $member = Greeter::Member->new(name => 'Sleepy', greeting_string => 'Night Night __NAME__');
my $greeter = Greeter->new(members => [ $member ], guests => [ qw(Homer Bart Marge Maggie) ]);

cmp_ok(ref($greeter->members->[0]), 'eq', 'Greeter::Member');
cmp_ok($greeter->guests->[0], 'eq', 'Homer');

# greet guest
cmp_ok($greeter->greet('Homer'), 'eq', 'Hello Homer, I hope you are having a nice visit',
						'greet guest');

# greet unknown
cmp_ok($greeter->greet('Papa Smurf'), 'eq',
						"Hello Papa Smurf, I don't know you, do I?",
						'greet unknown');

# greet member
cmp_ok($greeter->greet('Sleepy'), 'eq', 'Night Night Sleepy', 'got member');

# greet member 2 with member 1's greeting
my $member2 = Greeter::Member->new(name => 'Sneezy',
									greeting_string => 'Bless you __NAME__!');
$greeter->members([ $member, $member2 ]);
cmp_ok($greeter->greet('Sneezy', 'Sleepy'), 'eq',
						"Bless you Sleepy!", 'atchoo!');

# greet guest with members' greeting
cmp_ok($greeter->greet('Sneezy', 'Homer'), 'eq',
						"Bless you Homer!", 'atchoo! DOH!');

# try to greet member with guest's greeting
cmp_ok($greeter->greet('Homer', 'Sneezy'), 'eq',
						'Bless you Sneezy!', 'no-op');

# try to greet guest with guest
cmp_ok($greeter->greet('Bart', 'Homer'), 'eq',
						'Hello Homer, I hope you are having a nice visit',
						'greet guest take 2');

# try to greet guest with unknown
cmp_ok($greeter->greet('Bart', 'Papa Smurf'), 'eq',
						"Hello Papa Smurf, I don't know you, do I?",
						'greet unknown 2');

# try to greet unknown with guest
cmp_ok($greeter->greet('Papa Smurf', 'Bart'), 'eq',
						'Hello Bart, I hope you are having a nice visit',
						'greet guest take 3');















