use strict;
use warnings;
package MetaCPAN::API::Adapter::HTTP::Tiny;
# FILENAME: Tiny.pm
# CREATED: 06/03/12 13:30:37 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Adapt a HTTP::Tiny backend to our uses

use Any::Moose;

with "MetaCPAN::API::Role::Adapter";

sub post {
    my ( $self, $url, $payload ) = @_; 
    my $result =  $self->adaptee->request(
        'POST',
        $url,
        $payload,
    );
    require MetaCPAN::API::Result;
    return MetaCPAN::API::Result->new( %{$result}    );
}

sub get {
    my ( $self, $url ) = @_ ;
    my $result = $self->adaptee->get( $url );
    require MetaCPAN::API::Result;
    return MetaCPAN::API::Result->new( %{$result}    );
}
no Any::Moose;
__PACKAGE__->meta->make_immutable;
1;


