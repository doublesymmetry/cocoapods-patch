require 'cocoapods'
require 'pathname'
require_relative 'command/patch/apply'

module CocoapodsPatch
  module Hooks
    Pod::HooksManager.register('cocoapods-patch', :post_install) do |context|
      Pod::UI.puts 'Applying patches if necessary'
      patches_dir = Pathname.new(context.sandbox_root) + '..' + 'patches'
      patches = patches_dir.each_child.select { |c| c.to_s.end_with?('.diff') }
      patches.each { |p| apply_patch(p) }
    end
  end
end
