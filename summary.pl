#!/usr/bin/env perl

=head1 

made for my website, show some system information 

=cut

use Unix::Uptime qw(:hires);
use Time::Piece;
use Time::Seconds;
use Time::HiRes;
use Time::Zone;
use CGI qw(:all);
use Sys::Statistics::Linux;
use Data::Dumper;
use Net::Nslookup;

my $TZ = 'Europe/Berlin';
my $uptime = Unix::Uptime->uptime_hires();
my $date = Time::HiRes::time();
my $dayup = Time::Piece->strptime(int($date - $uptime + tz_local_offset), '%s');
my $up = Time::Seconds->new(int($uptime));
my $q = CGI->new;
my $lxs = Sys::Statistics::Linux->new(
	sysinfo   => 1,
        cpustats  => 1,
        procstats => 1,
        memstats  => 1,
        pgswstats => 1,
        netstats  => 1,
        sockstats => 1,
        diskstats => 1,
        diskusage => 1,
        loadavg   => 1,
        filestats => 1,
        processes => 1,
    );

my $stat = $lxs->get();
my $cpu = $stat->cpustats->{cpu};
my $disk = $stat->diskusage->{'/dev/root'};
my $load = $stat->loadavg;
my $mem = $stat->memstats;
my $q = CGI->new;

#print Dumper($cpu);
#print Dumper($disk);
#print Dumper($load);
#print Dumper($mem);

my $freediskgb = sprintf("%.2f", $disk->{free} / 1024 / 1024);
my $freememmb = sprintf("%.2f", $mem->{realfree} / 1024);
my $name = nslookup(host => $q->remote_host(), type => 'PTR');

print $q->header,
	$q->start_html(-title => 'Sysinfo'),
	$q->h2('This RaspberryPi\'s Uptime'), 
        "uptime: ", $up->pretty,
        $q->br,
        "running since: ", $dayup,
	$q->h2('Load etc.'), 
	"CPU total: $cpu->{total}\n",
	$q->br,
	"Disk free: ", $freediskgb, " GB ", "($disk->{usageper}%)\n",
	$q->br,
	"Load: $load->{avg_1} $load->{avg_5} $load->{avg_15}\n",
	$q->br,
	"Mem free: ", $freememmb, " MB ", "($mem->{realfreeper}%)\n",
 	$q->h2('Remote IP'),
	"IP: ",
	$q->remote_host(),
	$q->br,
	"Hostname: ",
      	$name,
	$q->end_html;


