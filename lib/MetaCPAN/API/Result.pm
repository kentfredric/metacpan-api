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

has 'status'  => ( is => 'rw' );
has 'reason'  => ( is => 'rw', lazy => 1, default => sub { '' } );
has 'headers' => ( is => 'rw' );
has 'success' => ( isa => 'Bool', is => 'rw', required => 1 );
has 'content' => ( isa => 'Str',  is => 'rw', required => 1 );
# Mostly for debugging.
has 'request_url' => (  isa => 'Str', is => 'rw', required => 1 );

sub decoded_json_content {
    my $self = shift;
    my $result;
    my $content_abbr = substr $self->content, 0, 30;
    $content_abbr .= '...' if ( length $self->content > 30 );

    try { $result = decode_json $self->content }
    catch { croak "Couldn't decode '$content_abbr' : $_ " };

    return $result;
}

sub check {
    my ($self, $original ) = @_;

    my $url = $self->request_url;

    my $reason = $self->reason;

    $reason .= ( defined $original ? " (request: $original)" : '' );

    $self->success or croak "Failed to fetch '$url': $reason";
}

no Any::Moose;
1;

