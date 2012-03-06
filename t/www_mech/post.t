#!perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::TinyMocker;
use t::lib::Functions;

plan skip_all => "WWW::Mechanize required to run this test" unless has_www_mech;
plan tests => 15;

my $mcpan = mcpan_mech();
isa_ok( $mcpan, 'MetaCPAN::API' );

like(
    exception { $mcpan->post() },
    qr/^First argument of URL must be provided/,
    'Missing arguments',
);

like(
    exception { $mcpan->post( 'release' ) },
    qr/^Second argument of query hashref must be provided/,
    'Missing second argument',
);

like(
    exception { $mcpan->post( 'release', 'bad query' ) },
    qr/^Second argument of query hashref must be provided/,
    'Incorrect second argument',
);

my $url  = 'release/dist';
my $flag = 0;
{
    package # No PAUSE
        FakeResponse;

    use Any::Moose;
    has ['code','message','headers','content'] => ( is => 'rw' );
    has ['is_success'] => ( is => 'rw' , required => 1);


}
sub resp {
    return FakeResponse->new( @_ );
}

mock 'WWW::Mechanize'
    => method 'request'
    => should {
        my $self = shift;
        my @args = @_;

        isa_ok( $self, 'WWW::Mechanize' );
        isa_ok( $args[0], 'HTTP::Request' );
        is( $args[0]->method, 'POST', 'Correct request type' );
        is(
            $args[0]->uri,
            $mcpan->base_url . "/$url",
            'Correct URL',
        );
        my ($rec) = {
            headers => { map { $_, $args[0]->header($_) } $args[0]->header_field_names },
            content => $args[0]->content,
        };
        if ( $flag++ == 0 ) {
            is_deeply(
                $rec,
                {    headers => { 'Content-Type' => 'application/json' },
                    content => '{}',
                },
                'Correct request hash without content',
            ) or diag explain( $rec );
        }

        if ( $flag++ == 2 ) {
            is_deeply(
                $rec,
                {
                    headers => { 'Content-Type' => 'application/json' },
                    content => '{"useful":"query"}',
                },
                'Correct request hash with content',
            ) or diag explain( $rec );
        }

        return resp( is_success => 1, content => '{}' );
    };

is(
    exception { $mcpan->post( $url, {} ) },
    undef,
    'Correct arguments are successful',
);

is(
    exception { $mcpan->post( $url, { useful => 'query' } ) },
    undef,
    'Correct and useful arguments are successful',
);

