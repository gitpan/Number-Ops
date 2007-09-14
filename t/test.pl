#!/usr/local/bin/perl -w
# Copyright (c) 1996-2007 Sullivan Beck. All rights reserved.
# This program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

###############################################################################
# HISTORY
#
# 1996-??-??  Wrote initial version for Date::Manip module
#
# 1996-2001   Numerous changes
#
# 2001-03-29  Rewrote to make it easier to drop in for any module.
#
# 2001-06-19  Modifications to make space delimited stuff work better.
#
# 2001-08-23  Added support for undef args.
#
# 2007-08-14  Better support for undef/blank args.

###############################################################################

# Usage: test_Func($funcref,$tests,$runtests,@extra)=@_;
#
# This takes a series of tests, runs them, compares the output of the tests
# with expected output, and reports any differences.  Each test consists of
# several parts:
#    a function passed in as a reference ($funcref)
#    a series of arguments to be passed to the function
#    the expected output from the function call
#
# Tests may be passed in in two methods: as a string, or as a reference.
#
# Using the string case, $tests is a newline delimited string.  Each test
# takes one or more lines of the string.  Tests are separated from each
# other by a blank line.
#
# Arguments and return value(s) may be written as a single line:
#    ARG1 ARG2 ... ARGn ~ VAL1 VAL2 ... VALm
# or as multiple lines:
#    ARG1
#    ARG2
#    ...
#    ARGn
#    ~
#    VAL1
#    VAL2
#    ...
#    VALm
#
# If any of the arguments OR values have spaces in them, only the multiline
# form may be used.
#
# If there is exactly one return value, the separating tilde is
# optional:
#    ARG1 ARG2 ... ARGn VAL1
# or:
#    ARG1
#    ARG2
#    ...
#    ARGn
#    VAL
#
# It is valid to have a function with no arguments or with no return
# value.  The "~" must be used:
#
#    ARG1 ARG2 ... ARGn ~
#    ~ VAL1 VAL2 ... VALm
#    ~
#
# Leading and trailing space is ignored in the multi-line format.
#
# If desired, any of the ARGs or VALs may be the word "_undef_" which
# will be strictly interpreted as the perl undef value. The word "_blank_"
# may also be used to designate a defined but empty string.
#
# Alternately, the tests can be passed in as a list reference:
#    $tests = [
#               [
#                 [ @ARGS1 ],
#                 [ @VALS1 ]
#               ],
#               [
#                 [ @ARGS2 ],
#                 [ @VALS2 ]
#               ], ...
#             ]
#
# @extra are extra arguments which are added to the function call.
#
# The tests can be run in an interactive way (using the "runtests" command)
# or in a non-interactive way (as part of a "make test").  If $runtests is
# 0, the non-interactive way is done.  If $runtests a negative number -N,
# only the Nth test is run.  If $runtests is a positive number +N, all tests
# starting with the Nth test are run.

sub test_Func {
   my($funcref,$tests,$runtests,@extra)=@_;
   my(@tests);
   $runtests=0  if (! $runtests);

   if (ref($tests) eq "ARRAY") {
      @tests = @$tests;

   } else {
      # Separate tests.
  
      my($comment)="#";
      my(@lines)=split(/\n/,$tests);
      my(@test);
      while (@lines) {
         my $line = shift(@lines);
         $line =~ s/^\s*//;
         $line =~ s/\s*$//;
         next  if ($line =~ /^$comment/);
  
         if ($line ne "") {
            push(@test,$line);
            next;
         }
  
         if (@test) {
            push(@tests,[ @test ]);
            @test=();
         }
      }
      if (@test) {
         push(@tests,[ @test ]);
      }
  
      # Get arg/val lists for each test.
  
      foreach my $test (@tests) {
         my(@tmp)=@$test;
         my(@arg,@val);
  
         # single line test
         @tmp = split(/\s+/,$tmp[0])  if ($#tmp == 0);
  
         my($sep)=-1;
         my($i);
         for ($i=0; $i<=$#tmp; $i++) {
            if ($tmp[$i] eq "~") {
               $sep=$i;
               last;
            }
         }

         if ($sep<0) {
            @val=pop(@tmp);
            @arg=@tmp;
         } else {
            @arg=@tmp[0..($sep-1)];
            @val=@tmp[($sep+1)..$#tmp];
         }
         $test = [ [@arg],[@val] ];
      }
   }

   my($ntest)=$#tests + 1;
   print "1..$ntest\n"  if (! $runtests);

   my(@t);
   if ($runtests > 0) {
      @t = ($runtests..$ntest);
   } elsif ($runtests < 0) {
      @t = (-$runtests);
   } else {
      @t = (1..$ntest);
   }

   foreach my $t (@t) {
      my @arg = @{ $tests[$t-1][0] };
      my @val = @{ $tests[$t-1][1] };

      # Handle undef in args
      my @tmparg = ();
      foreach my $arg (@arg) {
	 if ($arg eq "_undef_") {
	    push(@tmparg,undef);
	 } elsif ($arg eq "_blank_") {
	    push(@tmparg,"");
	 } else {
	    push(@tmparg,$arg);
	 }
      }

      # Handle undef in extra
      my @tmpextra = ();
      foreach my $arg (@extra) {
	 if ($arg eq "_undef_") {
	    push(@tmpextra,undef);
	 } elsif ($arg eq "_blank_") {
	    push(@tmpextra,"");
	 } else {
	    push(@tmpextra,$arg);
	 }
      }

      my @ans = &$funcref(@tmparg,@tmpextra);

      # Handle undef in ans
      if ($#val == $#ans) {
	 for (my($i)=0; $i<=$#val; $i++) {
	    if ($val[$i] eq "_undef_" &&
		! defined($ans[$i])) {
	       $ans[$i] = "_undef_";
	    } elsif ($val[$i] eq "_blank_" &&
		     $ans[$i] eq "") {
	       $ans[$i] = "_blank_";
	    }
	 }
      }

      foreach my $ans (@ans) {
         if (defined $ans) {
            if (ref $ans eq "SCALAR") {
               $ans = $$ans;
            } elsif (ref $ans eq "ARRAY") {
               $ans = join(" ","[",join(", ",@$ans),"]");
            } elsif (ref $ans eq "HASH") {
               $ans = join(" ","{",
                           join(", ",map { "$_ => ".$$ans{$_} }
                                (sort keys %$ans)), "}");
            }
	    $ans =~ s/  +/ /g;
         } else {
	    $ans = "";
	 }
      }

      my $arg = join("\n           ",@arg,@extra);
      my $ans = join("\n           ",@ans);
      my $val = join("\n           ",@val);

      if ($ans ne $val) {
         print "not ok $t\n";
         warn "########################\n";
         warn "Args     = $arg\n";
         warn "Expected = $val\n";
         warn "Got      = $ans\n";
         warn "########################\n";
      } else {
         print "ok $t\n"  if (! $runtests);
      }
   }
}

# The following is similar but it takes input from an input file and
# sends output to an output file.
#
# $files is a reference to a list of tests.  If one of the tests is named
# "foobar", the input is from "foobar.in", output is to "foobar.out", and
# the expected output is in "foobar.exp".
#
# The function stored in $funcref is called as:
#    &$funcref($in,$out,@extra)
# where $in is the name of the input file, $out is the name of the output
# file, and @extra are any additional arguments that are required.
#
# The function should return 0 on success, or an error message.

sub test_File {
   my($funcref,$files,$runtests,@extra)=@_;
   my(@files)=@$files;
  
   $runtests=0  if (! $runtests);

   my($ntest)=$#files + 1;
   print "1..$ntest\n"  if (! $runtests);

   my(@t);
   if ($runtests > 0) {
      @t = ($runtests..$ntest);
   } elsif ($runtests < 0) {
      @t = (-$runtests);
   } else {
      @t = (1..$ntest);
   }

   foreach my $t (@t) {
      my $test = $files[$t-1];
      my $expf = "$test.exp";
      my $outf = "$test.out";

      if (! -f $test  ||  ! -f $expf) {
         print "not ok $t\n";
         warn  "Test: $test: missing input/outpuf information\n";
         next;
      }

      my $err  = &$funcref($test,$outf,@extra);
      if ($err) {
         print "not ok $t\n";
         warn  "Test: $test: $err\n";
         next;
      }

      local *FH;
      open(FH,$expf)  ||  do {
         print "not ok $t\n";
         warn  "Test: $test: $!\n";
         next;
      };
      my @exp = <FH>;
      close(FH);
      my $exp = join("",@exp);
      open(FH,$outf)  ||  do {
         print "not ok $t\n";
         warn  "Test: $test: $!\n";
         next;
      };
      my @out = <FH>;
      close(FH);
      my $out = join("",@out);

      if ($out ne $exp) {
         print "not ok $t\n";
         warn  "Test: $test: output differs from expected value\n";
         next;
      }

      print "ok $t\n"  if (! $runtests);
   }
}

1;
