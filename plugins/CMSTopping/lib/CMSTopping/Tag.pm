package CMSTopping::Tag;
use strict;

###
##
#
use MT::Log;
use Data::Dumper;
sub doLog {
    my ($msg) = @_;     return unless defined($msg);
    my $log = MT::Log->new;
    $log->message($msg) ;
    $log->save or die $log->errstr;
}
#
##
###

sub hndlr_index_template_pathname {
    my ($ctx, $args) = @_;
    my $template = $ctx->stash('template');
    return $template->outfile || '';
}

1;