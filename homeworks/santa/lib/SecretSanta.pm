package SecretSanta;

use 5.010;
use strict;
use warnings;
use DDP;
use Data::Dumper;

sub calculate {
	my @members = @_;
	my @res;


# Никто не дарит подарок сам себе.
# Никто не дарит подарок своему супругу.
# Два участника не дарят подарок друг другу.


# Результатом функции должен быть список ссылок на массив из пар дарящий  →
# даритель

# Рассматриваются все 16 вариантов-комбинаций:

# Пар больше 2 (дарим по кругу)
#  2 пары (дарим "наискосок")
#	1 пара (дарим "первому" холостяку, если он есть
#	нет пар

#	Холостых больше 2 (дарим по кругу)
#	Холостых двое (дарим первому из первой пары, если она есть)
#	Холостой один (дарим перому из первой пары, если она есть
#	Нет холостых 

	my @pairs  = map { $_ } grep {ref $_ eq 'ARRAY'} @members;
	my @alones = map { $_ } grep {ref $_ ne 'ARRAY'} @members;

	my $i = 0; my $k = 1;

	if ( (1 + $#pairs) > 2 and (1 + $#alones) > 2 ) {

		foreach (@pairs) {
		push @res,[ $pairs[$i][0], $pairs[$k][0] ];
		push @res,[ $pairs[$i][1], $pairs[$k][1] ];
		$i++; $k++;
		if ( $k > $#pairs ) {$k = 0;}
		}
	
		$i = 0;	$k = 1;

		foreach (@alones) {
		push @res,[ $alones[$i], $alones[$k] ];
		$i++; $k++;
		if ( $k > $#alones ) {$k = 0;}
		}
	}

	if ( (1 + $#pairs) == 2 and (1 + $#alones) > 2 ) {

		push @res,[ $pairs[0][0], $pairs[1][0] ];
		push @res,[ $pairs[1][0], $pairs[0][1] ];
		push @res,[ $pairs[0][1], $pairs[1][1] ];
		push @res,[ $pairs[1][1], $pairs[0][0] ];

		$i = 0; $k = 1;

		foreach (@alones) {
		push @res,[ $alones[$i], $alones[$k] ];
		$i++; $k++;
		if ( $k > $#alones ) {$k = 0;}
		}
	}

	if ( (1 + $#pairs) == 1 and (1 + $#alones) > 2 ) {

		push @res,[ $pairs[0][0], $alones[0] ];
		push @res,[ $pairs[0][1], $alones[0] ];

		foreach (@alones) {
		push @res,[ $alones[$i], $alones[$k] ];
		$i++; $k++;
		if ( $k > $#alones ) {$k = 0;}
		}
	}

	if ( (1 + $#pairs) == 0 and (1 + $#alones) > 2 ) {

		foreach (@alones) {
		push @res,[ $alones[$i], $alones[$k] ];
		$i++; $k++;
		if ( $k > $#alones ) {$k = 0;}
		}
	}

	if ( (1 + $#pairs) > 2 and (1 + $#alones) == 2 ) {

		foreach (@pairs) {
		push @res,[ $pairs[$i][0], $pairs[$k][0] ];
		push @res,[ $pairs[$i][1], $pairs[$k][1] ];
		$i++; $k++;
		if ( $k > $#pairs ) {$k = 0;}
		}

		push @res,[ $alones[0], $pairs[0][0] ];
		push @res,[ $alones[1], $pairs[0][0] ];

	}

	if ( (1 + $#pairs) == 2 and (1 + $#alones) == 2 ) {

		push @res,[ $pairs[0][0], $pairs[1][0] ];
		push @res,[ $pairs[1][0], $pairs[0][1] ];
		push @res,[ $pairs[0][1], $pairs[1][1] ];
		push @res,[ $pairs[1][1], $pairs[0][0] ];

		push @res,[ $alones[0], $pairs[0][0] ];
		push @res,[ $alones[1], $pairs[0][0] ];
	}

	if ( (1 + $#pairs) == 1 and (1 + $#alones) == 2 ) {
	}

	if ( (1 + $#pairs) == 0 and (1 + $#alones) == 2 ) {
	}

	if ( (1 + $#pairs) > 2 and (1 + $#alones) == 1 ) {

		foreach (@pairs) {
		push @res,[ $pairs[$i][0], $pairs[$k][0] ];
		push @res,[ $pairs[$i][1], $pairs[$k][1] ];
		$i++; $k++;
		if ( $k > $#pairs ) {$k = 0;}
		}

		push @res,[ $alones[0], $pairs[0][0] ];

	}

	if ( (1 + $#pairs) == 2 and (1 + $#alones) == 1 ) {

		push @res,[ $pairs[0][0], $pairs[1][0] ];
		push @res,[ $pairs[1][0], $pairs[0][1] ];
		push @res,[ $pairs[0][1], $pairs[1][1] ];
		push @res,[ $pairs[1][1], $pairs[0][0] ];

		push @res,[ $alones[0], $pairs[0][0] ];
	}

	if ( (1 + $#pairs) == 1 and (1 + $#alones) == 1 ) {
	}

	if ( (1 + $#pairs) == 0 and (1 + $#alones) == 1 ) {
	}
	if ( (1 + $#pairs) > 2 and (1 + $#alones) == 0 ) {

		foreach (@pairs) {
		push @res,[ $pairs[$i][0], $pairs[$k][0] ];
		push @res,[ $pairs[$i][1], $pairs[$k][1] ];
		$i++; $k++;
		if ( $k > $#pairs ) {$k = 0;}
		}
	}

	if ( (1 + $#pairs) == 2 and (1 + $#alones) == 0) {

		push @res,[ $pairs[0][0], $pairs[1][0] ];
		push @res,[ $pairs[1][0], $pairs[0][1] ];
		push @res,[ $pairs[0][1], $pairs[1][1] ];
		push @res,[ $pairs[1][1], $pairs[0][0] ];
	}

	if ( (1 + $#pairs) == 1 and (1 + $#alones) == 0 ) {
	}

	if ( (1 + $#pairs) == 0 and (1 + $#alones) == 0 ) {
	}	
			
	return @res;
}

1;
