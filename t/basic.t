use Mojo::Base -strict;

use Test::More;
use File::Basename qw(basename);
use Mojo::File qw(curfile tempfile);
use Role::Tiny;

ok my $class = Mojo::File->with_roles('+Transform'), 'Create class';
ok $class->does('Mojo::File::Role::Transform'), 'Role is applied';

Role::Tiny->apply_roles_to_package('Mojo::File', 'Mojo::File::Role::Transform');

subtest 'transform' => sub {
  is curfile->transform(qr/^/, '.')->basename, '.basic.t', 'pattern/substitution';
  is curfile->transform(sub{s/^/./})->basename, '.basic.t', 'coderef';
  is curfile->transform(sub{s/^([^\.]+)\.(.*)$/$2.$1/})->basename, 't.basic', 'complex coderef';
};

subtest 'rename' => sub {
  my $tempfile = tempfile;
  ok -e $tempfile, 'tempfile exists';
  my $hidden = $tempfile->rename(qr/^/, '.');
  ok ! -e $tempfile && -e $hidden, 'tempfile renamed';
};

subtest 'misuse' => sub {
  is curfile->transform()->basename, 'basic.t', 'no transform';
  is curfile->transform(sub{})->basename, 'basic.t', 'no action cb';
  is curfile->transform(sub{}, '')->basename, 'basic.t', 'no action cb, extra empty string';
  is curfile->transform(sub{}, '.')->basename, 'basic.t', 'no action cb, extra string';
  is curfile->transform(sub{}, qr/^/)->basename, 'basic.t', 'no action cb, extra regex';
  is curfile->transform('')->basename, 'basic.t', 'no transform';
  is curfile->transform('', '')->basename, 'basic.t', 'empty string pattern, no substitution';
  is curfile->transform('^b', '')->basename, 'asic.t', 'string pattern';
  is curfile->transform('^', '.')->basename, '.basic.t', 'string pattern';
  is curfile->transform('', '.')->basename, '.basic.t', 'empty string pattern with substitution';
  is curfile->transform(qr//, '.')->basename, '.basic.t', 'empty regex pattern with substitution';
  is curfile->transform(qr/.*/)->basename, 'basic.t', 'no transform';
};

done_testing;
