#
# DESCRIPTION:
#   Plesk Expand communicate interface. Static methods for managing domain accounts.
# AUTHORS:
#   Pavel Odintsov (nrg) <pavel.odintsov@gmail.com>
#
#========================================================================

package API::PleskExpand::Domains;

use strict;
use warnings;

use API::Plesk::Methods;
use Data::Dumper;

our $VERSION = '1.02';

=head1 NAME

API::PleskExpand::Domains - extension module to support operations with Plesk domains (only create) from Plesk Expand.

=head1 SYNOPSIS

 Directly not used, calls via API::Plesk.

 use API::PleskExpand;
 use API::Plesk::Response;

 Some code

=head1 DESCRIPTION

The method used to add domain hosting account to a certain Plesk account from Plesk Expand.

=head1 METHODS

=over 3

=item create()

Params:
  dname           => 'yandex.ru',
  client_id       => 9,
  'template-id'   => 1,             # domain template id
  ftp_login       => 'nrgsdasd',
  ftp_password    => 'dasdasd',


Return:
  $VAR1 = bless( {
    'answer_data' => [ {
        'server_id'     => '1',
        'status'        => 'ok',
        'expiration'    => '-1',
        'tmpl_id'       => '1',
        'client_id'     => '16',
        'id' => '15'
    } ],
        'error_codes' => ''
  }, 'API::Plesk::Response' );


=back

=head1 EXPORT

None.

=cut

# Create element
# STATIC
sub create {

   my %params = @_;

    return '' unless $params{'dname'}        &&
                     #$params{'ip'}           &&
                     $params{'client_id'}    &&
                     $params{'ftp_login'}    &&
                     $params{'ftp_password'} &&
                     $params{'template-id'};

    my $hosting_block = create_node('hosting',
        generate_info_block(
            'vrt_hst',
            'ftp_login'    => $params{'ftp_login'},
            'ftp_password' => $params{'ftp_password'},
            # 'ip_address'   => $params{'ip'}
        )
    );
    my $template_block =  create_node('tmpl_id', $params{'template-id'});

    return create_node( 'add_use_template',
        create_node( 
            'gen_setup',
            create_node( 'name', $params{dname} ) .
            create_node( 'client_id', $params{client_id} ) .
            # ip_address  => $params{ip}, 
            create_node( 'status', 0)
        ) . $hosting_block . '<!-- create_domain -->' . $template_block        
    );


# найти способ выбирать шаблоны по имени
# хостинг тариф
my $hostN = <<DOC;
    <add_use_template>
        <gen_setup>
            <name>google.com</name>
            <client_id>10</client_id>
            <status>0</status>
        </gen_setup>
        <hosting>
            <vrt_hst>
                <ftp_login>fsdf</ftp_login>
                <ftp_password>qweqdsa</ftp_password>
            </vrt_hst>
        </hosting>
    <!-- create_domain -->
        <user>
            <enabled>false</enabled>
            <password>dasgfsfsdf</password>
            <multiply_login>false</multiply_login>
        </user>
        <tmpl_id>1</tmpl_id>
    </add_use_template>
DOC
}


# Parse XML response
# STATIC
sub create_response_parse {
    return abstract_parser('add_use_template', +shift, [ ], 'system_error' );
}


# Modify element
# STATIC
sub modify {
    # stub
}


# SET response handler
# STATIC
sub modify_response_parse {
    # stub
}


# Delete element
# STATIC( %args )
sub delete {
    # stub
}


# DEL response handler
# STATIC
sub delete_response_parse {
    # stub
}


# Get all element data
# STATIC
sub get {
    # stub
}


# GET response handler 
# STATIC
sub get_response_parse {
    # stub
}


1;
__END__
=head1 SEE ALSO

Blank.

=head1 AUTHOR

Odintsov Pavel E<lt>nrg[at]cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by NRG

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.


=cut
