use Test::More tests => 2;

use strict;
use warnings;

{
  package Foo::Singleton;

  use Moose;

  has gravy => (is => 'rw');

  with qw/MooseX::Singleton/;
}

ok (Foo::Singleton->new,'new');

my $foo = Foo::Singleton->instance;

my $bar = Foo::Singleton->instance;

$foo->gravy ('sauce');

is ($bar->gravy,'sauce','singleton');

