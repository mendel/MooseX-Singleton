package MooseX::Singleton;

use Moose::Role;

our $VERSION = 0.01;

override new => sub {
  my ($class) = @_;

  no strict qw/refs/;

  my $instance = super;

  ${"$class\::singleton"} = $instance;

  return $instance;
};

sub instance {
  my ($class) = @_;

  no strict qw/refs/;

  return ${"$class\::singleton"};
}

1;

