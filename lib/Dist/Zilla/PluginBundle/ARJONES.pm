use strict;
use warnings;

package Dist::Zilla::PluginBundle::ARJONES;

# ABSTRACT: L<Dist::Zilla> plugins for ARJONES

use Moose;
use Moose::Autobox;
use Dist::Zilla 2.100922;
with 'Dist::Zilla::Role::PluginBundle::Easy';

=for stopwords Prereqs CPAN
=head1 DESCRIPTION

This is the plugin bundle that ARJONES uses. It is equivalent to:

  [@Basic]

  [PodCoverageTests]
  [PodSyntaxTests]
  [Test::Perl::Critic]
  [NoTabsTests]
  [Test::Portability]
  [Test::Kwalitee]
  [Test::Pod::No404s]
  [NoSmartCommentsTests]
  [Test::Compile]
  [ReportVersions::Tiny]
  [Test::ChangesHasContent]

  [AutoPrereqs]

  [PodWeaver]
  [AutoVersion]
  [PkgVersion]
  [NextRelease]
  [MetaJSON]

  [Clean]

  [ContributorsFromGit]

  [GithubMeta]
  issues = 1

  [@Git]

It will take the following arguments:
  ; extra stopwords for Test::PodSpelling
  stopwords

It also adds the following as Prereqs, so I can quickly get my C<dzil> environment set up:

=for :list
* L<Dist::Zilla::App::Command::cover>
* L<Dist::Zilla::App::Command::perltidy>

Heavily based on L<Dist::Zilla::PluginBundle::RJBS>.

=cut

use Dist::Zilla::PluginBundle::Basic;
use Dist::Zilla::PluginBundle::Git;

# Alphabetical
use Dist::Zilla::Plugin::Test::ChangesHasContent;
use Dist::Zilla::Plugin::Clean;
use Dist::Zilla::Plugin::ContributorsFromGit;
use Dist::Zilla::Plugin::NoTabsTests;
use Dist::Zilla::Plugin::ReportVersions::Tiny;
use Dist::Zilla::Plugin::Test::Compile;
use Dist::Zilla::Plugin::Test::Kwalitee;
use Dist::Zilla::Plugin::Test::Pod::No404s;
use Dist::Zilla::Plugin::Test::Portability;
use Dist::Zilla::Plugin::NoSmartCommentsTests;

=for Pod::Coverage mvp_multivalue_args
=cut

sub mvp_multivalue_args { return qw( stopwords ) }

has stopwords => (
    is      => 'ro',
    isa     => 'ArrayRef[Str]',
    traits  => ['Array'],
    default => sub { [] },
    handles => {
        push_stopwords => 'push',
        uniq_stopwords => 'uniq',
    }
);

=for Pod::Coverage configure
=cut

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
          NoTabsTests
          Test::Portability
          Test::Kwalitee
          Test::Compile
          Test::Pod::No404s
          NoSmartCommentsTests
          Clean
          ContributorsFromGit
          Test::ChangesHasContent
          ReportVersions::Tiny
          )
    );

    # take stopwords from dist.ini, if present
    if ( $_[0]->payload->{stopwords} ) {
        for ( @{ $_[0]->payload->{stopwords} } ) {
            $self->push_stopwords($_);
        }
    }

    $self->add_plugins( [ PodWeaver => { config_plugin => '@ARJONES' } ] );

    $self->add_plugins( [ GithubMeta => { issues => 1, } ], );

    # Git
    $self->add_plugins(
        qw(
          Git::Commit
          Git::Tag
          Git::Push
          )
    );
    $self->add_plugins( [ 'Git::Check' => { allow_dirty => '', } ], );
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
