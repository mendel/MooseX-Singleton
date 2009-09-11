use strict;
use warnings;

use Test::More;

BEGIN {
    eval "require MooseX::StrictConstructor; use Test::Exception; 1;";
    plan skip_all => 'This test requires MooseX::StrictConstructor and Test::Exception'
        if $@;
}

plan 'no_plan';

{
    package MySingleton;
    use Moose;
    use MooseX::Singleton;
    use MooseX::StrictConstructor;

    has 'attrib' =>
        is      => 'rw';
}

throws_ok {
    MySingleton->new( bad_name => 42 )
}
qr/Found unknown attribute/,
'singleton class also has a strict constructor';
