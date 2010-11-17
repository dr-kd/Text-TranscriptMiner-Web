package Text::TranscriptMiner::Web::Controller::Summaries;

use strict;
use warnings;
use parent 'Catalyst::Controller';
use Text::TranscriptMiner::Corpus::Comparisons;

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    my $model = Text::TranscriptMiner::Corpus::Comparisons->new({start_dir => $c->config->{start_dir}});
    my $tags = $model->get_all_tags_for_interviews();
    my $named_tags = $model->get_code_structure(undef, $tags);
    $c->stash(groups => $model->groups,
              tags   => $named_tags,
          );
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
    my $codes = $c->req->params->{code};
    $codes = [$codes] if ! ref($codes);
    my %included_codes;
    my $model = $c->model('CorpusComparison')
        ->new({start_dir => $c->config->{start_dir}});

    my $groups = [];
    foreach my $p (keys %{$c->req->params}) {
        if ( $p =~ /^\d+$/ ) {
            $groups->[$p] = $c->req->params->{$p};
            $groups->[$p] = [$groups->[$p]] if ! ref($groups->[$p]);
        }
    }
    if (! $c->req->params->{all_codes}) {
        foreach my $c (@$codes) {
            $included_codes{$c} = '';
        }
    }
    else {
        %included_codes = %{$model->get_all_tags_for_interviews};
    }

    my $report = $model->make_comparison_report_tree($groups);
    $c->stash( groups => $groups,
               report => $report,
               cmp_model => $model,
               included_codes => \%included_codes,
               template => 'summaries/page_generic.tt',
           );
}

1;
