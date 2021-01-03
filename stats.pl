#!/usr/bin/env perl

=head1

show some statistics for the website

=cut

use Sys::Statistics::Linux;
use Data::Dumper;
use CGI qw(:all);

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

print $q->header,
	$q->start_html(-title => 'stats'),
	"CPU total: $cpu->{total}\n",
	$q->br,
	"Disk free: ", $freediskgb, " GB ", "($disk->{usageper}%)\n",
	$q->br,
	"Load: $load->{avg_1} $load->{avg_5} $load->{avg_15}\n",
	$q->br,
	"Mem free: ", $freememmb, " MB ", "($mem->{realfreeper}%)\n",
	$q->end_html;

