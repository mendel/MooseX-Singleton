package MooseX::Singleton::Role::Meta::Class;
use Moose::Role;
use MooseX::Singleton::Role::Meta::Instance;
use MooseX::Singleton::Role::Meta::Method::Constructor;

our $VERSION = '0.25';
$VERSION = eval $VERSION;

sub existing_singleton {
    my ($class) = @_;
    my $pkg = $class->name;

    no strict 'refs';

    # create exactly one instance
    if ( defined ${"$pkg\::singleton"} ) {
        return ${"$pkg\::singleton"};
    }

    return;
}

sub clear_singleton {
    my ($class) = @_;
    my $pkg = $class->name;
    no strict 'refs';
    undef ${"$pkg\::singleton"};
}

override _construct_instance => sub {
    my ($class) = @_;

    # create exactly one instance
    my $existing = $class->existing_singleton;
    return $existing if $existing;

    my $pkg = $class->name;
    no strict 'refs';
    return ${"$pkg\::singleton"} = super;
};

no Moose::Role;

1;

__END__

=pod

=head1 NAME

MooseX::Singleton::Role::Meta::Class - Metaclass role for MooseX::Singleton

=head1 DESCRIPTION

This metaclass role makes sure that there is only ever one instance of an
object for a singleton class. The first call to C<construct_instance> is run
normally (and then cached). Subsequent calls will return the cached version.

=cut

