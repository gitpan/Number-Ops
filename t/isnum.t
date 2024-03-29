#!/usr/bin/perl -w

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

+ 12.
~
  1

- .35
~
  1

-.35
~
  1

";

sub test {
  (@test)=@_;
  return isnum(@test);
}

print "Isnum...\n";
test_Func(\&test,$tests,$runtests);

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

