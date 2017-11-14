#!/usr/bin/perl

use strict; use warnings;
use Data::Dumper;

my (%points, %bestway, @arr_all_dots);
my $alldots = 5;
for (1..$alldots){ # Создание хэша с нулями
  $points{$_}{"x"} = $points{$_}{"y"} = $points{$_}{"c"} = 0;
}

# Координаты домашней точки
$points{"0"}{"x"} = $points{"0"}{"y"} = 10;

gen(); dest_matrix();

# print Dumper(\%points);
#print Dumper(\%bestway);

my (@near, @near3, %near_dist);
for (keys(%points)){

  if ($_ =~/0\.(\d+)/ || $_ =~/(\d+)\.0/){
    push(@near, $1); # Все точки от текущей
  }
  #$near_dist{$near[$_]} = $bestway{$near[$_]};
  #push(my @near3, sort {$a<=>$b} @near);
  #push(my @name, sort { $bestway{$a} <=> $bestway{$b} } values %bestway);
}

print Dumper(\%near_dist);


# Сортировка номеров точек
push(my @array, sort {$a<=>$b} keys %points);

while (my @next_n = splice @array, 0, 3){
  print join (" ", @next_n) ."\n";
}
#-------------------------------------------------------------------------------

sub gen { # Генерация точек
  #$predx, $predy, $pri2, $pri;
  for (keys(%points)){
    next if $_ == 0;

    # Занесение в массив точек
    $points{$_}{"x"} = int(rand(400));
    $points{$_}{"y"} = int(rand(400));
  }
}

sub dest_matrix {
  my ($predx, $predy, $pred, $rast) = ($points{"0"}{"x"}, $points{"0"}{"y"}, 0);

  for (keys(%points)){ # Работает, не трогать
    # Пропускаем итерацию, если точка совпадает с предыдущей
    next if $_ == $pred;

    # Заносим расстояние от дома в матрицу расстояний и отмечаем точку как предыдущую
    my $rast = sprintf('%.f', distance($predx, $predy, $points{$_}{"x"},$points{$_}{"y"}));
    $bestway{"0.$_"}= $rast;
    my ($predx, $predy, $pred)=($points{$_}{"x"}, $points{$_}{"y"}, $_);

    for (keys(%points)){
      # Пропускаем итерацию, если уже есть расстояние в обратном направлении или точка совпадает с предыдущей
      next if $bestway{"$_.$pred"};
      next if $_ == $pred;

      # Узнаем расстояние и заносим его в матрицу расстояний
      my $rast = sprintf('%.f', distance($predx, $predy, $points{$_}{"x"}, $points{$_}{"y"}));
      $bestway{"$pred.$_"}= $rast;
    }
  }
}

sub distance { # расстояние = (x1 - x2)**2 + (y1 - y2)**2
  my ($otx,$oty,$dox,$doy) = @_;
  return sqrt(($dox - $otx)**2+($doy - $oty)**2);
}
