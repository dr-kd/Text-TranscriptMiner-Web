package Text::TranscriptMiner::Web::Controller::Snippet;

use Moose;
BEGIN {extends 'Catalyst::Controller'};
use Path::Class::File;

sub file : Path Args {
    my ($self, $c) = @_;
    my $find_file = $c->req->args;
    my $code = pop @{$c->req->args};
    my $file = Path::Class::Dir->new($c->config->{start_dir})->file(@{$find_file});

    if (! -e $file) {
        $c->res->status(404);
        $c->res->body('file not found');
        return 1;
    }
    else {
        my $doc = $c->model('Interview')->new({file => $file});
        my $snippet = $doc->get_this_tag($code);
        $c->res->body($self->format_snippet($snippet));
    }
}

sub format_snippet {
    my ($self, $txt) = @_;
    my $result = "<pre style=\"white-space: pre-wrap; white-space: -moz-pre-wrap; white-space: -pre-wrap; white-space: -o-pre-wrap; word-wrap: break-word;\">";
    foreach my $s (@$txt) {
        $s =~ s/\{.*?}//msg;
        $result .= join "\n", $s;
        }
    $result .="</pre>";
    return $result;
}

1;
