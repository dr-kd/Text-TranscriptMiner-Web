package Text::TranscriptMiner::Web::Controller::Docs::Search;

use Moose;
BEGIN {extends 'Catalyst::Controller'};
use JSON::Any;

sub start :Chained("") :PathPart("docs/search") :CaptureArgs(0) {
    my ($self, $c) = @_;
}

sub get_root :Chained("start") :PathPart("") :Args(0) {
    my ($self, $c ) = @_;
    if ($c->req->params->{txt} == 1) {
        $c->stash( template => 'search/results_txt.tt',
                   nowrapper => 1);
    }
    else {
        $c->stash( template => 'search/results.tt' );
    }
}

sub tag_search :Chained("start") :PathPart("tags") :Args(0) {
    my ($self, $c) = @_;
    my $params = $c->req->params->{tag};
    my ($error, $docs);
    if (! ref($params) ) {
        $error = "You must search for at least one tag";
    }
    else {
        $docs = $c->model('Corpus')->new(
            {start_dir => $c->config->{start_dir}})
            ->search_for_subnodes($params);
    }
    $c->stash( template => 'search/tags.tt',
               docs   => $docs,
               error    => $error);
}

sub get_tags : Chained("start") Path('get_tags') : Args(0) {
    my ($self, $c) = @_;
    my $docs = $c->req->params->{doc};
    @$docs = grep { $_ ne '_remove'} @$docs;
    $_ = $c->config->{start_dir} . '/'  . $_ for @$docs;
    $c->stash(nowrapper => 1);
    my $tags =  $c->model('Interview')->get_tags_for_docs(@$docs);
    $c->stash(nowrapper => 1,
              tags => $tags,
              template => 'search/all_tags.tt',
          );
}

sub display_text_for_single_tag : Chained("start") PathPart('') Args(1) {
    my ($self, $c, $tag) = @_;
    my $j = JSON::Any->new;
    my $docs = $j->jsonToObj($c->req->params->{search});
    shift @$docs;
    my $corpus_object = $c->model('Corpus')->new(
        {start_dir => $c->config->{start_dir}});
    my $interviews = $corpus_object->search_for_subnodes($docs);
    my @interviews = $corpus_object->get_interviews($c->config->{start_dir}, @$interviews);
    if ($c->req->params->{txt} == 1) {
        $c->stash( template => 'search/results_txt.tt',
                   nowrapper => 1);
    }
    else {
        $c->stash( template => 'search/results.tt' );
    }
    $c->stash(
              search => $tag,
              interviews => \@interviews,
          );
}

1;
