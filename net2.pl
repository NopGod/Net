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


$points{$_} = {} for (1..3);

# for (keys(%points)){
#   print $points{$_}{"x"}." $_\n";
# }
#print Dumper(\%hash);
#exit 0;

$first=1;

my $mw = new MainWindow;
$mw -> geometry ("900x500");

$code_font = $mw->fontCreate('code', -family => 'courier', -size => 8);
#my $image = $mw->Photo( -file => '1.png' );

$mw->repeat(100, \&do);

$mw->Button(  -text => "Next step",
              -command => sub {\&nextstep()},
              -font => $code_font )->pack;

$mw->Button(  -text => "Generate",
              -command => sub {\&gen()},
              -font => $code_font )->pack;


$label = $mw->Label( -image => $image )->pack(-side => right);

$label2 = $mw->Label( -text => "Info...",
                      -justify => 'left',
                      -padx => 15,
                      -font => $code_font )->pack( -side => left );

$label3 = $mw->Label( -text => "Stats...",
                      -justify => 'left' )->pack( -side => left );

$mw->MainLoop;

#------------------------------------------------------------------------------
sub do { # Таймер
  my $pr;
  for (keys(%points)){
    $pr .= $_ . ": x.". $points{$_}{"x"} ." y.". $points{$_}{"y"} ."
           Distance: ". $points{$_}{"S"} ."
              Check: ". $points{$_}{"c"} ."\n\n";
  }
  $pr .= "\n$pri ";
  $label2->configure (-text => $pr);
  #$label3->configure (-text => "$pri");
}

sub stats {
  my ($ot, $do, $dist)=@_;
  #push(@stats, );
  #$label3->configure (-text => $pron);
}

sub nextstep {
  my $img = GD::Simple->new(400, 400);
  my $rast;

  for (keys(%points)){
    my $rast = sprintf('%.f', distance(10, 10, $points{$_}{"x"}, $points{$_}{"y"}));

    #print "0-$_ $rast\n";

    $img->moveTo(10, 10);
    $img->lineTo($points{$_}{"x"}, $points{$_}{"y"});
    my ($predx, $predy, $pred)=($points{$_}{"x"}, $points{$_}{"y"}, $_);
    draw($img);
    stats($_, 0, $rast);

    for (keys(%points)){
      next if $_ == $pred;

      my $rast = sprintf('%.f', distance($predx, $predy, $points{$_}{"x"}, $points{$_}{"y"}));
      $img->moveTo($predx, $predy);
      $img->lineTo($points{$_}{"x"}, $points{$_}{"y"});

      #print "$pred-$_ $rast\n";
      stats($pred, $_, $rast);
      draw($img);
    }
  }

  drawhome($img);
  drawdot($img);
  draw($img);
}

sub gen { # Новая генерация
  $predx, $predy;

  my $img = GD::Simple->new(400, 400);

  for (keys(%points)){
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
    $img->moveTo($points{$_}{"x"}, $points{$_}{"y"});
    $img->bgcolor(undef);
    $img->fgcolor('gray');
    $img->ellipse(15, 15); # (x, y) Рисуем точки

    $img->fgcolor(0, 0, 0);
    $img->moveTo($points{$_}{"x"}-2, $points{$_}{"y"}-10);
    $img->string($_); # Номера точек
  }
}
