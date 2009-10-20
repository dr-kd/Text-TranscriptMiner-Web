package Text::TranscriptMiner::Web::Controller::Root;

use strict;
use warnings;
use parent 'Catalyst::Controller';

__PACKAGE__->config->{namespace} = '';

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
        my $corpus =  $c->model('Corpus')->new(
            {start_dir => $c->config->{start_dir}});
    $c->stash(corpus => $corpus)
}

1;
