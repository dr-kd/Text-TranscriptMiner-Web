package Text::TranscriptMiner::Web::Controller::Docs::Search;

use Moose;
BEGIN {extends 'Catalyst::Controller'};


sub start :Chained("") :PathPart("docs/search") :CaptureArgs(0) {
    my ($self, $c) = @_;
}

sub get_root :Chained("start") :PathPart("") :Args(0) {
    my ($self, $c ) = @_;
    $c->stash( template => 'search/results.tt' );
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


1;
