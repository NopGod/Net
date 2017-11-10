#!/usr/bin/perl

use Tk::PNG;
use GD::Simple;
use MIME::Base64;
use Data::Dumper;
use Math::Combinatorics;
$| = 1;

my $allpoints = 5; # Всего точек

for (1..$allpoints){
  $points{$_} = {};
}

my (%bestway);

$points{"0"}{"x"} = $points{"0"}{"y"} = 10;

#print Dumper(\%bestway);
#exit 0;

my $mw = new MainWindow;
$mw -> geometry ("900x500");

$code_font = $mw->fontCreate('code',  -family => 'courier',
                                      -size => 8);

$mw->repeat(100, \&do);

$mw->Button(  -text => "Generate",
              -command => sub {\&gen()},
              -font => $code_font )->pack;

$mw->Button(  -text => "Search",
              -command => sub {\&search()},
              -font => $code_font )->pack;

$mw->Button(  -text => "Best way",
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

$mw->MainLoop;
#------------------------------------------------------------------------------
sub do { # Таймер
  my $pr;

  for (keys(%points)){
    next if $_ == 0;

    $pr .= $_ .": x.". $points{$_}{"x"} .
                " y.". $points{$_}{"y"} ."\n";
  }
  $pr .= "API counter: $api\n";
  $label2->configure (-text => $pr);
  $label3->configure (-text => "$pri");
}

sub bestway {
  my $img = GD::Simple->new(400, 400);
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
      $alldest+= $bestway{"$chot.$chdo"} ? ($bestway{"$chot.$chdo"}) : $alldest+= $bestway{"$chdo.$chot"};
    }
    $winner{$alldest} = join('.', @permu);
  }
  push(my @array, sort {$a<=>$b} keys %winner);
  my @doneway = split(/\./, $winner{$array[0]});
  $pri = "WON THE WAY: ".join(' ', @doneway);

  for(0..$#doneway-1){
    $img->fgcolor(100, 200, 100);
    $img->moveTo($points{$doneway[$_]}{"x"}, $points{$doneway[$_]}{"y"});
    $img->lineTo($points{$doneway[$_+1]}{"x"}, $points{$doneway[$_+1]}{"y"});
    drawhome($img); drawdot($img); draw($img);
  }
}

sub search {
  my $img = GD::Simple->new(400, 400);
  my $rast;

  for (keys(%points)){
    next if $_ == $pred;

    my $rast = sprintf('%.f', distance($predx, $predy, $points{$_}{"x"}, $points{$_}{"y"}));

    $img->fgcolor(200, 200, 200);
    $img->moveTo(10, 10);
    $img->lineTo($points{$_}{"x"}, $points{$_}{"y"});

    my ($predx, $predy, $pred)=($points{$_}{"x"}, $points{$_}{"y"}, $_);
    $bestway{"$_.0"}= $rast;
    #$bestway{$_}{"0"} = $rast;
    draw($img);

    for (keys(%points)){
      next if $bestway{"$_.$pred"};
      next if $_ == $pred;

      my $rast = sprintf('%.f', distance($predx, $predy, $points{$_}{"x"}, $points{$_}{"y"}));

      $img->fgcolor(200, 200, 200);
      $img->moveTo($predx, $predy);
      $img->lineTo($points{$_}{"x"}, $points{$_}{"y"});
      $api++;
      $bestway{"$pred.$_"}= $rast;

      draw($img);
    }
  }
  $pri = Dumper(\%bestway);
  drawhome($img); drawdot($img); draw($img);
}

sub gen { # Новая генерация
  $predx, $predy;

  my $img = GD::Simple->new(400, 400);

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
