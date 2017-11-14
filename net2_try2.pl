#!/usr/bin/perl

use Tk::PNG;
use GD::Simple;
use MIME::Base64;
use Data::Dumper;
use Math::Combinatorics;
use Benchmark qw(:all) ;
$| = 1;

my $allpoints = 10; # Всего точек

for (1..$allpoints){
  $points{$_}{"x"} =$points{$_}{"y"} = $points{$_}{"c"} = 0;
}
$points{"0"}{"c"}= 1;
my (%bestway);

$points{"0"}{"x"} = $points{"0"}{"y"} = 10;

# print Dumper(\%points);
# exit 0;

my $mw = new MainWindow;
$mw -> geometry ("900x500");

$code_font = $mw->fontCreate('code',  -family => 'courier',
                                      -size => 8);

$mw->repeat(100, \&do);

# $mw->Button(  -text => "Generate",
#               -command => sub {\&gen()},
#               -font => $code_font )->pack;

$mw->Button(  -text => "Smart",
              -command => sub {\&search()},
              -font => $code_font )->pack;

$mw->Button(  -text => "Bruteforce",
              -command => sub {\&bestway()},
              -font => $code_font )->pack;

$label = $mw->Label( -image => $image )->pack(-side => right);

$label2 = $mw->Label( -text => "",
                      -justify => 'left',
                      -padx => 15,
                      -font => $code_font )->pack( -side => left );

$label3 = $mw->Label( -text => "",
                      -justify => 'left',
                      -font => $code_font )->pack( -side => left );
gen();


$mw->MainLoop;
#------------------------------------------------------------------------------
sub do { # Таймер
  my $pr;

  for (keys(%points)){
    next if $_ == 0;
    $pr .= $_ .": x.". $points{$_}{"x"} .
                " y.". $points{$_}{"y"} ."\n";
  }
  $label2->configure (-text => $pr);
  $label3->configure (-text => "$pri2\n$pri");
}

sub search {
  my $pred = 0;
  #my $had = "0 ";
  for (0..$allpoints){
    #my $tests= $_;
    my $rast;
    my %bestway;
    for (keys(%points)){
      $curp=$_;

      next if ($had =~/$curp/ or $curp eq $pred);
      $img->moveTo($points{$pred}{"x"}, $points{$pred}{"y"});
      $img->bgcolor('gray');
      $img->fgcolor('gray');
      $img->ellipse(15, 15); # (x, y) Рисуем точки


      $rast = sprintf('%.f', distance($points{$pred}{"x"}, $points{$pred}{"y"}, $points{$curp}{"x"}, $points{$curp}{"y"}));

      $bestway{"$pred.$curp"} = $rast;
      #$pred=$_;
      #$img = GD::Simple->new(400, 400);
      
    }


    $had.="$pred ";
    foreach my $name (sort { $bestway{$a} <=> $bestway{$b} } keys %bestway) {
      #print Dumper(\%bestway);
      $tlen+= $bestway{$name};
      $pred = $1 if $name =~/\.(\d+)/;
      #$winner .= "$pred ";

      $img->fgcolor(230, 230, 230);
      $img->moveTo($points{$pred}{"x"}, $points{$pred}{"y"});
      $img->lineTo($points{$curp}{"x"}, $points{$curp}{"y"});
      select(undef, undef, undef, 0.15);
      draw($img);
      #print "check - ".$points{$curp}{"c"}." pred_new - $name $pred - $rast\n";
      last;

    }
    # my $drp = $1 if $curp=~/(\d+)\./;
    # print $curp;
    # exit;

  }
  my @doneway = split(/ /, $had);
  #print $had;

  for (0..$#doneway-1){
    #print $doneway[$_]."\n";

    $img->fgcolor(100, 200, 100);
    $img->moveTo($points{$doneway[$_]}{"x"}, $points{$doneway[$_]}{"y"});
    $img->lineTo($points{$doneway[$_+1]}{"x"}, $points{$doneway[$_+1]}{"y"});
    #select(undef, undef, undef, 0.25);
    draw($img);
    $mw->update;
  }
  #drawhome($img); drawdot($img); draw($img);
  $pri2 = "Total length(smart): $tlen\n";
}

sub bestway {
  my $rast;
  my %bestway;
  for (keys(%points)){
    next if $_ == $pred;

    my $rast = sprintf('%.f', distance($predx, $predy, $points{$_}{"x"}, $points{$_}{"y"}));

    my ($predx, $predy, $pred)=($points{$_}{"x"}, $points{$_}{"y"}, $_);
    $bestway{"$_.0"}= $rast;
    #$bestway{$_}{"0"} = $rast;

    for (keys(%points)){
      next if $bestway{"$_.$pred"};
      next if $_ == $pred;
      my $rast = sprintf('%.f', distance($predx, $predy, $points{$_}{"x"}, $points{$_}{"y"}));

      $bestway{"$pred.$_"}= $rast;


    }
  }
  #print Dumper(\%bestway);

  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  my (@curr,%winner);

  push(@curr,$_) foreach (1..$allpoints);

  my $combinat = Math::Combinatorics->new( count => 2, data => [@curr]);

  while(my @permu = $combinat->next_permutation){
    my ($chot, $chdo, $ot, $alldest);
    unshift(@permu,0);

    foreach(0..$#permu-1){
      $chot = $permu[$ot];
      $ot++;
      $chdo = $permu[$ot];
      if ($bestway{"$chot.$chdo"}){
        $alldest+= $bestway{"$chot.$chdo"}
      } elsif ($bestway{"$chdo.$chot"}){
        $alldest+= $bestway{"$chdo.$chot"}
      }
    }
    $winner{$alldest} = join('.', @permu);
  }
  #print Dumper(\%bestway);
  push(my @array, sort {$a<=>$b} keys %winner);
  my @doneway = split(/\./, $winner{$array[0]});
  #print Dumper(\@array);
  $pri = "Total length(bruteforce): ".$array[0];

  for(0..$#doneway-1){
    $img->fgcolor(250, 100, 100);
    $img->moveTo($points{$doneway[$_]}{"x"}+3, $points{$doneway[$_]}{"y"}+3);
    $img->lineTo($points{$doneway[$_+1]}{"x"}+3, $points{$doneway[$_+1]}{"y"}+3);
    draw($img);
    select(undef, undef, undef, 0.25);
    $mw->update;
  }
}

sub gen { # Новая генерация
  $predx, $predy, $pri2, $pri;

  $img = GD::Simple->new(400, 400);

  for (keys(%points)){
    next if $_ == 0;
    $points{$_}{"x"} = int(rand(400));   # Занесение в массив точек
    $points{$_}{"y"} = int(rand(400));   #
  }
  drawhome($img); drawdot($img); draw($img);
}

sub distance {
  ($otx,$oty,$dox,$doy) = @_;
  return sqrt(($dox-$otx)**2+($doy-$oty)**2);
}

sub draw {
  my $png = $mw->Photo(-data => encode_base64( $_[0]->png ));
  $label->configure (-image => $png);
}

sub drawhome {
  $_[0]->moveTo(10, 10);
  $_[0]->bgcolor('orange');
  $_[0]->fgcolor('black');
  $_[0]->ellipse(15, 15); # (x, y) Точка отправления
}

sub drawdot {
  my $img = $_[0];

  for (keys(%points)){
    next if $_ == 0;

    $img->moveTo($points{$_}{"x"}, $points{$_}{"y"});
    $img->bgcolor(undef);
    $img->fgcolor('gray');
    $img->ellipse(15, 15); # (x, y) Рисуем точки

    $img->fgcolor(0, 0, 0);
    $img->moveTo($points{$_}{"x"}-2, $points{$_}{"y"}-10);
    $img->string($_); # Номера точек
  }
}
