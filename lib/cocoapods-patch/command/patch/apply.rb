require 'cocoapods'

module Pod
  class Command
    class Patch < Command
      class Apply < Patch
        self.summary = 'Applies a patch to an installed Pod'

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

        def run
          apply_patch patch_file
        end
      end
    end
  end
end

# also used from the post-install hook
def apply_patch(patch_file)
  working_dir = Dir.pwd
  repo_root = `git rev-parse --show-toplevel`.strip
  ios_project_path = Pathname.new(working_dir).relative_path_from(Pathname.new(repo_root))

  directory_arg = File.join(ios_project_path, 'Pods')

  Dir.chdir(repo_root) {
    check_cmd = "git apply --check #{patch_file} --directory=#{directory_arg} -p2 2> /dev/null"

    can_apply = system(check_cmd)
    if can_apply
      apply_cmd = check_cmd.gsub('--check ', '')
      did_apply = system(apply_cmd)
      if did_apply
        Pod::UI.puts "Successfully applied #{patch_file}"
      else
        Pod::UI.warn "Failed to apply #{patch_file}"
      end
    end
  }
end
