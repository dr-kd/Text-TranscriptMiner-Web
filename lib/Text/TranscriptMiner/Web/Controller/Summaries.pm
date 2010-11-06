package Text::TranscriptMiner::Web::Controller::Summaries;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Text::TranscriptMiner::Corpus::Comparisons;

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    my $model = Text::TranscriptMiner::Corpus::Comparisons->new({start_dir => $c->config->{start_dir}});
    $c->stash(groups => $model->groups);
}

sub end : ActionClass('RenderView') {}

sub page :Path('page') :Args(0) {
    my ($self, $c) = @_;
    
    warn "TODO: FIX\n";
    warn "cmp name attribute should be set generically\n";
    my $cmp = $c->model('Summary')->new(
        {
            start_dir => $c->config->{analysis_dir},
            cmp_name  => ['pre_implementation_first_cut', 'summary']
        });
    $c->stash(comparisons => $cmp,
              template    => 'summaries/one-on.tt',
          );
}

sub page_generic :Path('page_generic') :Args(0) {
    my ($self, $c) = @_;
    my $groups = [];
    foreach my $p (keys %{$c->req->params}) {
        next unless $p =~ /^\d+$/;
        $groups->[$p] = $c->req->params->{$p};
        $groups->[$p] = [$groups->[$p]] if ! ref($groups->[$p]);
    }
    my $model = $c->model('CorpusComparison')
        ->new({start_dir => $c->config->{start_dir}});
    my $report = $model->make_comparison_report_tree($groups);
    $c->stash( groups => $groups,
               report => $report,
               template => 'summaries/page_generic.tt',
           );
}

1;
