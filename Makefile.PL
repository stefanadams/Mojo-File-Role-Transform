use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojo::File::Role::Transform',
  VERSION_FROM => 'lib/Mojo/File/Role/Transform.pm',
  AUTHOR       => 'Stefan Adams <stefan@adams.fm>',
  PREREQ_PM    => {'Mojolicious' => '8.73'},
  test         => {TESTS => 't/*.t'}
);
