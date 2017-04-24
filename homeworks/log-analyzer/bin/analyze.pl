#!/usr/bin/perl

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

sub parse_file {
    my $line_rgx = qr/^ (?<ip_address>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+
		                  \[(?<time_stamp>.*)\]\s+
											\"(?<request>.*)\"\s+
											  (?<code>\d{3})\s+
												(?<bytes>\d*)\s+
												\"(?<referrer>.*)\"\s+
											\"(?<user_agent>.*)\"\s+
											\"(?<compress>.*)\"
											$/x;
		my $time_stamp_rgx = qr/ (?<day>\d{2})\/
		                   (?<month>\w{3})\/
											 (?<year>\d{4})
											:(?<hour>\d{2})
											:(?<min>\d{2})
											:(?<sec>\d{2})\s{1}
											 (?<time_zone>\+\d{4})
											$/x;
    my $file = shift;

    # you can put your code here
		my $href = {};
    my $result;
    open my $fd, "-|", "bunzip2 < $file" or die "Can't open '$file': $!";
		my $i = 1;
    while (my $log_line = <$fd>) {

        # you can put your code here
        # $log_line contains line from log file
$log_line =~ $line_rgx;
    unless (exists $href->{$1}) {$href->{$1} = [];}
		push @{$href->{$1}}, $2;

    if ($i++ > 15) {last;}

    }
    close $fd;
		p $href;
    # you can put your code here

    return $result;
}

sub report {
    my $result = shift;

    # you can put your code here

}
