package Text::TranscriptMiner::Web::View::HTML;

use strict;
use warnings;
use parent 'Catalyst::View::TT';
__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    WRAPPER            => 'page.tt'
);

=head1 NAME

Text::TranscriptMiner::Web::View::HTML - Catalyst View

=head1 DESCRIPTION

Catalyst View.

=head1 AUTHOR

Kieren Diment

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
