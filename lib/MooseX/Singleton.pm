package MooseX::Singleton;

use Moose 0.82 ();
use Moose::Exporter;
use MooseX::Singleton::Role::Object;
use MooseX::Singleton::Role::Meta::Class;
use MooseX::Singleton::Role::Meta::Instance;

our $VERSION = '0.21';
$VERSION = eval $VERSION;

Moose::Exporter->setup_import_methods( also => 'Moose' );

sub init_meta {
    shift;
    my %p = @_;

    Moose->init_meta(%p);

    my $caller = $p{for_class};

    Moose::Util::MetaRole::apply_metaclass_roles(
        for_class       => $caller,
        metaclass_roles => ['MooseX::Singleton::Role::Meta::Class'],
        instance_metaclass_roles =>
            ['MooseX::Singleton::Role::Meta::Instance'],
        constructor_class_roles =>
            ['MooseX::Singleton::Role::Meta::Method::Constructor'],
    );

    Moose::Util::MetaRole::apply_base_class_roles(
        for_class => $caller,
        roles =>
            ['MooseX::Singleton::Role::Object'],
    );

    return $caller->meta();
}


1;

__END__

=pod

=head1 NAME

MooseX::Singleton - turn your Moose class into a singleton

=head1 SYNOPSIS

    package MyApp;
    use MooseX::Singleton;

    has env => (
        is      => 'rw',
        isa     => 'HashRef[Str]',
        default => sub { \%ENV },
    );

    package main;

    delete MyApp->env->{PATH};
    my $instance = MyApp->instance;
    my $same = MyApp->instance;

=head1 DESCRIPTION

A singleton is a class that has only one instance in an application.
C<MooseX::Singleton> lets you easily upgrade (or downgrade, as it were) your
L<Moose> class to a singleton.

All you should need to do to transform your class is to change C<use Moose> to
C<use MooseX::Singleton>. This module uses a new class metaclass and instance
metaclass, so if you're doing metamagic you may not be able to use this.

C<MooseX::Singleton> gives your class an C<instance> method that can be used to
get a handle on the singleton. It's actually just an alias for C<new>.

Alternatively, C<< YourPackage->method >> should just work. This includes
accessors.

If you need to reset your class's singleton object for some reason (e.g.
tests), you can call C<< YourPackage->_clear_instance >>.

=head1 TODO

=over

=item Always more tests and doc

=item Fix speed boost

C<instance> invokes C<new> every time C<< Package->method >> is called, which
incurs a nontrivial runtime cost. I've implemented a short-circuit for this
case, which does eliminate nearly all of the runtime cost. However, it's ugly
and should be fixed in a more elegant way.

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no 
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHORS

Shawn M Moore E<lt>sartak@gmail.comE<gt>

Dave Rolsky E<lt>autarch@urth.orgE<gt>

=head1 SOME CODE STOLEN FROM

Anders Nor Berle E<lt>debolaz@gmail.comE<gt>

=head1 AND PATCHES FROM

Ricardo SIGNES E<lt>rjbs@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2007, 2008 Infinity Interactive

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=cut

