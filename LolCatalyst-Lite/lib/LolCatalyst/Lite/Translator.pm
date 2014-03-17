package LolCatalyst::Lite::Translator;
use Moose;
use aliased 'LolCatalyst::Lite::Interface::TranslationDriver';
use namespace::clean -except => 'meta';
use Module::Pluggable::Object;

has 'default_target' => (
	is => 'ro', isa => 'Str', required => 1, default => 'LOLCAT'
);

has '_translators' => (
	is => 'ro', isa => 'HashRef', lazy_build => 1
);

sub translate {
	my ($self, $text) = @_;
	$self->translate_to($self->default_target, $text);
}

sub translate_to {
	my ($self, $target, $text) = @_;
	$self->_translators->{$target}->translate($text);
}

sub _build__translators {
	my ($self) = @_;

	my $base = __PACKAGE__ . '::Driver';
	my $mp = Module::Pluggable::Object->new(
		search_path => [ $base ]
	);
	my @classes = $mp->plugins;

	my $translators = {};
	for my $class (@classes) {
		Class::MOP::load_class($class);

		unless ($class->does(TranslationDriver)) {
			confess "Class ${class} in ${base}:: namespace does not implement Translation Driver interface";
		}

		(my $name = $class) =~ s/^\Q${base}::\E//;
		$translators->{$name} = $class->new;
	}

	return $translators;
}

=head1 NAME

LolCatalyst::Lite::Model::Translator - Catalyst Model

=head1 DESCRIPTION

Catalyst Model.


=encoding utf8

=head1 AUTHOR

Son Nguyen

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
