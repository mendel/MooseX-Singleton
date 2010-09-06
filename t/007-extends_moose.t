use strict;
use warnings;
use Test::More;

BEGIN {
    package MooseX::Singleton::Test::Base;
    use Moose;

    package MooseX::Singleton::Test;
    use MooseX::Singleton;

    extends 'MooseX::Singleton::Test::Base';
}

can_ok( 'MooseX::Singleton::Test', 'instance');

done_testing;
