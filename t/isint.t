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
+ 1
~
  1

+1
~
  1

12
~
  1

-12
~
  1 

- 12
~
  1

a
~
  0

+ 1a
~
  0

";

sub test {
  (@test)=@_;
  return isint(@test);
}

print "Isint...\n";
test_Func(\&test,$tests,$runtests);

1;
