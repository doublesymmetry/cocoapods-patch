module Pod
  class Command
    class Patch < Command
      class Apply < Patch
        self.summary = 'Applies a patch to an installed Pod'

        self.description = <<-DESC
            `apply` description
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
          apply_patch patch_file
        end
      end
    end
  end
end

# also used from the post-install hook
def apply_patch(patch_file)
  check_cmd = "git apply --check #{patch_file} --directory=Pods -p2 2> /dev/null"
  can_apply = system(check_cmd)
  if can_apply
    apply_cmd = check_cmd.gsub('--check ', '')
    did_apply = system(apply_cmd)
    if did_apply
      UI.puts "Successfully applied #{patch_file}"
    else
      UI.warn "Failed to apply #{patch_file}"
    end
  end
end
