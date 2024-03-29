package LolCatalyst::Lite::Translator::Driver::Scramble;

use Moose;
with 'LolCatalyst::Lite::Interface::TranslationDriver';

sub shuffle {
	for ( my $i = @_; --$i; ) {
		my $j = int(rand($i + 1));
		@_[$i, $j] = @_[$j, $i];
	}
}

sub _scramble_word {
	my $word = shift || return '';
	my @piece = split //, $word;
	shuffle(@piece[1..$#piece - 1]) if @piece > 2;
	join('', @piece);
}

sub _scramble_block {
	my $text = shift;

	${$text} =~ s{
					( (?:(?<=[^[:alpha:]])|(?<=\A))
					  (?<!&)(?-x)(?<!&#)(?x)
					  (?:
						['[:alpha:]]+ | (?<!-)-(?!-)
					  )+
					  (?=[^[:alpha:]]|\z)
					)
				}
				{_scramble_word($1)}gex;
}

use namespace::clean -except => 'meta';

sub translate {
	my ($self, $text) = @_;
	_scramble_block(\$text);

	return $text;
}

1;
