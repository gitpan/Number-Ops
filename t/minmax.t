#!/usr/local/bin/perl -w

require 5.001;

$runtests=shift(@ARGV);
if ( -f "t/test.pl" ) {
  require "t/test.pl";
  $dir="t";
} elsif ( -f "test.pl" ) {
  require "test.pl";
  $dir=".";
} else {
  die "ERROR: cannot find test.pl\n";
}

unshift(@INC,$dir);
use Number::Ops qw(:all);

$tests = "
1 1.5 2 3.8 ~ 1 3.8

-1.0 -1.5 -2.0 ~ -2.0 -1.0

";

sub test {
  (@test)=@_;
  return (min(@test),max(@test));
}

print "Min/Max...\n";
test_Func(\&test,$tests,$runtests);

1;
