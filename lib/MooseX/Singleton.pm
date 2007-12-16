package MooseX::Singleton;
use Moose::Role;

our $VERSION = 0.02;

override new => sub {
    my ($class) = @_;

    no strict 'refs';

    # create our instance if we don't already have one
    if (!defined ${"$class\::singleton"}) {
        ${"$class\::singleton"} = super;
    }

    return ${"$class\::singleton"};
};

# instance really is the same as new. any ideas for a better implementation?
sub instance {
    shift->new(@_);
}

1;

