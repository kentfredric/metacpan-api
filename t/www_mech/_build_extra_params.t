#!perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use t::lib::Functions;

plan skip_all => "WWW::Mechanize required to run this test" unless has_www_mech;
plan tests => 5;

my $mcpan = mcpan_mech();

like(
    exception { $mcpan->_build_extra_params('one') },
    qr/^Incorrect number of params, must be key\/value/,
    'Check for key/value params',
);

my $output;
is(
    exception { $output = $mcpan->_build_extra_params },
    undef,
    'No exception or problem on empty args',
);

is(
    $output,
    '',
    'No output either',
);

# regular
is(
    $mcpan->_build_extra_params( param1 => 'one', param2 => 'two' ),
    'param2=two&param1=one',
    'Basic params',
);

# throw some symbols in there
is(
    $mcpan->_build_extra_params( param1 => 'one', param2 => 'two space' ),
    'param2=two%20space&param1=one',
    'Escaping HTML in params',
);

