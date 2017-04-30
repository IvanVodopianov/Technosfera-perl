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

    my $href_time   = {};
    my $href_status = {};
    my $href_count  = {};

    my $result = [];

    open my $fd, "-|", "bunzip2 < $file" or die "Can't open '$file': $!";
    my $i = 1;

    while ( my $log_line = <$fd> ) {

        # you can put your code here
        # $log_line contains line from log file

        $log_line =~ $line_regex;

        my $ip_address     = $1;
        my $time_stamp     = $2;
        my $code           = $4;
        my $bytes          = $5;
        my $compress_ratio = $8;

        unless ( exists $href_time->{$ip_address} ) {
            $href_time->{$ip_address} = {};
        }

        unless ( exists $href_status->{$ip_address} ) {
            $href_status->{$ip_address} = {};
        }

        unless ( exists $href_count->{$ip_address} ) {
            $href_count->{$ip_address} = 1;
        }

        $href_count->{$ip_address} += 1;

        $time_stamp =~ $time_stamp_regex;
        my $h = $4;
        my $m = $5;
        my $s = $6;

        unless ( exists $href_time->{$ip_address}->{ 60 * $h + $m } ) {
            $href_time->{$ip_address}->{ 60 * $h + $m } = 1;
        }

        $href_time->{$ip_address}->{ 60 * $h + $m } += 1;

        unless ( exists $href_status->{$ip_address}->{$code} ) {
            $href_status->{$ip_address}->{$code} = [];
        }

        my $tmp = [];
        push @{$tmp}, $bytes, $compress_ratio;
        push @{ $href_status->{$ip_address}->{$code} }, $tmp;

        #    if ($i++ > 1500) {last;} #for test puposes only

    }
    close $fd;

    push @{$result}, $href_time, $href_status, $href_count;

    return $result;
}

sub report {
    my $result = shift;

    my $href_time   = @{$result}[0];
    my $href_status = @{$result}[1];
    my $href_count  = @{$result}[2];

    my $table = {};
    $table->{"total"} = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ];

    my $j = 0;

    foreach my $host ( sort { $href_count->{$b} <=> $href_count->{$a} }
        keys %$href_count )
    {
        if ( $j++ > 9 ) { last; }

        unless ( exists $table->{$host} ) {
            $table->{$host} = [ 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 ]
						  ;    #13 column for each host
            $table->{$host}->[0] = $href_count->{$host};
            $table->{$host}->[1] = make_avg( $host, $href_time );
            $table->{$host}->[2] =
              @{ make_data( "200", $href_status->{$host} ) }[1] / 1024;
            $table->{$host}->[3] =
              @{ make_data( "200", $href_status->{$host} ) }[0] / 1024;
            $table->{$host}->[4] =
              @{ make_data( "301", $href_status->{$host} ) }[0] / 1024;
            $table->{$host}->[5] =
              @{ make_data( "302", $href_status->{$host} ) }[0] / 1024;
            $table->{$host}->[6] =
              @{ make_data( "400", $href_status->{$host} ) }[0] / 1024;
            $table->{$host}->[7] =
              @{ make_data( "403", $href_status->{$host} ) }[0] / 1024;
            $table->{$host}->[8] =
              @{ make_data( "404", $href_status->{$host} ) }[0] / 1024;
            $table->{$host}->[9] =
              @{ make_data( "408", $href_status->{$host} ) }[0] / 1024;
            $table->{$host}->[10] =
              @{ make_data( "419", $href_status->{$host} ) }[0] / 1024;
            $table->{$host}->[11] =
              @{ make_data( "499", $href_status->{$host} ) }[0] / 1024;
            $table->{$host}->[12] =
              @{ make_data( "500", $href_status->{$host} ) }[0] / 1024;

            $table->{"total"}->[0]  += $table->{$host}->[0];
            $table->{"total"}->[1]  += $table->{$host}->[1];
            $table->{"total"}->[2]  += $table->{$host}->[2];
            $table->{"total"}->[3]  += $table->{$host}->[3];
            $table->{"total"}->[4]  += $table->{$host}->[4];
            $table->{"total"}->[5]  += $table->{$host}->[5];
            $table->{"total"}->[6]  += $table->{$host}->[6];
            $table->{"total"}->[7]  += $table->{$host}->[7];
            $table->{"total"}->[8]  += $table->{$host}->[8];
            $table->{"total"}->[9]  += $table->{$host}->[9];
            $table->{"total"}->[10] += $table->{$host}->[10];
            $table->{"total"}->[11] += $table->{$host}->[11];
            $table->{"total"}->[12] += $table->{$host}->[12];
        }
    }
    printf
"%-16s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \t %s \n",
      "IP address", "count", "avg", "data", "200", "301", "302", "400", "403",
      "404", "408", "414", "499", "500";

    foreach
      my $host ( sort { $table->{$b}->[0] <=> $table->{$a}->[0] } keys %$table )
    {
        printf
"%-16s \t %d \t %.2f \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \t %d \n",
          $host,
          $table->{$host}->[0],  $table->{$host}->[1],
          $table->{$host}->[2],  $table->{$host}->[3],
          $table->{$host}->[4],  $table->{$host}->[5],
          $table->{$host}->[6],  $table->{$host}->[7],
          $table->{$host}->[8],  $table->{$host}->[9],
          $table->{$host}->[10], $table->{$host}->[11],
          $table->{$host}->[12];
    }

}

sub make_avg() {
    my $key   = shift;
    my $href  = shift;
    my $sum   = 0;
    my $index = 1;

    foreach my $v ( values %{ $href->{$key} } ) {
        $sum += $v;
        $index++;
    }

    return ( $sum / $index );
}

sub make_data() {
    my $status          = shift;
    my $href            = shift;
    my $compressed_data = 0;
    my $raw_data        = 0;
    my $ratio           = 1;
    my $data            = 0;
    foreach my $v ( @{ $href->{$status} } ) {

        if ( defined $v->[0] ) {
            $data = $v->[0];
        }
        else {
            $data = 0;
        }
        $compressed_data += $data;

        if ( !defined( $v->[1] ) ) {
            $ratio = 1;
        }
        elsif ( $v->[1] eq "-" ) {
            $ratio = 1;
        }
        else {
            $ratio = $v->[1];
        }
        $raw_data += $data * $ratio;
    }
    my $tmp = [];

    push @{$tmp}, $compressed_data, $raw_data;

    return $tmp;
}
