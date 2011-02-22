package Text::TranscriptMiner::Web::Controller::Annotate;
use warnings;
use strict;
use parent 'Catalyst::Controller';
use Text::TranscriptMiner::Corpus::Comparisons;
use Path::Class;

sub index :Path :Args(0) {
    my ($self, $c) = @_;
    my $model = Text::TranscriptMiner::Corpus::Comparisons->new({start_dir => $c->config->{start_dir}});
    my $code_tree = $model->get_code_structure();
    $c->stash( code_tree => $code_tree,
               groups => $model->groups,
           );
}

sub annotate :Path :Args(1) {
    my ($self, $c, $code) = @_;
    my $groups = [];
    foreach my $p (keys %{$c->req->params}) {
        next unless $p =~ /^\d+$/;
        $groups->[$p] = $c->req->params->{$p};
        $groups->[$p] = [$groups->[$p]] if ! ref($groups->[$p]);
    }
    my $paths = [ ];
    get_paths($groups, $paths);
    my $model = Text::TranscriptMiner::Corpus::Comparisons->
        new({start_dir => $c->config->{start_dir}});
    my @results;
    foreach my $p (@$paths) {
        my $item = {};
        $item->{path} = $p;
        $item->{code} = $code;
        $item->{result} = $model->get_results_for_node([$code, @$p]);
        push @results, { path => $p,
                         code => $code,
                         result => $model->get_results_for_node([$code, @$p]),
                     };
    }
    my @final_results;
    foreach my $r (@results) {
        next unless @{$r->{result}};
        my $this_code = $r->{code};
        my $this_path = $r->{path};
        foreach my $res (@{$r->{result}}) {
            $DB::single=1;
            push @final_results,
                { code => $this_code,
                  path => $res->{path},
                  txt  => join ("\n------------\n", @{$res->{txt}}),
                  notes => { note => $res->{notes}->{notes},
                            status => $res->{notes}->{status},
                         },
              };
        }
    }
    $c->stash( groups  => $groups,
               paths   => $paths,
               code    => $code,
               results => \@final_results,
           );
}


sub do_annotate :Path('do_annotate') :Args(0) {
    my ($self, $c) = @_;
    my $file = $c->req->params->{file};
    my $notes = $c->req->params->{notes};
    my $code = $c->req->params->{code};
    my $model = Text::TranscriptMiner::Corpus::Comparisons->
        new({start_dir => $c->config->{start_dir}});
    my $response = $model->write_notes($file, $notes, $code);
    $c->res->body('response');
}

sub edit :Path('edit') :Args(0) {
    my ($self, $c) = @_;
    my $file = $c->req->params->{file};
    my $path = Path::Class::Dir->new($c->config->{start_dir})->subdir($file);
    my $cmd = $c->config->{editor_cmd} . ' ' . $path;
    $DB::single = 1;
    system $cmd;
    $c->res->body('opened');
}
    
sub get_paths {
    my ($groups, $paths,  @path_elements) = @_;
    my $level = @path_elements;
    my ($current, @remaining) = @$groups;
    for my $d (@$current){
        if (@remaining){
            get_paths(\@remaining, $paths, @path_elements, $d);        
        }
        else {
            push @$paths, [ @path_elements, $d];
        }
    }
}


1;
