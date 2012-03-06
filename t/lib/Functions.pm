use strict;
use warnings;
use MetaCPAN::API;

my $version = $MetaCPAN::API::VERSION || 'xx';

sub mcpan {
    return MetaCPAN::API->new(
        ua_args => [ agent => "MetaCPAN::API-testing/$version" ],
    );
}

sub has_www_mech() { 
    eval { require Class::Load; 1 } or return;
    Class::Load::try_load_class("WWW::Mechanize") or return;
    return 1;
}

sub mcpan_mech {
    return unless has_www_mech;
    return MetaCPAN::API->new(
        ua => WWW::Mechanize->new( agent => "MetaCPAN::API-testing/$version"  )
    );
}

1;
