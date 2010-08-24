use strict;
use warnings;

use Test::More;

use Test::Requires {
    'Test::Spelling' => '0.01', # skip all if not installed
};

my @stopwords;
for (<DATA>) {
    chomp;
    push @stopwords, $_
        unless /\A (?: \# | \s* \z)/msx;    # skip comments, whitespace
}

add_stopwords(@stopwords);
set_spell_cmd('aspell list -l en');
all_pod_files_spelling_ok();

__DATA__
metaclass
Rolsky
SIGNES
