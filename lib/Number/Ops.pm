package Number::Ops;
# Copyright (c) 2007-2008 Sullivan Beck. All rights reserved.
# This program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

###############################################################################

$VERSION = "1.03";

require 5.000;
require Exporter;
use warnings;
use Carp;

@ISA = qw(Exporter);
@EXPORT_OK = qw(randomize random
                min max
                isint isnum
                round
               );
%EXPORT_TAGS = (all => \@EXPORT_OK);

use strict;
###############################################################################
###############################################################################

{
   my $randomized = 0;

   sub randomize {
      return  if ($randomized);
      $randomized = 1;
      srand(time);
   }
}

sub random {
   my($range)=shift;
   return int(rand()*$range);
}

########################################################################

sub min {
  my(@vals)=@_;
  my($val)=();
  my($min)=pop(@vals);
  foreach $val (@vals) {
    $min=$val if ($val < $min);
  }
  return $min;
}

sub max {
  my(@vals)=@_;
  my($val)=();
  my($max)=pop(@vals);
  foreach $val (@vals) {
    $max=$val if ($val > $max);
  }
  return $max;
}

########################################################################

sub isnum {
  my($n,$low,$high)=@_;
  return undef    if (! defined $n);
  return 0        if ($n !~ /^\s*([+-]?)\s*(\d+\.?\d*)\s*$/  and
                      $n !~ /^\s*([+-]?)\s*(\.\d+)\s*$/);
  $n="$1$2";
  if (defined $low  and  length($low)>0) {
    return undef  if (! isnum($low));
    return 0      if ($n<$low);
  }
  if (defined $high  and  length($high)>0) {
    return undef  if (! isnum($high));
    return 0  if ($n>$high);
  }
  return 1;
}

sub isint {
  my($n,$low,$high)=@_;
  return 0  if (! defined $n  or
                $n !~ /^\s*[-+]?\s*\d+\s*$/  or
                defined $low   &&  $n<$low  or
                defined $high  &&  $n>$high);
  return 1;
}

########################################################################

sub round {
  my($num)=shift;
  my($dec)=shift;
  return(int($num+0.5))  if (! $dec);
  return($num)           if (! isint($dec) or $dec<1  or  ! isnum($num));
  $num=~ s/\s*//;
  $num=$num*10**$dec;
  $num=round($num);
  while (length($num)<($dec+1)) {
    $num="0$num";
  }
  $num=~ s/(.{$dec})$/.$1/;
  return($num);
}

###############################################################################

1;
# Local Variables:
# mode: cperl
# indent-tabs-mode: nil
# cperl-indent-level: 3
# cperl-continued-statement-offset: 2
# cperl-continued-brace-offset: 0
# cperl-brace-offset: 0
# cperl-brace-imaginary-offset: 0
# cperl-label-offset: -2
# End:
