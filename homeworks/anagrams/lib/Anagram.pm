package Anagram;

use 5.010;
#use encoding "UTF-8";
use strict;
use warnings;


=encoding UTF8

=head1 SYNOPSIS

Поиск анаграмм

=head1 anagram($arrayref)

Функцию поиска всех множеств анаграмм по словарю.

Входные данные для функции: ссылка на массив - каждый элемент которого - слово на русском языке в кодировке utf8

Выходные данные: Ссылка на хеш множеств анаграмм.

Ключ - первое встретившееся в словаре слово из множества
Значение - ссылка на массив, каждый элемент которого слово из множества, в том порядке в котором оно встретилось в словаре в первый раз.

Множества из одного элемента не должны попасть в результат.

Все слова должны быть приведены к нижнему регистру.
В результирующем множестве каждое слово должно встречаться только один раз.
Например

anagram(['пятак', 'ЛиСток', 'пятка', 'стул', 'ПяТаК', 'слиток', 'тяпка', 'столик', 'слиток'])

должен вернуть ссылку на хеш


{
    'пятак'  => ['пятак', 'пятка', 'тяпка'],
    'листок' => ['листок', 'слиток', 'столик'],
}

=cut

sub anagram {
    my $arr_ref = shift;

    #
    # Поиск анаграмм
    #

my $href = {};

my $pattern = '';
my $found = 0;

$href->{ lc($arr_ref->[0]) } = []; #initializaion

foreach my $word ( @{$arr_ref} ) {
  $word = lc($word);
	$found = 0 ;
	$pattern = '';
	$pattern = join('',$pattern,'[',$word,']') for 1..length($word);
	foreach my $key (keys %{$href}) {
	  if ( $key =~ m($pattern) ) {
		  push @{ $href->{$key} }, $word unless grep {$word eq $_} @{ $href->{$key} };
			$found = 1;
			last;
		}
	}

  if ( $found != 1 ) {
	  $href->{$word} = [];
		push @{ $href->{$word} }, $word;
	}
}

foreach my $key (keys %{$href}) {
  if ( $#{$href->{$key}} < 1 ) {
	  delete $href->{$key};
	}
}
    return $href;
}

1;
