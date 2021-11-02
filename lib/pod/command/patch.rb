require_relative 'patch/apply'
require_relative 'patch/create'

module Pod
  class Command
    class Patch < Command
      self.abstract_command = true
      self.summary = 'Create & apply patches to Pods.'

      def patch_file
        version = config.lockfile.version(@name)
        return config.project_root + 'patches' + "#{@name}+#{version}.diff"
      end

      def patches_path
        config.project_root + 'patches'
      end
    end
  end
end
