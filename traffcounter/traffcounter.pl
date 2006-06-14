#!/usr/bin/perl -w
#
# Copyright (c) 2006 Dmitri A. Alenitchev.  All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. All advertising materials mentioning features or use of this software
#    must display the following acknowledgement:
#	This product includes software developed by the University of
#	California, Berkeley and its contributors.
# 4. Neither the name of the University nor the names of its contributors
#    may be used to endorse or promote products derived from this software
#    without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
####################
# Set this options
####################
$snmp_host = '';
$snmp_community = '';
$snmp_part_MIB = '.1.3.6.1.2.1.2.2.1'; # This value true for FreeBSD
$if_num = 1; # Number of network interface
####################

use vars qw/ %opt /;

use Net::SNMP;

# Command line options processing
sub init()
{
    use Getopt::Std;
    my $opt_string = 'hvo:';
    getopts( "$opt_string", \%opt ) or usage();
    usage() if $opt{h};
}

sub usage()
{
    print "usage: $0 [-hv] [-o file]\n";
    exit;
}

init();

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

print "IN:\t" if $opt{v};
print "$traff_in\n";
print "OUT:\t" if $opt{v};
print "$traff_out\n";

$session->close;
