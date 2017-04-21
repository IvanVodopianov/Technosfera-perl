package Anagram;

use 5.010;

#use encoding "UTF-8";
use strict;
use warnings;
use Encode;

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

sub gen_regex {
    my $word = shift;
		$word = quotemeta $word;    #to escape 'minus' sign e.g. 'обер-полицейский'
    my $regex = "";
    $regex = join( '', '^' );
    my $i          = 0;
    my $pre_string = "";
    foreach ( split //, $word ) {

        if ( $i == 0 ) { $pre_string = join( '', $pre_string, '(' ); }
        if ( $i == 1 ) { $pre_string = join( '', $pre_string, '(?!\1' ); }
        if ( $i > 1 )  { $pre_string = join( '', $pre_string, "|\\$i" ); }

        if ( $i > 0 ) {
            $regex = join( '', $regex, $pre_string, ")", "[$word]{1})" );
        }
        else {
            $regex = join( '', $regex, $pre_string, "[$word]{1})" );
        }
        $i++;
    }
    $regex = join( '', $regex, '$' );
    return $regex;
}

sub anagram {
    my $arr_ref = shift;

    #
    # Поиск анаграмм
    #

    my $href = {};

    my $pattern = "";
    my $found   = 0;

    foreach my $word ( @{$arr_ref} ) {
        my $decoded_word = lc( decode( 'utf8', $word ) );
        $found   = 0;
        $pattern = "";

 # $pattern = join('',$pattern,'[',$word,']') for 1..length($word); #old version

        $pattern = gen_regex($decoded_word);

        foreach my $key ( keys %{$href} ) {
            if ( $key =~ m($pattern) ) {
                push @{ $href->{$key} }, encode( 'utf8', $decoded_word )
                  unless grep { encode( 'utf8', $decoded_word ) eq $_ }
                  @{ $href->{$key} };
                $found = 1;
                last;
            }
        }

        if ( $found != 1 ) {
            $href->{$decoded_word} = [];
            push @{ $href->{$decoded_word} }, encode( 'utf8', $decoded_word );

        }
    }
    my $href1 = {};

    foreach my $key ( keys %{$href} ) {

        if ( $#{ $href->{$key} } < 1 ) {

            delete $href->{$key};

        }
        else {

            my $key1;
            $key1 = encode( 'utf8', $key );
            $href1->{$key1} = $href->{$key};
        }
    }
    return $href1;
}

1;
