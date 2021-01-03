#!/usr/bin/env perl

=head1

simple one, show remote IP address and hostname

=cut

use CGI;
use Net::Nslookup;

my $q = CGI->new();
my $name = nslookup(host => $q->remote_host(), type => 'PTR');

print $q->header,
      $q->start_html('IP'),
      "IP: ",
      $q->remote_host(),
      $q->br,
      "Hostname: ",
      $name,
      $q->end_html;
