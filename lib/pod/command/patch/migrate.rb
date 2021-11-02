require 'pathname'

module Pod
  class Command
    class Patch < Command
      class Migrate < Patch
        self.description = <<-DESC
            Migrates previous patch files to the new format.
        DESC

        def clear_patches_folder_if_empty
          if Dir.empty?(patches_path)
            FileUtils.remove_dir(patches_path)
          end
        end

        def run
          UI.puts 'Migrating patches...'
          patches_dir = Pathname.new(Dir.pwd) + 'patches'
          if patches_dir.directory?
            patches = patches_dir.each_child.select { |c| c.to_s.end_with?('.diff') }
            patches.each do |p|
              # check if patch file has new format
              if p.to_s.include?('+')
                # do nothing
              else
                # rename patch file
                pod_name = p.basename('.diff').to_s
                UI.puts "Renaming #{pod_name}"

                pod_version = config.lockfile.version(pod_name)
                new_patch_name = p.to_s.gsub('.diff', "+#{pod_version}.diff")
                
                File.rename(p, new_patch_name)
              end
            end
          end
        end
      end
    end
  end
end


