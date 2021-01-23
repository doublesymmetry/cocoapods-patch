require 'pathname'

module Pod
  class Command
    class Patch < Command
      class Create < Patch
        self.description = <<-DESC
            Creates a patch file comparing your local Pod changes to the upstream
            version specified in your Podfile. The patch is saved into the `patches`
            directory.
        DESC

        self.arguments = [
          CLAide::Argument.new('NAME', true)
        ]

        def initialize(argv)
          @name = argv.shift_argument
          super
        end

        def validate!
          super
          help! 'A Pod name is required.' unless @name
        end

        def clear_patches_folder_if_empty
          if Dir.empty?(patches_path)
            FileUtils.remove_dir(patches_path)
          end
        end

        def run
          # create patches folder if it doesn't exist
          FileUtils.mkdir_p(patches_path)

          Dir.mktmpdir('cocoapods-patch-', config.project_root) do |work_dir|
            sandbox = Pod::Sandbox.new(work_dir)
            installer = Pod::Installer.new(sandbox, config.podfile)
            installer.clean_install = true

            installer.prepare
            installer.resolve_dependencies

            UI.puts "Checking if pod exists in project..."
            specs_by_platform = installer.send :specs_for_pod, @name

            if specs_by_platform.empty?
              UI.warn "Error: pod does not exist in project. Did you use incorrect pod name?"
              clear_patches_folder_if_empty

              return
            end

            pod_installer = installer.send :create_pod_installer, @name
            pod_installer.install!

            UI.puts "Creating patch"
            theirs = Pathname.new(work_dir).join(@name).relative_path_from(config.project_root)
            ours = config.project_pods_root.join(@name).relative_path_from(config.project_root)
            gen_diff_cmd = "git diff --no-index #{theirs} #{ours} > #{patch_file}"

            did_succeed = system(gen_diff_cmd)
            if not did_succeed.nil?
              if File.empty?(patch_file)
                File.delete(patch_file)
                clear_patches_folder_if_empty
                UI.warn "Error: no changes detected between current pod and original"
              else
                UI.puts "Created patch #{patch_file} 🎉"
              end
            else
              UI.warn "Error: failed to create patch for #{@name}"
            end
          end
        end
      end
    end
  end
end
