use strict;
use warnings;
use Test::More tests => 15;

BEGIN {
    package MooseX::Singleton::Test;
    use MooseX::Singleton;

    has bag => (
        is      => 'rw',
        isa     => 'HashRef[Int]',
        default => sub { {} },
    );

    sub distinct_keys {
        my $self = shift;
        scalar keys %{ $self->bag };
    }

    sub clear {
        my $self = shift;
        $self->bag({});
    }

    sub add {
        my $self = shift;
        my $key = shift;
        my $value = @_ ? shift : 1;

        $self->bag->{$key} += $value;
    }
}

my $mst = MooseX::Singleton::Test->instance;
isa_ok($mst, 'MooseX::Singleton::Test', 'Singleton->instance returns a real instance');

is($mst->distinct_keys, 0, "no keys yet");

$mst->add(foo => 10);
is($mst->distinct_keys, 1, "one key");

$mst->add(bar => 5);
is($mst->distinct_keys, 2, "two keys");

my $mst2 = MooseX::Singleton::Test->instance;
isa_ok($mst2, 'MooseX::Singleton::Test', 'Singleton->instance returns a real instance');

is($mst2->distinct_keys, 2, "two keys, from before");

$mst->add(baz => 2);

is($mst->distinct_keys, 3, "three keys");
is($mst2->distinct_keys, 3, "attributes are shared even after ->instance");

is(MooseX::Singleton::Test->distinct_keys, 3, "three keys even when Package->distinct_keys");

MooseX::Singleton::Test->add(quux => 9000);

is($mst->distinct_keys, 4, "Package->add works fine");
is($mst2->distinct_keys, 4, "Package->add works fine");
is(MooseX::Singleton::Test->distinct_keys, 4, "Package->add works fine");

MooseX::Singleton::Test->clear;

is($mst->distinct_keys, 0, "Package->clear works fine");
is($mst2->distinct_keys, 0, "Package->clear works fine");
is(MooseX::Singleton::Test->distinct_keys, 0, "Package->clear works fine");

