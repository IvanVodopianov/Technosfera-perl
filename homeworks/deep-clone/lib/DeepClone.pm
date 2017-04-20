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
sub check_cycle {
my $aref = shift;
my $href = {};
$href = collect_refs($href, $aref);

if ($href->{$aref} > 1) {return 1;}
return 0;

}
sub collect_refs {
my $href = shift;
my $aref = shift;
if (ref \$aref eq "SCALAR") {
unless (exists $href->{$_}) {
$href->{$_} = 1;
}
else {
  $href->{$_}++;
}
}
if (ref $aref eq "ARRAY") {
    unless (exists $href->{$aref}) {
		$href->{$aref} = 1;
		foreach (@{$aref}) {
#	say $_;
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
#		say "value: ", $v;
    collect_refs($href, $v);
		}
		}
		else {
		  $href->{$aref}++;
		}
		}
return $href;
}
sub check {
  my $this = shift;
	my $param = shift;
#	say $this," ref: ", (ref $this);
#	say "param: ", $param;

  if ( (ref $this) eq "ARRAY" ) {
#	say $this;
  foreach (@{ $this} ) {
#say "from for. element: ", $_," param: ", $param;
if ( check($_, $param) == 0 ) {return 0;}
}
  }

  if ( (ref $this) eq "HASH" ) {
	foreach (values %{ $this } ) {
#	say "value: ",$_," ref: ",(ref \$_);
  if ( check($_, $param) == 0) {return 0;}
	}
	}

  if ( (ref \$this) eq "SCALAR" ) { $param = 1; }
#	if ( !defined($this)  ) { $param = 0; }
  if (  (ref $this) eq "CODE" ) { $param = 0; }
	return $param;
}
sub clone_cycle {
#  my $href = shift;
  my $ref_copied = shift;
  my $this = shift;
#  my $dest = shift;

#  if ( check($this,1) == 0 ) { return undef; }
  if ( ref \$this eq "SCALAR" ) {
	  return $this;
	}
	elsif ( ref $this eq "ARRAY" ) {
	if ($ref_copied->{$this} < 1) {
	  $ref_copied->{$this} = 1;
		return [ map clone_cycle($ref_copied,$_), @{ $this } ];
		}
	else {
	  return $this;
	}
	}
	elsif ( ref $this eq "HASH" ) {
	if ($ref_copied->{$this} < 1) {
	  $ref_copied->{$this} = 1;
		return (scalar { map { $_ => clone_cycle($ref_copied,$this->{$_}) } keys %{ $this } });
		}
	else {
	return $this;
	}
}
}
sub clone1 {
  my $this = shift;
	if ( check($this,1) == 0 ) { return undef; }
	if ( ref \$this eq "SCALAR" ) {
	  return $this;
	}
	elsif ( ref $this eq "ARRAY" ) {
	  return [ map clone1($_), @{ $this } ];
	}
	elsif ( ref $this eq "HASH" ) {
	  return (scalar { map { $_ => clone1($this->{$_}) } keys %{ $this } });
		}
}
sub clone {
my $this = shift;
if (check_cycle($this)) {
my $href = {};
#my $aref = [];
$href->{$this}=1;
return clone_cycle($href,$this);
}
else {
return clone1($this);
}
}

1;
