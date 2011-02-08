package CMSTopping::Plugin;
use strict;
use MT::Template;

use MT::Log;
use Data::Dumper;

sub doLog {
    my ($msg) = @_;     return unless defined($msg);
    my $log = MT::Log->new;
    $log->message($msg) ;
    $log->save or die $log->errstr;
}

# sub cb_build_file_filter {
# 	my ($eh, %args) = @_;
# #     my $p = MT->component('cms_topping');
# 
# 	my $content_ref = $args{content};
# 	my $template = $args{template};
#     doLog('filter : '.Dumper($template->outfile));
# 
# 	my $suffix = /^(<suffix>)([^<]+)(<\/suffix>\n)$/g or '';
# 	if($suffix ne ''){
#     	$$content_ref =~ s/^(<suffix>)([^<]+)(<\/suffix>)$/''/g;
# 	} else {
# 	   return false;
# 	}
#     doLog('suffix!');
#     return true;
# }

# sub cb_build_page {
# 	my ($eh, %args) = @_;
# #     my $p = MT->component('cms_topping');
# 
# 	my $content_ref = $args{content};
# 	my $template = $args{template};
#     doLog('page : '.Dumper($template->outfile));
#     $template->outfile('search_okuwaki.js');
#     doLog('page : '.Dumper($template->outfile));
# 
# 	my $suffix = /^(<suffix>)([^<]+)(<\/suffix>\n)$/g or '';
# 	if($suffix ne ''){
#     	$$content_ref =~ s/^(<suffix>)([^<]+)(<\/suffix>)$/''/g;
#         doLog('suffix!');
# 	} else {
# 	   return;
# 	}
# }

sub cb_build_file {
	my ($eh, %args) = @_;
    my $type = $args{'ArchiveType'};
    my $id = $args{template}->id;
    doLog('cb_build_file : type : '.$type);
    doLog('cb_build_file : ID : '.$id);
}

1;