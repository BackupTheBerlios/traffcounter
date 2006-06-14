#!/usr/bin/perl -w
#
####################
# Set this options
####################
$snmp_host = '';
$snmp_community = '';
$snmp_part_MIB = '.1.3.6.1.2.1.2.2.1'; # This value true for FreeBSD
$if_num = 1; # Number of network interface
####################

use Net::SNMP;

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
