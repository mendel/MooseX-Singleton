use strict;
use warnings;

use Test::More;

use Test::Requires {
   'MooseX::StrictConstructor' => 0.01, # skip all if not installed
   'Test::Exception' => 0.01,
};

{
    package MySingleton;
    use Moose;
    use MooseX::Singleton;
    use MooseX::StrictConstructor;

    has 'attrib' => ( is => 'rw' );
}

throws_ok {
    MySingleton->new( bad_name => 42 );
}
qr/Found unknown attribute/, 'singleton class also has a strict constructor';

done_testing;
