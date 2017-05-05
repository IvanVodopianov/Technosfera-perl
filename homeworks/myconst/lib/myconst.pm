package myconst;

use strict;
use warnings;
use 5.010;
#use Scalar::Util 'looks_like_number';
use DDP;
#use Data::Dumper;

#use Exporter 'import';
#our $params;
#say @_;
#say Dumper \%params;
#p \%params;
#our @EXPORT = qw(m2 m3 pi zero);
#our %EXPORT_TAGS = (
#all => [qw(m1 m2 m3)],
#math => [sub pii {3.222}, sub eee {222.222}],
#phys => [qw(m3)],
#);
#our $zero = 0;
#our $pi = 3.13;
sub m1 { shift() ** 1 }
sub m2 { shift() ** 2 }
sub m3 { shift() ** 3 }
#sub zero { shift() }
#sub pi { 3.1111 }
sub import {
our %EXPORT_TAGS = (pii => [&(sub {1.111})],);
p %EXPORT_TAGS;
p %EXPORT_TAGS{pii};
#p @_;
my($package_name, %params) = @_;
p %params;
while (my ($k,$v) = each %params) {
if (ref \$v eq 'SCALAR') {say 'scalar: ', $k, $v;}
if (ref $v eq 'HASH') {
  while (my ($k1,$v1) = each %{$v}) {
	say 'hash: ', $k1, $v1;
	}
#say 'all: ', $v;
}
}
}
#my ($package, %params) = @_;
#$params = $msg;
#p %params;
#say $package;
#say $msg;
#say @_;


=encoding utf8

=head1 NAME

myconst - pragma to create exportable and groupped constants

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS
package aaa;

use myconst math => {
        PI => 3.14,
        E => 2.7,
    },
    ZERO => 0,
    EMPTY_STRING => '';

package bbb;

use aaa qw/:math PI ZERO/;

print ZERO;             # 0
print PI;               # 3.14
=cut



1;
