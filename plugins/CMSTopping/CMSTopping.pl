package MT::Plugin::CMSTopping;
use strict;
use warnings;
use base qw(MT::Plugin);
use vars qw($VERSION $SCHEMA_VERSION);

$VERSION = '0.01';
$SCHEMA_VERSION = '0.01';

my $plugin = MT::Plugin::CMSTopping->new({
    id             => 'cms_topping',
    key            => __PACKAGE__,
    name           => 'CMS Topping',
    description    => '<__trans phrase="Add toppings to MT as CMS.">',
    version        => $VERSION,
    author_name    => 'Tomohiro Okuwaki',
    author_link    => 'http://www.tinybeans.net/blog/',
    plugin_link    => 'http://www.tinybeans.net/blog/download/mt-plugin/cms-topping.html',
    l10n_class     => 'CMSTopping::L10N',
    schema_version => $SCHEMA_VERSION,
});
MT->add_plugin($plugin);

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        callbacks => {
            'MT::App::CMS::template_param.edit_template' => 
                '$cms_topping::CMSTopping::CMS::cb_template_param_edit_template',
            'MT::App::CMS::cms_pre_save.template' => 
                '$cms_topping::CMSTopping::CMS::cb_cms_pre_save_template',
#             'MT::App::CMS::cms_post_save.entry' => 
#                 '$cms_topping::CMSTopping::CMS::cb_cms_post_save_entry',
#             'build_file_filter' => '$cms_topping::CMSTopping::CMS::cb_build_file_filter',
#             'build_file_filter' => '$cms_topping::CMSTopping::Plugin::cb_build_file_filter',
#             'build_page' => '$cms_topping::CMSTopping::Plugin::cb_build_page',
#             'build_file' => '$cms_topping::CMSTopping::Plugin::cb_build_file',
        },
        object_types => {
            'template' => {
                'suffix' => 'string(255)',
            },
        },
        tags => {
            function => {
                'IndexTemplatePathname' => '$cms_topping::CMSTopping::Tag::hndlr_index_template_pathname',

                'CategoryUtilLabel' => '$cms_topping::CMSTopping::Tag::ftag_category_util_label',
                'CategoryUtilBasename' => '$cms_topping::CMSTopping::Tag::ftag_category_util_basename',
            },
        },
    });
}

sub get_setting {
    my $plugin = shift;
    my ($key, $blog_id) = @_;
    my $scope;
    if ($blog_id > 0) {
        $scope = 'blog:'. $blog_id;
    } else {
        $scope = 'system';
    }
    my $value = $plugin->get_config_value($key, $scope);
    return $value;
}

1;