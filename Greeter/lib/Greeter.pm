package Greeter;

use Moose;
use List::Util qw(first);

has guests => ( is => 'rw', isa => 'ArrayRef[Str]', default => sub { [] } );
has members => ( is => 'rw', isa => 'ArrayRef[Greeter::Member]', required => 1 );
has guest_greeting => ( is => 'ro', isa => 'Str', default => 'Hello __NAME__, I hope you are having a nice visit' );
has unknown_greeting => ( is => 'ro', isa => 'Str', default => "Hello __NAME__, I don't know you, do I?" );

sub greet {
	my ($self, $greeting_name, $greetee_name) = @_;
	my $greeting;
	
	# ideally we should check that we know this person before calling _greet_person
	# with their name, so this is a minor security problem.
	if (! $greetee_name || $greeting_name eq $greetee_name) {
		$greeting = $self->_greet_person($greeting_name);
	} else {
		$greeting = $self->_greet_other_person($greeting_name, $greetee_name);
	}

	return $greeting;
}

sub _greet_person {
	my ($self, $name) = @_;
	my $greeting;

	# find member
	my ($member, $guest);
	if ($member = first { $_->name eq $name } @{$self->members}) {
		$greeting = $member->greeting;
	}

	# find guest
	elsif ($guest = first { $_ eq $name } @{$self->guests}) {
		$greeting = $self->_greet_guest($name);
	}

	# else unknown
	else {
		$greeting = $self->_greet_unknown($name);
	}

	return $greeting;
}

sub _greet_other_person {
	my ($self, $greeter, $greetee) = @_;
	my $greeting;

	# this is a bit of a shortcut we'd refactor if performance was important
	# but it improves the presentation of code right now
	my $members_greeting = first { $_->name eq $greeter } @{$self->members};
	my $member_to_greet = first { $_->name eq $greetee } @{$self->members};

	my $guests_greeting = first { $_ eq $greeter } @{$self->guests};
	my $guest_to_greet = first { $_ eq $greetee } @{$self->guests};

	# greeter and greetee are both members
	if ($members_greeting && $member_to_greet) {
		$greeting = $members_greeting->greet_guest($member_to_greet->name);
	}

	# greeter and greetee are respectively member and guest
	elsif ($members_greeting && $guest_to_greet) {
		$greeting = $members_greeting->greet_guest($guest_to_greet);
	}

	# greeter and greetee are both guests
	elsif ($guests_greeting && $guest_to_greet) {
		$greeting = $self->_greet_guest($greetee);
	}

	# greetee is a member and greeter is a guest or unknown
	elsif ($member_to_greet) {
		$greeting = $member_to_greet->greeting;
	}

	elsif ( !($members_greeting || $guests_greeting) && $guest_to_greet ) {
		$greeting = $self->_greet_guest($guest_to_greet);
	}

	# fallback
	else {
		$greeting = $self->_greet_unknown($greetee);
	}

	return $greeting;
}

sub _greet_unknown {
	my ($self, $name) = @_;
	my $greeting = $self->unknown_greeting;
	$greeting =~ s/__NAME__/$name/;

	return $greeting;
}

sub _greet_guest {
	my ($self, $name) = @_;
	my $greeting = $self->guest_greeting;
	$greeting =~ s/__NAME__/$name/;

	return $greeting;
}

1;

__END__
=head1 NAME

Greeter

=head1 SYNOPSIS

Programmer's library to store and retrieve member and guest greetings for a group of named individuals.

=head1 USAGE

my $member = Greeter::Member->new(name => 'Sleepy',
								  greeting_string => 'Night Night __NAME__'
								 );
my $greeter = Greeter->new(
				members => [ $member ],
				guests => [ qw(Homer Bart Marge Maggie) ],
				guest_greeting => 'Hello __NAME__, I hope you are having a nice visit',
				unknown_greeting => 'Hello __NAME__, I don't know you, do I?'
				);

=head1 METHODS

=head2 greet($greeting_name, $greetee_name)

Returns an appropriate greeting for an individual of the name passed in as an
argument if only one argument is present or if the two arguments are the same
name. Returns the greeting string for $greeting_name with the name of
$greetee_name if two arguments are present.
