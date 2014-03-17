package LolCatalyst::Lite::Model::SnippetStore;

use strict;
use warnings;
use aliased 'LolCatalyst::Lite::Translator';
use parent 'Catalyst::Model::Adaptor';

__PACKAGE__->config(
	class => 'LolCatalyst::Lite::SnippetStore',
	args => { translator => Translator->new }
);

1;
