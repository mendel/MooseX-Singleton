#!/usr/bin/perl

use strict;
use warnings;

use Test::More;

use Test::Requires {
    'Test::Pod::Coverage' => '1.04', # skip all if not installed
};

# This is a stripped down version of all_pod_coverage_ok which lets us
# vary the trustme parameter per module.
my @modules = all_modules();
plan tests => scalar @modules;

my %trustme = (
    'MooseX::Singleton' => ['init_meta'],
    'MooseX::Singleton::Role::Meta::Class' =>
        [qw( clear_singleton existing_singleton )],
    'MooseX::Singleton::Role::Meta::Instance' => ['get_singleton_instance'],
    'MooseX::Singleton::Role::Object'         => [qw( initialize instance )],
);

for my $module ( sort @modules ) {
    my $trustme = [];
    if ( $trustme{$module} ) {
        my $methods = join '|', @{ $trustme{$module} };
        $trustme = [qr/^(?:$methods)$/];
    }

    pod_coverage_ok(
        $module, { trustme => $trustme },
        "Pod coverage for $module"
    );
}
