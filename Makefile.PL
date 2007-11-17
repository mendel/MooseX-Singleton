use strict;
use warnings;
use inc::Module::Install;

name 'MooseX-Singleton';
all_from 'lib/MooseX/Singleton.pm';

requires 'Moose';

build_requires 'Test::More';
build_requires 'Test::Exception';

license 'Perl';

WriteAll();
