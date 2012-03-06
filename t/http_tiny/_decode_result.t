#!perl

use strict;
use warnings;

use Test::More tests => 9;
use Test::Fatal;
use t::lib::Functions;

my $mcpan = mcpan();
isa_ok( $mcpan, 'MetaCPAN::API' );
use_ok('MetaCPAN::API::Result');
sub res {
    return MetaCPAN::API::Result->new( @_ );
}
# parameters
like(
    exception { $mcpan->_decode_result },
    qr/^First argument must be MetaCPAN::API::Result/,
    'Fail when first argument not given',
);

like(
    exception { $mcpan->_decode_result( res() ) },
    qr/^Second argument of a URL must be provided/,
    'Fail when second argument not given',
);

like(
    exception { $mcpan->_decode_result( res(), 'url' ) },
    qr/^Missing success in return value/,
    'Failing when got no success key',
);

like(
    exception { $mcpan->_decode_result( res( success => 0 ), 'url' ) },
    qr/^Failed to fetch 'url':/,
    'Fail without reason',
);

like(
    exception { $mcpan->_decode_result(
        res( success => 0, reason => 'because' ),
    'url' ) },
    qr/^Failed to fetch 'url': because/,
    'Fail with reason when got no success',
);

is_deeply(
    $mcpan->_decode_result(
        res( success => 1, content => '{"test":"test"}' ),
        'url',
    ),
    { test => 'test' },
    'Correct result',
);

like(
    exception {
        $mcpan->_decode_result(res( success => 1, content => 'string' ), 'url' )
    },
    qr/^Couldn't decode/,
    'JSON decode fail',
);

