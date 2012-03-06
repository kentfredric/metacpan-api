use strict;
use warnings;
package MetaCPAN::API::Result;
# FILENAME: Result.pm
# CREATED: 06/03/12 13:55:01 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Unified result set type

use Any::Moose;
use JSON;
use Try::Tiny;
use Carp qw( croak );

has 'status' => ( is => 'rw');
has 'reason' => ( is => 'rw');
has 'headers' => ( is => 'rw' );
has 'success' => ( is => 'rw' );
has 'content' => ( is => 'rw' );

sub decoded_json_content {
    my $self = shift;
    my $result;
    my $content_abbr = substr $self->content, 0 , 30;
    $content_abbr .= '...' if ( length $self->content > 30 );

     try { $result = decode_json $self->content }
     catch { croak "Couldn't decode '$content_abbr' : $_ " };

     return $result;
}


no Any::Moose;
1;


