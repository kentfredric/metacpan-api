use strict;
use warnings;
package MetaCPAN::API::Role::Adapter;
# FILENAME: Adapter.pm
# CREATED: 06/03/12 13:24:55 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: A Generalised HTTP Adapter role for MetaCPAN::API backends

use Any::Moose 'Role';

has 'adaptee' => (
    isa => 'Object',
    is  => 'ro',
    required => 1,
);

=method post

=cut

requires 'post';

=method get

=cut

requires 'get';


1;


