#!/usr/bin/env perl

#use encoding "UTF-8";
use strict;
use warnings;

BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
our $VERSION = 1.0;

use Test::More tests => 5;
use Data::Dumper;

use FindBin;
use lib "$FindBin::Bin/../lib";
use Anagram;

<<<<<<< HEAD
#use constant RESULT => "{'слиток' => ['листок','слиток','столик'],'пятка' => ['пятак','пятка','тяпка']}";
use constant RESULT => "{'пятка' => ['пятка','пятак','тяпка'],'слиток' => ['слиток','листок','столик']}";

plan tests => 1;

my $result = Anagram::anagram([qw(пятка слиток пятак листок стул ПяТаК тяпка столик слиток)]);
my $dump = Data::Dumper->new([$result])->Purity(1)->Terse(1)->Indent(0)->Sortkeys(1);

is($dump->Dump, RESULT, "example");
=======
use constant EXAMPLE1   => [ qw(пятка слиток пятак ЛиСток стул ПяТаК тяпка столик слиток) ];
use constant EXAMPLE1_1 => [ qw(пятка слиток пятак ЛиСток стул ПяТаК тяпка столик слиток) ];
use constant EXAMPLE2   => [ qw(трансцендентальный фальсифицировавший слоить солить рушиться укрыться флуктуация) ];
use constant EXAMPLE2_1 => [ qw(трансцендентальный фальсифицировавший слоить солить рушиться укрыться флуктуация) ];

sub get_dump {
    my $data = shift;
    return Data::Dumper->new([ $data ])->Purity(1)->Terse(1)->Indent(0)->Sortkeys(1)->Dump;
}
>>>>>>> 2e390dce08e8ea2ee10f9518683234eb882214d4

my $example1 = Anagram::anagram(EXAMPLE1);
is(
    get_dump( $example1 ),
    "{'пятка' => ['пятак','пятка','тяпка'],'слиток' => ['листок','слиток','столик']}",
    "example 1"
);

is_deeply(
    EXAMPLE1,
    EXAMPLE1_1,
    "example 1 source data not changed"
);

is(
    get_dump( Anagram::anagram([ @{ EXAMPLE2() } ]) ),
    "{'слоить' => ['слоить','солить']}",
    "example 2"
);

is_deeply(
    EXAMPLE2,
    EXAMPLE2_1,
    "example 2 source data not changed"
);

is(
    get_dump( Anagram::anagram(EXAMPLE1) ),
    "{'пятка' => ['пятак','пятка','тяпка'],'слиток' => ['листок','слиток','столик']}",
    "example 1 again"
);

1;
