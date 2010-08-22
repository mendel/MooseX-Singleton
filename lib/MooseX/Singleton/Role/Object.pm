package MooseX::Singleton::Role::Object;
use Moose::Role;
use Carp qw( carp );

our $VERSION = '0.25';
$VERSION = eval $VERSION;

sub instance { shift->new }

sub initialize {
    my ( $class, @args ) = @_;

    my $existing = $class->meta->existing_singleton;
    confess "Singleton is already initialized" if $existing;

    return $class->new(@args);
}

override new => sub {
    my ( $class, @args ) = @_;

    my $existing = $class->meta->existing_singleton;
    confess "Singleton is already initialized" if $existing and @args;

    # Otherwise BUILD will be called repeatedly on the existing instance.
    # -- rjbs, 2008-02-03
    return $existing if $existing and !@args;

    return super();
};

sub _clear_instance {
    my ($class) = @_;
    $class->meta->clear_singleton;
}

no Moose::Role;

1;

__END__

=pod

=head1 NAME

MooseX::Singleton::Role::Object - Object class role for MooseX::Singleton

=head1 DESCRIPTION

This just adds C<instance> as a shortcut for C<new>.

=cut

