package Text::TranscriptMiner::Web::Controller::Git;

use Moose;
BEGIN { extends 'Catalyst::Controller::CGIBin'};

__PACKAGE__->config->{namespace} = 'history';
1;

sub index {
    my ($self, $c) = @_;
    $c->forward($self->cgi_action('gitweb.cgi'));
}

1;
