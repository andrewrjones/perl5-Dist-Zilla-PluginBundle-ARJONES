use strict;
use warnings;

package Pod::Weaver::PluginBundle::ARJONES;

# ABSTRACT: ARJONES's default Pod::Weaver config

=head1 DESCRIPTION

This is the default Pod::Weaver config that ARJONES uses. Roughly equivalent to:

=for :list
* C<@Default>
* C<-Transformer> with L<Pod::Elemental::Transformer::List>

Heavily based on L<Pod::Weaver::PluginBundle::RJBS>.

=cut

use Pod::Weaver::Config::Assembler;
sub _exp { Pod::Weaver::Config::Assembler->expand_package( $_[0] ) }

=for Pod::Coverage mvp_bundle_config
=cut
sub mvp_bundle_config {
    my @plugins;
    push @plugins, (
        [ '@ARJONES/CorePrep', _exp('@CorePrep'), {} ],
        [ '@ARJONES/Name',     _exp('Name'),      {} ],
        [ '@ARJONES/Version',  _exp('Version'),   {} ],

        [ '@ARJONES/Prelude',  _exp('Region'),  { region_name => 'prelude' } ],
        [ '@ARJONES/Synopsis', _exp('Generic'), { header      => 'SYNOPSIS' } ],
        [
            '@ARJONES/Description', _exp('Generic'), { header => 'DESCRIPTION' }
        ],
        [ '@ARJONES/Overview', _exp('Generic'), { header => 'OVERVIEW' } ],

        [ '@ARJONES/Stability', _exp('Generic'), { header => 'STABILITY' } ],
    );

    for my $plugin (
        [ 'Attributes', _exp('Collect'), { command => 'attr' } ],
        [ 'Methods',    _exp('Collect'), { command => 'method' } ],
        [ 'Functions',  _exp('Collect'), { command => 'func' } ],
      )
    {
        $plugin->[2]{header} = uc $plugin->[0];
        push @plugins, $plugin;
    }

    push @plugins,
      (
        [ '@ARJONES/Leftovers', _exp('Leftovers'), {} ],
        [ '@ARJONES/postlude', _exp('Region'),  { region_name => 'postlude' } ],
        [ '@ARJONES/Authors',  _exp('Authors'), {} ],
        [ '@ARJONES/Legal',    _exp('Legal'),   {} ],
        [ '@ARJONES/List', _exp('-Transformer'), { 'transformer' => 'List' } ],
      );

    return @plugins;
}

1;
