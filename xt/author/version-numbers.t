use strict;
use warnings;

use Test::More;

use Test::Requires {
    'File::Find::Rule' => '0.01', # skip all if not installed
    'Module::Info' => '0.01',
};

my %versions;
for my $pm_file ( File::Find::Rule->file->name( qr/\.pm$/ )->in('lib' ) ) {
    my $mod = Module::Info->new_from_file($pm_file);

    ( my $stripped_file = $pm_file ) =~ s{^lib/}{};

    $versions{$stripped_file} = $mod->version;
}

my $moose_ver = $versions{'MooseX/Singleton.pm'};

for my $module ( grep { $_ ne 'MooseX/Singleton.pm' } sort keys %versions ) {
    is( $versions{$module}, $moose_ver,
        "version for $module is the same as in MooseX/Singleton.pm" );
}

done_testing;
