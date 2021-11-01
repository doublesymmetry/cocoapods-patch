require 'cocoapods'
require 'pathname'
require_relative 'command/patch/apply'

module CocoapodsPatch
  module Hooks
    Pod::HooksManager.register('cocoapods-patch', :pre_install) do |context|
      Pod::UI.puts 'Preparing patchable pods for clean patching'
      patches_dir = Pathname.new(Dir.pwd) + 'patches'
      if patches_dir.directory?
        patches = patches_dir.each_child.select { |c| c.to_s.end_with?('.diff') }
        patches.each do |p|
          pod_name = File.basename(p, ".diff")
          context.sandbox.clean_pod(pod_name)
        end
      end
    end

    Pod::HooksManager.register('cocoapods-patch', :pre_integrate) do |context|
      Pod::UI.puts 'Applying patches if necessary'
      patches_dir = Pathname.new(Dir.pwd) + 'patches'
      if patches_dir.directory?
        patches = patches_dir.each_child.select { |c| c.to_s.end_with?('.diff') }
        patches.each { |p| apply_patch(p) }
      end
    end
  end
end
