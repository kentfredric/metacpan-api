use strict;
use warnings;
package MetaCPAN::API::Role::Adapter;

# CREATED: 06/03/12 13:24:55 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: A Generalised HTTP Adapter role for MetaCPAN::API backends

use Any::Moose 'Role';

has 'adaptee' => (
    isa => 'Object',
    is  => 'ro',
    required => 1,
);

=head1 REQUIRED METHODS

=head2 B<C<post>>

    my $result = $class->post( $post_url , {    # Full URL To Dispatch request to.
        headers     =>  { },                    # Hash Array Of Key->Value headers.
        content     =>  " ",                    # String of POST content.
        request_uri => $url,                    # URL Formatted for diagnositic display
    })->isa('MetaCPAN::API::Result');           # Returns a MetaCPAN::API::Result


=cut

requires 'post';

=head2 B<C<get>>

    my $result = $class->get( $get_url ,        # Full URL To Fetch
    )->isa('MetaCPAN::API::Result')             # Returns a MetaCPAN::API::Result

=cut

requires 'get';


1;


