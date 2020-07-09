require 'cocoapods'
require 'pathname'
require_relative 'command/patch/apply'

class Pod::Installer
  # The last step cocoapods runs is perform_post_install_actions.
  # We override it, run the original implementation and add our patches action
  # Reference: https://github.com/CocoaPods/CocoaPods/blob/760828a07f8fcfbff03bce13f56a1789b6f5a95d/lib/cocoapods/installer.rb#L169
  alias_method :perform_post_install_actions_old, :perform_post_install_actions

  def perform_post_install_actions
    # run the original implementation
    perform_post_install_actions_old
    # run custom apply_patches
    apply_patches
  end

  def apply_patches
    Pod::UI.puts 'Applying patches if necessary'
    patches_dir = Pathname.new(Dir.pwd) + 'patches'
    patches = patches_dir.each_child.select { |c| c.to_s.end_with?('.diff') }
    patches.each { |p| apply_patch(p) }
  end
end
