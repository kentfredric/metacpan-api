use strict;
use warnings;
package MetaCPAN::API::Adapter::WWW::Mechanize;
# FILENAME: Mechanize.pm
# CREATED: 06/03/12 13:39:48 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Proxy requests through a WWW::Mech instance

use Any::Moose;

with 'MetaCPAN::API::Role::Adapter';

sub get {
    my ( $self, $url, $extra ) = @_ ;
    $extra = {} if not defined $extra;
    my $result = $self->adaptee->get( $url, %{$extra} );
    require MetaCPAN::API::Result;
    return MetaCPAN::API::Result->new(
        status => $result->code,
        reason => $result->message,
        headers => $result->headers,
        success => $result->is_success,
        content => $result->content,
    );
}

sub post {
    my ( $self, $url, $data ) = @_;
    require HTTP::Request;
    my $req = HTTP::Request->new( 'POST',  $url );
    if ( $data->{headers} ) {
        $req->header( %{ $data->{headers}} );
    }
    $req->content( $data->{content} ) if $data->{content};
    my $result = $self->adaptee->request( $req );
    require MetaCPAN::API::Result;
    return MetaCPAN::API::Result->new(
        status => $result->code,
        reason => $result->message,
        headers => $result->headers,
        success => $result->is_success,
        content => $result->content,
    );
}
no Any::Moose;

1;


