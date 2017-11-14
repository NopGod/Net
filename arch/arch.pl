#!/usr/bin/perl

#use strict; use warnings;

# my (@all_file_dec, $chunk);
# {
#    open(my $FILE, "arch.pl") or die $!;
#    binmode($FILE);
#
#    local $/ = \1;
#    while ( my $byte = <$FILE> ) {
#      #push(@all_file_dec, unpack "C*", $byte);
#      $chunk.=$byte;
#       #print unpack "C*", $byte;
#       #print $byte;
#    }
#
#    close $FILE;
# }

# Функция должна принимать в качестве аргумента массив чисел и возвращать
# так же массив, но отсортированный по возрастанию.
# Пример: В функцию передали [1, 22, 5, 66, 3, 57]. Вернула: [1, 3, 5, 22, 57, 66]
# print a([1,2,3,4],"+");sub a{($b,$c)=@_;eval join$c,@$b}

use Tk::PNG;
use GD::Simple;
use MIME::Base64;
$| = 1;

for (0..10){
  $points[$_] = int(rand(400));
}

my $mw = new MainWindow;

$mw -> geometry ("900x500");

$mw->repeat(100, \&a();
$label = $mw->Label( -image => $image )->pack();
$mw->MainLoop;
#print "sorted: " . join(' ', a([1, 22, 5.2, 5.1, 3, 57]));
#-------------------------------------------------------------------------------
sub a{
  # ($a)=shift;
  # @a=@$a;
  my $img = GD::Simple->new(400, 400);
  $img->moveTo(10, 10);
  $img->bgcolor('orange');
  $img->fgcolor('black');
  $img->ellipse(15, 15);
  $png = $mw->Photo(-data => encode_base64( $img->png ));
  $label->configure(-image => $png);
  #
  # while($check==0){
  #   $check=1;
  #
  #   for (0..$#a) {
  #     $q1=$_;
  #     $q2=$_+1;
  #
  #     last unless ($a[$q2]);
  #
  #     if ($a[$q1] > $a[$q2]){
  #       @a[$q1,$q2]=@a[$q2,$q1];
  #       $check=0;
  #     }
  #   }
  # }

}
