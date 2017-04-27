#!/usr/bin/perl

use 5.010;
use strict;
use warnings;
use DDP;
our $VERSION = 1.0;


my $filepath = $ARGV[0];
die "USAGE:\n$0 <log-file.bz2>\n"  unless $filepath;
die "File '$filepath' not found\n" unless -f $filepath;

my $parsed_data = parse_file($filepath);
report($parsed_data);
exit;

#sub moving_average {
#    my $list = shift;
#    my $period = shift;
#    my $tmp = [];
#    foreach my $el @$list {

#    }
#}

sub parse_file {
    my $line_regex = qr/^
      (?<ip_address>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+
    \[(?<time_stamp>.*)\]\s+
    \"(?<request>.*)\"\s+
      (?<code>\d{3})\s+
      (?<bytes>\d*)\s+
    \"(?<referrer>.*)\"\s+
    \"(?<user_agent>.*)\"\s+
    \"(?<compress>.*)\"
    $/x;
    my $time_stamp_regex = qr/
     (?<day>\d{2})\/
     (?<month>\w{3})\/
     (?<year>\d{4})
    :(?<hour>\d{2})
    :(?<min>\d{2})
    :(?<sec>\d{2})\s{1}
     (?<time_zone>\+\d{4})
    $/x;

    my $file = shift;

    # you can put your code here

    my $href_time = {};
    my $href_status = {};
		my $href_count = {};

    my $result = [];

    open my $fd, "-|", "bunzip2 < $file" or die "Can't open '$file': $!";
    my $i = 1;

    while (my $log_line = <$fd>) {

        # you can put your code here
        # $log_line contains line from log file

    $log_line =~ $line_regex;

    my $ip_address = $1;
    my $time_stamp = $2;
    my $code = $4;
    my $bytes = $5;
    my $compress_ratio = $8;

    unless (exists $href_time->{$ip_address}) {$href_time->{$ip_address} = {};}

    unless (exists $href_status->{$ip_address}) {$href_status->{$ip_address} = {};}

    unless (exists $href_count->{$ip_address}) {$href_count->{$ip_address} = 1;}

    $href_count->{$ip_address} += 1;

    $time_stamp =~ $time_stamp_regex;
    my $h = $4;
    my $m = $5;
    my $s = $6;

    unless (exists $href_time->{$ip_address}->{60*$h+$m}) {$href_time->{$ip_address}->{60*$h+$m} = 1;}

    $href_time->{$ip_address}->{60*$h+$m} += 1;

    unless (exists $href_status->{$ip_address}->{$code}) {$href_status->{$ip_address}->{$code} = [];}

    my $tmp = [];
    push @{$tmp}, $bytes, $compress_ratio;
    push @{$href_status->{$ip_address}->{$code}}, $tmp;
#        push @{$href->{$ip_address}}, $h*3600+$m*60+$s;

    if ($i++ > 150) {last;}

    }
    close $fd;
#		            p $href_time;
#                p $href_status;
                p $href_count;
    # you can put your code here
    push @{$result}, $href_time, $href_status;

    return $result;
}

sub report {
    my $result = shift;
    say "from report:";
    say ref @{$result}[0];
    say ref @{$result}[1];
#    my $href_time = @{$result}[0];
#    my $href_time_count_avg = {};
#    p $href_time;
#    foreach (keys %$href_time) {
#    unless (exists $href_time_count_avg->{$_}) {exists $href_time_count_avg->{$_} = {};}
#    foreach (values)
#    }

    # you can put your code here

}
