use strict;
use warnings;
use inc::Module::Install;

name 'MooseX-Singleton';
all_from 'lib/MooseX/Singleton.pm';

requires 'Moose' => '1.10';

build_requires 'Scalar::Util';
build_requires 'Test::More' => '0.88';
build_requires 'Test::Exception';
build_requires 'Test::Requires';

license 'Perl';

extra_tests();

WriteAll();
