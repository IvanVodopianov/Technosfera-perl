package DeepClone;

use 5.010;
use strict;
use warnings;

=encoding UTF8

=head1 SYNOPSIS

Клонирование сложных структур данных

=head1 clone($orig)

Функция принимает на вход ссылку на какую либо структуру данных и отдаюет, в качестве результата, ее точную независимую копию.
Это значит, что ни один элемент результирующей структуры, не может ссылаться на элементы исходной, но при этом она должна в точности повторять ее схему.

Входные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив и хеш, могут быть любые из указанных выше конструкций.
Любые отличные от указанных типы данных -- недопустимы. В этом случае результатом клонирования должен быть undef.

Выходные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив или хеш, не могут быть ссылки на массивы и хеши исходной структуры данных.

=cut
sub check_if_cycle {
  my $aref = shift;
	my $href = {};
	$href = collect_refs($href, $aref);
	  if (defined $aref) {
		  if ($href->{$aref} > 1) {return 1;}
		}
	return 0;
}
sub collect_refs {
  my $href = shift;
	my $aref = shift;
	if ((ref \$aref eq "SCALAR") or (!defined $aref)) {
	  unless (exists $href->{$aref}) {
		  $href->{$aref} = 1;
		}
		else {
		  $href->{$aref}++;
		}
	}

  if (ref $aref eq "ARRAY") {
	  unless (exists $href->{$aref}) {
		  $href->{$aref} = 1;
			foreach (@{$aref}) {
			  collect_refs($href, $_);
			}
		}
		else {
		  $href->{$aref}++;
		}

  }
	if ( ref $aref eq "HASH" ) {
	  unless (exists $href->{$aref}) {
		  $href->{$aref} = 1;
			foreach my $v (values %{$aref}) {
			  collect_refs($href, $v);
			}
		}
		else {
		  $href->{$aref}++;
		}
	}
	return $href;
}
sub check_for_members {
  my $this = shift;
	my $param = shift;

  if ( (ref $this) eq "ARRAY" ) {
	  foreach (@{ $this} ) {
		  if ( check_for_members($_, $param) == 0 ) {return 0;}
		}
  }

  if ( (ref $this) eq "HASH" ) {
	  foreach (values %{ $this } ) {
		  if ( check_for_members($_, $param) == 0) {return 0;}
		}
	}

  if ( (ref \$this) eq "SCALAR" ) { $param = 1; }
  if (  (ref $this) eq "CODE" ) { $param = 0; }

	return $param;
}
sub clone_cycle {
  my $ref_copied = shift;
	my $this = shift;

  if ( ref \$this eq "SCALAR" ) {
	  return $this;
	}
	elsif ( ref $this eq "ARRAY" ) {
	  if ($ref_copied->{$this} < 1) {
		  $ref_copied->{$this} = 1;
			return [ map clone_cycle($ref_copied,$_), @{ $this } ];
		}
		else {
		my $tmp = [];
		foreach (@$this) { push @$tmp, $_ };
		return $tmp;
		}
	}

  elsif ( ref $this eq "HASH" ) {
	  if ($ref_copied->{$this} < 1) {
		  $ref_copied->{$this} = 1;
			return (scalar { map { $_ => clone_cycle($ref_copied,$this->{$_}) } keys %{ $this } });
		}
		else {
		  my $tmp = {};
			foreach (keys %$this) { $tmp->{$_} = $this->{$_} };
			return $tmp;
		}
	}
}
sub clone1 {
  my $this = shift;
	if ( check_for_members($this,1) == 0 ) { return undef; }
	if ( ref \$this eq "SCALAR" ) { return $this;}
	elsif ( ref $this eq "ARRAY" ) {
	  return [ map clone1($_), @{ $this } ];
	}
	elsif ( ref $this eq "HASH" ) {
	  return (scalar { map { $_ => clone1($this->{$_}) } keys %{ $this } });
	}
}
sub clone {
  my $this = shift;
	if (check_if_cycle($this)) {
	  my $href = {};
		$href->{$this}=1;
		return clone_cycle($href,$this);
	}
	else {
	  return clone1($this);
	}
}

1;
