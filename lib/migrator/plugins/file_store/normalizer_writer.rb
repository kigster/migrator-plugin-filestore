# frozen_string_literal: true

require "active_support/inflector"

module Migrator
  module Plugins
    class NormalizerWriter

      attr_accessor :actions,
                    :file,
                    :file_content,
                    :file_license,
                    :component_file_content

      def initialize(file:, options:, import_status:)
        self.file          = file
        self.options       = options
        self.import_status = import_status
        self.actions       = []
      end

      def migrate
        in_a_transaction do |record_migrator|
          record_migrator.file_content           = import_status.with_duration(self, :create_file_content)
          record_migrator.component_file_content = import_status.with_duration(self, :create_component_file_content)
          record_migrator.file_license           = import_status.with_duration(self, :create_file_license) if file.license_info.present?
        end
        actions.tap do |performed_actions|
          performed_actions.each { |a| import_status.incr!(a) }
        end
      rescue StandardError => e
        import_status.error!(e)
        raise
      end

      private

      def create_file_license
        FileLicense.find_or_initialize_by(
          path:         file.file_path,
          component_id: file.component_id,
          file_content: file_content,
        ).tap do |fl|
          actions << (fl.new_record? ? :file_license_created : :file_license_updated)
          fl.license = file.license_info
          fl.save! unless dry_run?
        end
      end

      def create_component_file_content
        ComponentsFileContent.find_or_initialize_by(
          component_id: file.component_id,
          file_content: file_content,
        ).tap do |cfc|
          actions << (cfc.new_record? ? :component_file_content_created : :component_file_content_updated)
          cfc.save! unless dry_run?
        end
      end

      def create_file_content
        FileContent.find_or_initialize_by(
          sha:       file.fingerprint_sha_256,
          sha_clean: file.fingerprint_comment_stripped_sha_256,
        ).tap do |fc|
          actions << (fc.new_record? ? :file_content_created : :file_content_updated)
          fc.save! unless dry_run?
        end
      end
    end
  end
end
