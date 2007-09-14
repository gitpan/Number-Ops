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
1.2 ~ 1

1.5 ~ 2

1.6 ~ 2

2.0 ~ 2

2   ~ 2

2 1 ~ 2.0

2.0 1 ~ 2.0

2.13 1 ~ 2.1

2.15 1 ~ 2.2

2.63 1 ~ 2.6

";

sub test {
  (@test)=@_;
  return round(@test);
}

print "Round...\n";
test_Func(\&test,$tests,$runtests);

1;
