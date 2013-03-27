
use strict;
use warnings;
use 5.010;

# Note/TODO: doesn't find picklists. Can't find them without the XDT file!

# ABSTRACT: GRAB DATA CATEGORIES FROM A MULTITERM XML FILE
package GetMTtermTypes;
# VERSION

use parent qw(Exporter);
our @EXPORT_OK = qw(extract_definition);

use XML::Twig;
# binmode(STDOUT, ':encoding(UTF-16)');
__PACKAGE__->extract_definition(@ARGV) unless caller;

sub extract_definition {
	my ($application, $in_file) = @_;
	# $| = 1;
	my %entry_types;
	my %index_types;
	my %term_types;
	my %other_types;
	my %opts = 	(
		empty_tags				=> 'html',
		pretty_print			=> 'indented',
		do_not_chain_handlers	=> 1, #can be important when things get complicated
		keep_spaces				=> 0,
		TwigHandlers			=> {
			'conceptGrp/descripGrp/descrip'	=> sub {
				$entry_types{$_->att('type')}++;
			},
			'languageGrp/descripGrp/descrip'
			=> sub {
				$index_types{$_->att('type')}++;
			},
			'termGrp/descripGrp/descrip'
			=> sub {
				$term_types{$_->att('type')}++;
			},
			descrip	=> sub {
				$other_types{$_->att('type')}++;
			},
		},
		no_prolog				=> 1,
	);
	my $twig = XML::Twig->new(%opts);
	$twig->parsefile($in_file);
	say '__Concept-level types:';
	print join "\n", sort keys %entry_types;
	say "\n";
	say '__Index types:';
	print join "\n", sort keys %index_types;
	say "\n";
	say '__Term types:';
	print join "\n", sort keys %term_types;
	say "\n";
	say '__Other types:';
	print join "\n", sort keys %other_types;
}


1;

	