package Number::Ops;
# Copyright (c) 2007-2007 Sullivan Beck. All rights reserved.
# This program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

###############################################################################
# HISTORY
###############################################################################

# Version 1.00  2007-09-06
#    Initial release

$VERSION = "1.00";
###############################################################################

require 5.000;
require Exporter;
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

=pod

=head1 NAME

Number::Ops - Simple operations on numbers.

=head1 SYNOPSIS

   use Number::Ops qw(:all);

=head1 DESCRIPTION

This contains a number of very simple number operations.

=head1 ROUTINES

=over 4

=cut

###############################################################################
###############################################################################
=pod

=item randomize, random

   use Number::Ops qw(:all);
   randomize;
   $val = random($range);

Randomize initializes the random number generator. It will be
called automatically if it is not called explicitly. Also, it
will only initialize the random number generator one time per
session.

Random returns an integer in the range 0 ... $range-1.

=cut

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

=pod

=item min, max

   use Number::Ops qw(:all);
   $value=min(@list);
   $value=max(@list);

Returns the numerical minimum/maximum value of all arguments.

=cut

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

=pod

=item isnum, isint

   use Number::Ops qw(:all);
   $flag=isnum($string [,$low, $high]);
   $flag=isint($string [,$low, $high]);

isnum returns 1 if $string is a valid real number with no exponent, 0
otherwise.  If $low is entered, $string must be >= $low.  If $high is
entered, $string must be <= $high.  It is valid to check only one of the
bounds.

isint is similar but checks integers.

=cut

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

=pod

=item round

   $value = round($num [,$dec]);

Rounds to the closest integer or to $dec number of decimal places.

=cut

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
###############################################################################
=pod

=back

=head1 KNOWN PROBLEMS

None at this point.

=head1 AUTHOR

Sullivan Beck (sbeck@cpan.org)

=cut

1;
# Local Variables:
# indent-tabs-mode: nil
# End:
