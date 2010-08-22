package MooseX::Singleton::Role::Meta::Instance;
use Moose::Role;
use Scalar::Util 'weaken';

our $VERSION = '0.25';
$VERSION = eval $VERSION;

sub get_singleton_instance {
    my ( $self, $instance ) = @_;

    return $instance if blessed $instance;

    # optimization: it's really slow to go through new_object for every access
    # so return the singleton if we see it already exists, which it will every
    # single except the first.
    no strict 'refs';
    return ${"$instance\::singleton"} if defined ${"$instance\::singleton"};

    # We need to go through ->new in order to make sure BUILD and
    # BUILDARGS get called.
    return $instance->meta->name->new;
}

override clone_instance => sub {
    my ( $self, $instance ) = @_;
    $self->get_singleton_instance($instance);
};

override get_slot_value => sub {
    my ( $self, $instance, $slot_name ) = @_;
    $self->is_slot_initialized( $instance, $slot_name )
        ? $self->get_singleton_instance($instance)->{$slot_name}
        : undef;
};

override set_slot_value => sub {
    my ( $self, $instance, $slot_name, $value ) = @_;
    $self->get_singleton_instance($instance)->{$slot_name} = $value;
};

override deinitialize_slot => sub {
    my ( $self, $instance, $slot_name ) = @_;
    delete $self->get_singleton_instance($instance)->{$slot_name};
};

override is_slot_initialized => sub {
    my ( $self, $instance, $slot_name, $value ) = @_;
    exists $self->get_singleton_instance($instance)->{$slot_name} ? 1 : 0;
};

override weaken_slot_value => sub {
    my ( $self, $instance, $slot_name ) = @_;
    weaken $self->get_singleton_instance($instance)->{$slot_name};
};

override inline_slot_access => sub {
    my ( $self, $instance, $slot_name ) = @_;
    sprintf "%s->meta->instance_metaclass->get_singleton_instance(%s)->{%s}",
        $instance, $instance, $slot_name;
};

no Moose::Role;

1;

__END__

=pod

=head1 NAME

MooseX::Singleton::Role::Meta::Instance - Instance metaclass role for MooseX::Singleton

=head1 DESCRIPTION

This role overrides all object access so that it gets the appropriate
singleton instance for the class.

=cut

