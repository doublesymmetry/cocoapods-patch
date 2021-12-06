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
  end
end

class Pod::Installer
  # Because our patches may also delete files, we need to apply them before the pod project is generated
  # The project is generated in the `integrate` method, so we override it
  # We first run our patch action and then the original implementation of the method
  # Reference: https://github.com/CocoaPods/CocoaPods/blob/760828a07f8fcfbff03bce13f56a1789b6f5a95d/lib/cocoapods/installer.rb#L178
  alias_method :integrate_old, :integrate

  def integrate
    # apply our patches
    apply_patches
    # run the original implementation
    integrate_old
  end

  def apply_patches
    Pod::UI.puts 'Applying patches if necessary'
      patches_dir = Pathname.new(Dir.pwd) + 'patches'
      if patches_dir.directory?
        patches = patches_dir.each_child.select { |c| c.to_s.end_with?('.diff') }
        patches.each do |p|
          pod_name = File.basename(p, ".diff")
          # check if patch is in new format otherwise warn user
          unless p.to_s.include?('+')
            Pod::UI.puts "WARNING: #{pod_name}.diff has an old naming format. Please run pod patch migration first before pod install. See the README for more information.".yellow
          end

          apply_patch(p)
        end
      end
  end
end


