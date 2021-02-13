package Mojo::File::Role::Transform;
use Mojo::Base -strict, -role;

our $VERSION = '0.01';

requires 'basename';

sub transform {
  my $self = shift;
  if (ref $_[0] eq 'CODE') {
    local $_ = $self->basename;
    $_[0]->($self->basename);
    $self->sibling($_);
  }
  elsif ($#_ == 1) {
    $self->sibling($self->basename =~ s/$_[0]/$_[1]/r);
  }
  else {
    $self;
  }
}

sub rename {
  my $self = shift;
  $self->move_to($self->transform(@_));
}

1;

=encoding utf8

=head1 NAME

Mojo::File::Role::Transform - Mojolicious Plugin

=head1 SYNOPSIS

  use Mojo::File;
  Role::Tiny->apply_roles_to_package(
    'Mojo::File', 'Mojo::File::Role::Transform');

  # Return a Mojo::File object
  my $hidden = curfile->transform(qr/^/, '.');

  # Rename the file using L<Mojo::File/"move_to"> and return the object
  my $hidden = curfile->rename(qr/^/, '.');

=head1 DESCRIPTION

L<Mojo::File::Role::Transform> is a role for L<Mojo::File> to transform the
filename into a different name.

=head1 METHODS

=head2 rename

  # Rename a file using a pattern and substitution.
  my $file = $file->rename(qr/pattern/, 'substitution');

  # Rename a file using a callback.
  my $file = $file->rename(sub{s/pattern/substitution/});

Rename a file using L<Mojo::File/"move_to">. The filename will be the first
argument passed to the callback, and is also available as C<$_>.

  # .vimrc
  path('vimrc')->rename(sub{s/^/./});

=head2 transform

  # Rename a file using a pattern and substitution.
  my $file = $file->rename(qr/pattern/, 'substitution');

  # Rename a file using a callback.
  my $file = $file->rename(sub{s/pattern/substitution/});

Return a new L<Mojo::File> object relative to the directory part of the path,
with the last level of the path being transformed according to the provided
pattern and substiution.

  # .vimrc
  path('vimrc')->transform(sub{s/^/./});

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<https://mojolicious.org>.

=cut
