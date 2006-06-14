#!/usr/bin/perl -w

$snmp_host = '192.168.21.1';
$snmp_community = 'diwo';
$snmp_part_MIB = '.1.3.6.1.2.1.2.2.1';
$if_num = 1;

use Net::SNMP;

#my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime time;
#$year = $year + 1900;
#$mon = $mon + 1;
#$unix_time = time;

($session,$error)=Net::SNMP->session(Hostname => $snmp_host,
	Community => $snmp_community);
die "session error: $error" unless($session);

$snmp_MIB_in = $snmp_part_MIB . ".10." . $if_num;
$snmp_MIB_out = $snmp_part_MIB . ".16." . $if_num;

$traff_in = $session->get_request("$snmp_MIB_in");
$traff_out = $session->get_request("$snmp_MIB_out");
die "request error: " . $session->error unless(defined $traff_in);
$traff_in = $traff_in->{"$snmp_MIB_in"};
$traff_out = $traff_out->{"$snmp_MIB_out"};

print "$traff_in\n";
print "$traff_out\n";

$session->close;
