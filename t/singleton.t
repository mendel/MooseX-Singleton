use Test::More tests => 4;

use strict;
use warnings;

{
    package Foo::Singleton;
    use Moose;

    with qw/MooseX::Singleton/;

    has gravy => (is => 'rw');
}

my $ante = Foo::Singleton->instance;

ok(Foo::Singleton->new,'new');

my $foo = Foo::Singleton->instance;
my $bar = Foo::Singleton->instance;
my $baz = Foo::Singleton->new;

$foo->gravy('sauce');

is($bar->gravy,'sauce','singleton');
is($baz->gravy,'sauce','singleton');
is($ante->gravy,'sauce','singleton');

