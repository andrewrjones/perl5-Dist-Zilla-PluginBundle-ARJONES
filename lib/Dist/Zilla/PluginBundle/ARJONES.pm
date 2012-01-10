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
  [EOLTests]
  [Test::Portability]
  [Test::Kwalitee]
  [Test::Pod::No404s]
  [Test::PodSpelling]

  [AutoPrereqs]

  [PodWeaver]
  [AutoVersion]
  [PkgVersion]
  [NextRelease]
  [MetaJSON]

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
use Dist::Zilla::Plugin::EOLTests;
use Dist::Zilla::Plugin::NoTabsTests;
use Dist::Zilla::Plugin::Test::Kwalitee;
use Dist::Zilla::Plugin::Test::Pod::No404s;
use Dist::Zilla::Plugin::Test::PodSpelling;
use Dist::Zilla::Plugin::Test::Portability;

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
          EOLTests
          Test::Portability
          Test::Kwalitee
          Test::Pod::No404s
          )
    );

    # take stopwords from dist.ini, if present
    if ( $_[0]->payload->{stopwords} ) {
        for ( @{ $_[0]->payload->{stopwords} } ) {
            $self->push_stopwords($_);
        }
    }

    # our stopwords
    $self->push_stopwords(qw/ARJONES ARJONES's TODO/);
    $self->add_plugins(
        [ 'Test::PodSpelling' => { stopwords => [ $self->uniq_stopwords ] } ] );

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
