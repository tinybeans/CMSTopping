package CMSTopping::CMS;
use strict;
use MT::Template;

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

# Set the custom index template's identifier.
sub cb_template_param_edit_template {
	my ($cb, $app, $param, $tmpl) = @_;

	my $template_type = $tmpl->{context}{__stash}{vars}{type};
	return if ($template_type ne 'index');

#     my $p = MT->component('cms_topping');

## test
#     doLog(Dumper($app));
    $app->translate('Help');
    $app->translate('Template Tag Docs');
## test

    ### Init
    my $suffix = $param->{suffix};
    my $outfile = $param->{outfile};
    my $selected_value = '';


    ### Add a custom_identifier field.
    my $target = $tmpl->getElementById('identifier');
    my $node = $tmpl->createElement('app:setting',
        {
            id => 'custom_identifier',
            label => '<__trans_section component="cms_topping"><__trans phrase="Identifier"></__trans_section>',
            label_class => 'top_label',
        });
    my $innerHTML = <<'__MT__';
<input type="text" name="custom_identifier" id="custom_identifier" value="<mt:var name="custom_identifier" escape="html">" maxlength="255" class="full-width" mt:watch-change="1" />
<script type="text/javascript">
jQuery(function($){
    $("#identifier").change(function(){
        if ($(this).find(":selected").val() == "") {
            $("#custom_identifier-field").removeClass("hidden");
        } else {
            $("#custom_identifier-field").addClass("hidden");
            $("#custom_identifier").val("");
        }
    }).trigger("change");
});
</script>
__MT__
    $node->innerHTML($innerHTML);
    $node->setAttribute('class','hidden');
    $tmpl->insertAfter($node, $target);


    ### Add a suffix field.
    my $target = $tmpl->getElementById('outfile');
    my $node = $tmpl->createElement('app:setting',
        {
            id => 'suffix',
            label => '<__trans_section component="cms_topping"><__trans phrase="Suffix of outfile"></__trans_section>',
            label_class => 'top_label',
        });

    if ($suffix eq '') {
        $target->appendChild($tmpl->createTextNode('<a id="add_suffix" href="javascript:void(0);"><__trans_section component="cms_topping"><__trans phrase="suffix"></__trans_section></a>'));
    }
    my $innerHTML = <<'__MT__';
<input type="text" name="suffix" id="suffix" value="<mt:var name="suffix" escape="html">" maxlength="255" class="full-width" mt:watch-change="1" />
<script type="text/javascript">
/*
 * jqueryMultiCheckbox.js
 *
 * Copyright (c) 2010 Tomohiro Okuwaki (http://www.tinybeans.net/blog/)
 * Licensed under MIT Lisence:
 * http://www.opensource.org/licenses/mit-license.php
 * http://sourceforge.jp/projects/opensource/wiki/licenses%2FMIT_license
 *
 * Since:   2010-06-22
 * Update:  2010-10-26
 * version: 0.10
 * Comment: ユーザーが追加したラベルが保存されていれば、そいつのチェックボックスを生成
 *
 * jQuery 1.3 later (maybe...)
 * 
 */
(function($){
    $.fn.multicheckbox = function(options){
        var op = $.extend({}, $.fn.multicheckbox.defaults, options);

        // 初期化
        var $self = this,
            rcomma = new RegExp(" *, *","g");
            self_val = $self.val() ? $self.val().replace(rcomma,",") : "";

        $self[op.show]().val(self_val);

        var checked = self_val ? self_val.split(",") : [],
            checked_count = checked.length,
            container_class = op.tags ? "mcb-container mcb-tags" : "mcb-container";
            $container = $("<span></span>").addClass(container_class);
            

        // チェックボックスをクリックしたとき
        function checkboxClick(){
            var value = $self.val() ? $self.val().replace(rcomma,",") + ",": "",
                $cb = $(this);
                
            if ($cb.is(":checked")) {
                $cb.closest("label").addClass("mcb-label-checked");
                $self.val(value + $cb.val());
            } else {
                $cb.closest("label").removeClass("mcb-label-checked");
                var reg = new RegExp("," + $cb.val() + ",","g");
                value = "," + value;
                $self.val(value.replace(reg,",").replace(/^,|,$/g,""));
            }
        }
        // チェックボックスとラベルを生成
        function makeCheckbox(val,label,count,must){
            var $cb = $("<input/>").attr({"type":"checkbox","value":val}).addClass("mcb").click(checkboxClick);
            var $label = $("<label></label>").addClass("mcb-label");
            if (count > 0) {
                checked = $.grep(checked, function(elm,idx){
                    if (val == elm) {
                        $cb.attr("checked","checked");
                        $label.addClass("mcb-label-checked");
                        return false;
                    }
                    return true;
                });
            }
            if (must) {
                $cb.attr("checked","checked");
                $label.addClass("mcb-label-checked");
            }
            $label.text(label).prepend($cb);
            $self[op.insert]($container.append($label));
        }
        // ユーザーが追加したラベルを生成
        function makeAddCheckbox(arry){
            if (arry.length == 0) return;
            for (var i = -1,n = arry.length; ++i < n;) {
                makeCheckbox(arry[i],arry[i],0,true);
            }
            
        }
        // ユーザーが項目を追加できるようにする
        function addCheckbox(){
            if (!op.add) return;
            var $cb = $("<input/>")
                    .attr({"type":"checkbox","value":"","checked":"checked"})
                    .addClass("mcb")
                    .click(checkboxClick);
            var $input = $("<input/>")
                    .attr({"type":"text","value":"+"})
                    .addClass("mcb-add-input")
                    .focus(function(){
                        if ($(this).val() === "+") $(this).val("");
                    })
                    .blur(function(){
                        if ($(this).val() === "") $(this).val("+");
                    })
                    .keydown(function(e){
                        var keycode = e.which || e.keyCode; 
                        if (keycode == 13) {
                            var value = label = $(this).val();
                            if (!value) return;
                            var obj = value.match(/([^:]+)(:)([^:]+)/);
                            if (obj) {
                                value = obj[1];
                                label = obj[3];
                            }
                            $(this).hide().before($cb.val(value),label);
                            $cb.attr({"checked":"checked"}).click().attr({"checked":"checked"});
                            addCheckbox();
                        }
                    });
            var $label = $("<label></label>")
                    .addClass("mcb-label mcb-add-label")
                    .append($input);
            $($container).append($label);
        }
        
        // 実行する
        if (typeof(op.label) == "object") {
            for (var key in op.label) {
                makeCheckbox(key,op.label[key],checked_count,false);
            }
            makeAddCheckbox(checked);
            addCheckbox();
        } else {
            var checks = (op.label == "") ? $self.attr("title") : op.label,
                checks = checks.split(",");
            for (var i = -1, n = checks.length; ++i < n;) {
                makeCheckbox(checks[i],checks[i],checked_count,false);
            }
            makeAddCheckbox(checked);
            addCheckbox();
        }
        return $self;
    };    
    $.fn.multicheckbox.defaults = {
        show: "hide", // "hide" or "show"
        label: "",
        insert: "before", // "before" or "after"
        add: false,
        tags: false
    };
    
    $("#suffix").multicheckbox({"show":"show","label":
        {
            "enable":"接尾辞を付ける"
        }
    });
    
    $("#add_suffix").click(function(){
        $(this).hide();
        $("#suffix-field").removeClass("hidden");
    });

})(jQuery);
</script>
__MT__
    $node->innerHTML($innerHTML);
    $node->setAttribute('class','hidden') if ($suffix eq '');
    $tmpl->insertAfter($node, $target);
    # Add a suffix field.

    ### Set the value of custom identifier
    my $type = $param->{type};
    my $identifier = $param->{identifier};
    if (
        $type eq 'index' and (
            $identifier ne 'main_index' &&
            $identifier ne 'archive_index' &&
            $identifier ne 'javascript' &&
            $identifier ne 'feed_recent' &&
            $identifier ne 'styles' &&
            $identifier ne 'rsd' &&
            $identifier ne ''
        )
    ) {
        $param->{custom_identifier} = $identifier;
    }
    # Set the value of custom identifier

    ### Set the value of sufix
#     if ($suffix ne '') {
#         $param->{suffix} = $suffix;
#     } else {
#     
#     }
    # Set the value of suffix

    ### Remove suffix from outfile.
#     if ($suffix ne '') {
#         $outfile =~ s/(-[epc][0-9]+)(\.[a-z]+)$/$2/g;
#         $param->{outfile} = $outfile;
#     }
    # Remove suffix from outfile.

}

sub cb_cms_pre_save_template {
    my ($cb, $app, $obj, $orig_obj) = @_;
    
doLog('$obj->type : '.Dumper($obj->type));
    if ($obj->type eq 'index') {
        my $q = $app->param;
    
        my $identifier = $q->param('identifier');
        my $custom_identifier = $q->param('custom_identifier');
        my $outfile = $q->param('outfile');
        my $suffix = $q->param('suffix');
    
doLog('$identifier : '.Dumper($identifier));
doLog('$custom_identifier : '.Dumper($custom_identifier));
doLog('$outfile : '.Dumper($outfile));
doLog('$suffix : '.Dumper($suffix));
    
        ### Save custom identifier
        if ($custom_identifier ne '' and $identifier eq '') {
            $obj->identifier($custom_identifier);
        }
        # Save custom identifier
    
        # Suffix and save outfile $custom_identifierの保存まで終了ここから
#         if ($suffix ne '') {
#             my $_suffix = '-e398';
#             $outfile =~ s/(\.[a-z]+)$/${_suffix}$1/g;
#             $obj->outfile($outfile);
# doLog('$outfile : '.Dumper($outfile));
#         }
    } # end - if ($obj->type ne 'index')
    1;
#     doLog($obj->outfile);
}

# sub cb_cms_post_save_entry {
#     my ($cb, $app, $obj, $orig_obj) = @_;
#     if($obj->status ne '2'){
#         return;
#     }
# 
#     my %terms;
#     $terms{type} = 'index';
#     $terms{suffix} = {like => '%entry%'};
#     my @templates = MT::Template->load(\%terms) or return;
#     
#     foreach my $template(@templates){
# # doLog(Dumper($template->outfile));
#         my $suffix;
#         my $outfile = $template->outfile;
#         $outfile =~ /(-v)([0-9]+)(\.[a-z]+)$/g;
# # doLog(Dumper($2));
#         $suffix = $2 + 1;
#         $outfile =~ s/(-v)([0-9]+)(\.[a-z]+)$/-e$suffix$3/g;
#         $template->outfile($outfile);
# # doLog(Dumper($template->outfile));
#         $template->save or die '<__trans_section component="cms_topping">Failed to save template.</__trans_section>';
#     }
#     1;
# }


# sub tmpl_source_header {
# 	my ($cb, $app, $tmpl_ref) = @_;
#     my $p = MT->component('cms_topping');
# 
#     my $blog_id = 0;
#     $blog_id = $app->param('blog_id') || 0;
#     my $static_path = $app->static_path;
# 	my $static_plugin_path = $static_path . 'plugins/CMSTopping/'; 
# 	
# 	# Get the value of option
# 	my $op_no_usercss     = $p->get_setting('no_usercss', 0)     || 0;
# 	my $op_no_CMSTopping = $p->get_setting('no_CMSTopping', 0) || 0;
# 	my $op_no_userjs      = $p->get_setting('no_userjs', 0)      || 0;
# 	my $op_no_slidemenu   = $p->get_setting('no_slidemenu', 0)   || 0;
# 	my $op_sys_jqplugin   = $p->get_setting('sys_jqplugin', 0)   || '';
# 	
# 	my $op_active         = $p->get_setting('active', $blog_id)      || 0;
# 	my $op_usercss        = $p->get_setting('usercss', $blog_id)     || 0;
# 	my $op_CMSTopping    = $p->get_setting('CMSTopping', $blog_id) || 0;
# 	my $op_userjs         = $p->get_setting('userjs', $blog_id)      || 0;
# 	my $op_slidemenu      = $p->get_setting('slidemenu', $blog_id)   || 0;
# 	my $op_jqplugin       = $p->get_setting('jqplugin', $blog_id)    || '';
# 	
# 
# 	$$tmpl_ref = $add_html_head . $$tmpl_ref;
# }

1;