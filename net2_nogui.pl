#!/usr/bin/perl

use Data::Dumper;
#use Math::Combinatorics;
use Benchmark qw(:all) ;
$| = 1;

my $allpoints = 8; # Всего точек

for (1..$allpoints){
  $points{$_} = {};
}

my (%bestway);

$points{"0"}{"x"} = $points{"0"}{"y"} = 10;

#print Dumper(\%bestway);

#exit 0;

for (keys(%points)){

  next if $_ == 0;

  
  $points{$_}{"x"} = int(rand(400));   # Занесение в массив точек
  $points{$_}{"y"} = int(rand(400));   #
}

for (keys(%points)){
  next if $_ == $pred;

  my $rast = int(rand(400));
  my ($predx, $predy, $pred)=($points{$_}{"x"}, $points{$_}{"y"}, $_);
  $bestway{"$_.0"}= $rast;
  #$bestway{$_}{"0"} = $rast;

  for (keys(%points)){
    next if $bestway{"$_.$pred"};
    next if $_ == $pred;

    my $rast = int(rand(400));
    $bestway{"$pred.$_"}= $rast;
  }
}

push(@curr,$_) foreach (1..$allpoints);

# for(keys %bestway){
#   push(@arre,);
# }

#push(my @array, sort {$a<=>$b} values %bestway);
#print shift @array;
sub fact {
  my $n = shift;
  my $result = 1;
  foreach my $i (1 .. $n) {
    $result *= $i;
  }
  $result
}

foreach my $i (0..16) {
    print "$i! = ", fact($i), "\n";
}
# sub combine;
#
# for (combine [@curr], $#curr) {
#
# }
#
# sub combine {
#
#   my ($list, $n) = @_;
#   die "Insufficient list members" if $n > @$list;
#
#   return map [$_], @$list if $n <= 1;
#
#   my @comb;
#
#   for my $i (0 .. $#$list) {
#     my @rest = @$list;
#     my $val  = splice @rest, $i, 1;
#     push @comb, [$val, @$_] for combine \@rest, $n-1;
#     print $co++."\n";
#   }
#
#   return @comb;
# }


#-------------------------------------------------------------------------------


# timethese(2000000, {
# 'Name1' => sub {
#   for (0..10){
#     push(@testtest,$_);
#   }
# },
# 'Name2' => sub {
#   $testtest=[@curr];
# },
# });



#-------------------------------------------------------------------------------

# while(my @permu = $combinat->next_permutation){
#   my ($chot, $chdo, $ot, $alldest);
#   unshift(@permu,0);
#
#   foreach(0..$#permu-1){
#     $chot = $permu[$ot];
#     $ot++;
#     $chdo = $permu[$ot];
#     $alldest+= $bestway{"$chot.$chdo"} ? ($bestway{"$chot.$chdo"}) : $alldest+= $bestway{"$chdo.$chot"};
#   }
#   $winner{$alldest} = join('.', @permu);
# }

push(my @array, sort {$a<=>$b} keys %winner);
my @doneway = split(/\./, $winner{$array[0]});
print $pri = "WON THE WAY: ".join(' ', @doneway);
