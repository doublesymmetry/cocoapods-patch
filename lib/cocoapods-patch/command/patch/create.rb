require 'pathname'

module Pod
  class Command
    class Patch < Command
      class Create < Patch
        self.summary = 'Creates a patch by diffing upstream Pod with local changes'

        self.description = <<-DESC
            `create` description
        DESC

        def initialize(argv)
          @name = argv.shift_argument
          super
        end

        def validate!
          super
          help! 'A Pod name is required.' unless @name
        end

        def run
          Dir.mktmpdir('cocoapods-patch-', config.project_root) do |work_dir|
            sandbox = Pod::Sandbox.new(work_dir)
            installer = Pod::Installer.new(sandbox, config.podfile)
            installer.clean_install = true

            installer.prepare
            installer.resolve_dependencies

            pod_installer = installer.send :create_pod_installer, @name
            pod_installer.install!

            theirs = Pathname.new(work_dir).join(@name).relative_path_from(config.project_root)
            ours = config.project_pods_root.join(@name).relative_path_from(config.project_root)
            gen_diff_cmd = "git diff --no-index #{theirs} #{ours} > #{patch_file}"

            did_succeed = system(gen_diff_cmd)
            if not did_succeed.nil?
              UI.puts "Created patch #{patch_file}"
            else
              UI.warn "Error creating patch for #{@name}"
            end
          end
        end
      end
    end
  end
end
