package CMSTopping::Tag;
use strict;
use MT::Category;

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

# 
# <$mt:CategoryUtilLabel id="n"$>
# 
sub ftag_category_util_label {
    my ($ctx, $args) = @_;
    my $id = $args->{id};
    my $cat = MT::Category->load($id);
    return $cat->label or '';
}

# 
# <$mt:CategoryUtilBasename id="n"$>
# 
sub ftag_category_util_basename {
    my ($ctx, $args) = @_;
    my $id = $args->{id};
    my $cat = MT::Category->load($id);
    return $cat->basename or '';
}


1;