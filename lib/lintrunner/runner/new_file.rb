module Lintrunner
  module Runner
    class NewFile < Base

      def run(reporter)
        warnings = []
        git_changeset.each do |patch|
          filename = patch.delta.new_file[:path]
          next if patch.delta.binary?
          next unless patch.delta.added?
          next unless filename =~ match

          full_path = File.join(path, filename)

          messages = executor.execute(full_path, filename: filename)
          warnings.concat messages
          output = messages.collect do |message|
            reporter.report(message)
          end
        end
        warnings
      end

    end
  end
end
