#!/usr/bin/env perl
package MooseX::Singleton::Meta::Method::Constructor;
use Moose;

extends 'Moose::Meta::Method::Constructor';

sub intialize_body {
    my $self = shift;
    # TODO:
    # the %options should also include a both
    # a call 'initializer' and call 'SUPER::'
    # options, which should cover approx 90%
    # of the possible use cases (even if it
    # requires some adaption on the part of
    # the author, after all, nothing is free)
    my $source = 'sub {';
    $source .= "\n" . 'my $class = shift;';

    $source .= "\n" . 'my $existing = do { no strict "refs"; \${"$class\::singleton"}; };';
    $source .= "\n" . 'return ${$existing} if ${$existing};';

    $source .= "\n" . 'return $class->Moose::Object::new(@_)';
    $source .= "\n" . '    if $class ne \'' . $self->associated_metaclass->name . '\';';

    $source .= "\n" . 'my %params = (scalar @_ == 1) ? %{$_[0]} : @_;';

    $source .= "\n" . 'my $instance = ' . $self->meta_instance->inline_create_instance('$class');

    $source .= ";\n" . (join ";\n" => map {
        $self->_generate_slot_initializer($_)
    } 0 .. (@{$self->attributes} - 1));

    $source .= ";\n" . $self->_generate_BUILDALL();

    $source .= ";\n" . 'return ${$existing} = $instance';
    $source .= ";\n" . '}';
    warn $source if $self->options->{debug};

    my $code;
    {
        # NOTE:
        # create the nessecary lexicals
        # to be picked up in the eval
        my $attrs = $self->attributes;

        # We need to check if the attribute ->can('type_constraint')
        # since we may be trying to immutabilize a Moose meta class,
        # which in turn has attributes which are Class::MOP::Attribute
        # objects, rather than Moose::Meta::Attribute. And 
        # Class::MOP::Attribute attributes have no type constraints.
        # However we need to make sure we leave an undef value there
        # because the inlined code is using the index of the attributes
        # to determine where to find the type constraint
        
        my @type_constraints = map { 
            $_->can('type_constraint') ? $_->type_constraint : undef
        } @$attrs;
        
        my @type_constraint_bodies = map {
            defined $_ ? $_->_compiled_type_constraint : undef;
        } @type_constraints;

        $code = eval $source;
        confess "Could not eval the constructor :\n\n$source\n\nbecause :\n\n$@" if $@;
    }
    $self->{'&!body'} = $code;
}

no Moose;

1;
