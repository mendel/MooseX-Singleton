#!/usr/bin/env perl
package MooseX::Singleton::Meta::Method::Constructor;
use Moose;

extends 'Moose::Meta::Method::Constructor';

sub _initialize_body {
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
 
    $source .= "\n" . 'my $existing = do { no strict "refs"; no warnings "once"; \${"$class\::singleton"}; };';
    $source .= "\n" . 'return ${$existing} if ${$existing};';

    $source .= "\n" . 'return $class->Moose::Object::new(@_)';
    $source .= "\n" . '    if $class ne \'' . $self->associated_metaclass->name . '\';';

    $source .= $self->_generate_params('$params', '$class');
    $source .= $self->_generate_instance('$instance', '$class');
    $source .= $self->_generate_slot_initializers;

    $source .= ";\n" . $self->_generate_triggers();
    $source .= ";\n" . $self->_generate_BUILDALL();

    $source .= ";\n" . 'return ${$existing} = $instance';
    $source .= ";\n" . '}';
    warn $source if $self->options->{debug};

    my $attrs = $self->_attributes;

    my @type_constraints = map {
        $_->can('type_constraint') ? $_->type_constraint : undef
    } @$attrs;

    my @type_constraint_bodies = map {
        defined $_ ? $_->_compiled_type_constraint : undef;
    } @type_constraints;

    my $code = $self->_compile_code(
        code => $source,
        environment => {
            '$meta'  => \$self,
            '$attrs' => \$attrs,
            '@type_constraints' => \@type_constraints,
            '@type_constraint_bodies' => \@type_constraint_bodies,
        },
    ) or $self->throw_error("Could not eval the constructor :\n\n$source\n\nbecause :\n\n$@", error => $@, data => $source );

    $self->{'body'} = $code;
}

sub _expected_constructor_class {
    return 'MooseX::Singleton::Object';
}

no Moose;

1;
