package Text::TranscriptMiner::Web::Controller::Docs;

use Moose;
BEGIN {extends 'Catalyst::Controller'};
use Path::Class::File;

sub file : Path Args {
    my ($self, $c) = @_;
    my $file = Path::Class::Dir->new($c->config->{start_dir})->file(@{$c->req->args});
    if (! -e $file) {
        $c->res->status(404);
        $c->res->body('file not found');
        return 1;
    }
    else {
        my $doc = $c->model('Interview')->new({file => $file});
        my $codes = $c->model('Interview')->get_tags_for_docs($file);
        $c->stash( template => 'doc.tt',
                   doc => $doc,
                   codes => $codes,
               );
    }
}

1;
