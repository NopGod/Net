#!/usr/bin/perl

#use AI::NNFlex::Backprop;
#use AI::NNFlex::Feedforward;
#use AI::NNFlex::Dataset;
$| = 1;

#use Tk;
use Tk::PNG;
use GD::Simple;
use MIME::Base64;
use Data::Dumper;

my $allpoints = 10;

for (1..$allpoints){

  $points{$_} = {};
  $bestway{$_} = {};
}
$points{"0"}{"x"} = $points{"0"}{"y"} = 10;

#print Dumper(\%points{"0".."2"});
#print $points{0..2};
#exit 0;

my $mw = new MainWindow;
$mw -> geometry ("900x500");

$code_font = $mw->fontCreate('code', -family => 'courier', -size => 8);
#my $image = $mw->Photo( -file => '1.png' );

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

$label2 = $mw->Label( -text => "Info...",
                      -justify => 'left',
                      -padx => 15,
                      -font => $code_font )->pack( -side => left );

$label3 = $mw->Label( -text => "Stats...",
                      -justify => 'left',
                      -font => $code_font )->pack( -side => left );

$mw->MainLoop;

#------------------------------------------------------------------------------
sub do { # Таймер
  my $pr;
  for (keys(%points)){
    next if $_ == 0;
    $pr .= $_ . ": x.". $points{$_}{"x"} ." y.". $points{$_}{"y"} ."\n\n";
  }
  $pr .= "\n";
  $label2->configure (-text => $pr);
  $label3->configure (-text => "$pri");
}

sub bestway {

  for (keys(%bestway)){
    #$bestway{"0"}{$_} = $bestway{$_}{"0"};
  }
  $pri = Dumper(\%bestway);
}

sub stats {
  my ($ot, $do, $dist)=@_;
  $bestway{$ot}{$do} = $dist;
  $pri = Dumper(\%bestway);
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

    $bestway{$_}{"0"} = $rast;
    draw($img);

    for (keys(%points)){
      next if exists $bestway{$_}{$pred};

      next if $_ == $pred;
      print "$_ $pred ".$points{$_}{$pred};

      my $rast = sprintf('%.f', distance($predx, $predy, $points{$_}{"x"}, $points{$_}{"y"}));

      $img->fgcolor(200, 200, 200);
      $img->moveTo($predx, $predy);
      $img->lineTo($points{$_}{"x"}, $points{$_}{"y"});

      $bestway{$pred}{$_} = $rast;
      draw($img);
    }
  }
  $pri = Dumper(\%bestway);
  drawhome($img);
  drawdot($img);
  draw($img);
}

sub gen { # Новая генерация
  $predx, $predy;

  my $img = GD::Simple->new(400, 400);

  for (keys(%points)){
    next if $_ == 0;
    $points{$_}{"x"} = int(rand(400));   # Занесение в массив точек
    $points{$_}{"y"} = int(rand(400));   #
    #$_->{$co}->{"c"} = 0;
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
