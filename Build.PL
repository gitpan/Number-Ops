
use Module::Build;

my $build = Module::Build->new(
	license            => 'perl',
	dist_version       => '1.02',
	dist_author        => 'Sullivan Beck <sbeck@cpan.org>',
	module_name        => 'Number::Ops',
	dist_abstract      => 'Simple operations on numbers.',
	requires           => {
		'perl'                => '5.6.0',
		'Carp'                => '0',
	},
	build_requires     => {
		'Test::More'          => '0',
	},
	build_recommends   => {
		'Test::Pod'           => '0',
		'Test::Pod::Coverage' => '0',
	},
	sign               => 1,
);

$build->create_build_script;
