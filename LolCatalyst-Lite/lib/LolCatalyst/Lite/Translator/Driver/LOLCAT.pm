package LolCatalyst::Lite::Translator::Driver::LOLCAT;
use Moose;
use namespace::clean -except => 'meta';
use Acme::LOLCAT ();

sub translate {
	my ($self, $text) = @_;
	return Acme::LOLCAT::translate($text);
}

1;
