#!perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::TinyMocker;
use t::lib::Functions;

plan skip_all => "WWW::Mechanize required to run this test" unless has_www_mech;
plan tests => 7;

my $mcpan = mcpan_mech();
isa_ok( $mcpan, 'MetaCPAN::API' );

my $url  = 'release/distribution/hello';
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
    => method 'get'
    => should {
        my $self = shift;
        isa_ok( $self, 'WWW::Mechanize' );
        is( $_[0], $mcpan->base_url . "/$url", 'Correct URL' );

        $flag++ == 0 and return resp(
            is_success => 1,
            content => '{"test":"test"}',
        );

        $flag++ == 2 and return resp(
            is_success => 1,
        );

        return resp( 
            is_success => 1,
            content => 'string',
        );
    };

my $result = $mcpan->fetch($url);
is_deeply( $result, { test => 'test' }, 'Correct result' );

mock 'WWW::Mechanize'
    => method 'get'
    => should {
        my $self = shift;
        isa_ok( $self, 'WWW::Mechanize' );
        is( $_[0], $mcpan->base_url . '/?test=it', 'Correct URL' );

        return resp(
            is_success => 1,
            content => '{"content":"ok"}',
        );
    };

is_deeply(
    $mcpan->fetch( '', test => 'it' ),
    { content => 'ok' },
    'Sending params work right',
);

