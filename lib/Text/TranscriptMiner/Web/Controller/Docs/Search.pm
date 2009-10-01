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

 1;


1;
