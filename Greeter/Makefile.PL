use 5.006;
use strict;
use warnings FATAL => 'all';
use inc::Module::Install;

name     'Greeter';
all_from 'lib/Greeter.pm';
author   q{Son Nguyen <ngocson2vn@gmail.com>};
license  'artistic2';

perl_version 5.006;

tests_recursive('t');

resources (
   #homepage   => 'http://yourwebsitehere.com',
   #IRC        => 'irc://irc.perl.org/#Greeter',
   license    => 'http://www.perlfoundation.org/artistic_license_2_0',
   #repository => 'git://github.com/Son Nguyen/Greeter.git',
   bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=Greeter',
);

configure_requires (
   'Module::Install' => 0,
);

build_requires (
   'Test::More' => 0,
);

requires (
   #'ABC'              => 1.6,
   #'Foo::Bar::Module' => 5.0401,
);

install_as_cpan;
auto_install;
WriteAll;

if ($Module::Install::AUTHOR) {
	system('pod2text lib/Greeter/List.pm > README');	
}
