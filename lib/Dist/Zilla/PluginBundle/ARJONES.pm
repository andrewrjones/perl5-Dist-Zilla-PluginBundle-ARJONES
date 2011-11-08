use strict;
use warnings;

package Dist::Zilla::PluginBundle::ARJONES;

# ABSTRACT: L<Dist::Zilla> plugins for ARJONES

use Moose;
use Moose::Autobox;
use Dist::Zilla 2.100922;
with 'Dist::Zilla::Role::PluginBundle::Easy';

=head1 DESCRIPTION

This is the plugin bundle that ARJONES uses. It is equivalent to:

  [@Basic]

  [@Git]

  [@Basic]

  [PodCoverageTests]
  [PodSyntaxTests]
  [Test::Perl::Critic]

  [AutoPrereqs]

  [PodWeaver]
  [AutoVersion]
  [PkgVersion]
  [NextRelease]
  [MetaJSON]

  [GithubMeta]
  issues = 1

Heavily based on L<Dist::Zilla::PluginBundle::RJBS>.

=cut

use Dist::Zilla::PluginBundle::Basic;
use Dist::Zilla::PluginBundle::Git;

sub configure {
    my ($self) = @_;

    # @Basic has:
    #    GatherDir
    #    PruneCruft
    #    ManifestSkip
    #    MetaYAML
    #    License
    #    Readme
    #    ExtraTests
    #    ExecDir
    #    ShareDir
    #    MakeMaker
    #    Manifest
    #    TestRelease
    #    ConfirmRelease
    #    UploadToCPAN
    $self->add_bundle('@Basic');

    $self->add_plugins(
        qw(
          AutoPrereqs
          AutoVersion
          PkgVersion
          MetaJSON
          NextRelease
          PodCoverageTests
          PodSyntaxTests
          Test::Perl::Critic
          )
    );

    $self->add_plugins( [ PodWeaver => { config_plugin => '@ARJONES' } ] );

    $self->add_plugins( [ GithubMeta => { issues => 1, } ], );

    # @Git has:
    #    Git::Check
    #    Git::Commit
    #    Git::Tag
    #    Git::Push
    $self->add_bundle('@Git');
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
