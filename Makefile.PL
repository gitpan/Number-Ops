
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME             => 'Number::Ops',
	VERSION	         => '1.03',
	($] >= 5.005
	? (ABSTRACT=>'Simple operations on numbers.',
	   AUTHOR  =>'Sullivan Beck (sbeck@cpan.org)')
	: ()),
	'dist' => {COMPRESS=>'gzip',SUFFIX=>'gz'},
        PL_FILES  => {},
	PREREQ_PM => {
		'Carp'                => '0',
		'Test::More'          => '0',
		'Test::Pod'           => '0',
		'Test::Pod::Coverage' => '0',
	},
);
