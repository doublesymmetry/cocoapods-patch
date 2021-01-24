require_relative 'patch/apply'
require_relative 'patch/create'

module Pod
  class Command
    class Patch < Command
      self.abstract_command = true
      self.summary = 'Create & apply patches to Pods.'

      def patch_file
        config.project_root + 'patches' + "#{@name}.diff"
      end

      def patches_path
        config.project_root + 'patches'
      end
    end
  end
end
