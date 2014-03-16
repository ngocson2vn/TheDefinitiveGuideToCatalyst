package Greeter::Member;

use Moose;

has 'name' => (is => 'ro', isa => 'Str', required => 1);
has 'greeting_string' => (is => 'ro', isa => 'Str', required => 1);
has 'greeting' => (is => 'ro', isa => 'Str', lazy_build => 1);

sub greet_guest {
	my ($self, $name) = @_;
	die "A name argument is required to greet a guest" if ! $name;
	my $greeting = $self->greeting_string;
	$greeting =~ s/__NAME__/$name/;

	return $greeting;
}

sub _build_greeting {
	my $self = shift;
	my $greeting = $self->greeting_string;
	my $name = $self->name;
	$greeting =~ s/__NAME__/$name/;

	return $greeting;
}

1;

__END__
=head1 NAME

Greeter::Member

=head1 SYNOPSIS

Stores a name and a greeting, and provides a string to greet the individual by name.

my $member = Greeter::Member->new(

						name => 'Sleepy',
						greeting_string => 'Night Night __NAME__'
				);
print $member->greeting, "\n";
print $member->greet_guest('Homer'), "\n";

=head1 METHODS

=head2 greet_guest

Receives an argument indicating the name of the guest to greet:
$member->greet_guest('Bart'). Checking whether ther member is authorized
 to greet this guest is not performed in this package.
