package Text::TranscriptMiner::Web::Controller::Summaries;

use strict;
use warnings;
use parent 'Catalyst::Controller';

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    $c->forward('get_menu');
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->response->body( 'Page not found' );
    $c->response->status(404);
}

sub end : ActionClass('RenderView') {}

sub get_menu :Private {
    my ($self, $c) = @_;
    my $cmp = $c->model('Summary')->new(
        {
            start_dir => $c->config->{analysis_dir},
            cmp_name  => ['pre_implementation_first_cut', 'summary']
        });
    $c->stash(comparisons => $cmp);
}

1;
