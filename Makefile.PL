use ExtUtils::MakeMaker;
WriteMakefile(
   NAME => "Number::Ops",
   VERSION_FROM => "Ops.pm",
   ($] >= 5.005
       ? (ABSTRACT   => 'Simple operations on numbers.',
          AUTHOR     => 'Sullivan Beck (sbeck@cpan.org)')
       : ()),
   'dist' => {COMPRESS=>'gzip',SUFFIX=>'gz'},
   PREREQ_PM => {
                 Carp                    => 0,
                },
);
