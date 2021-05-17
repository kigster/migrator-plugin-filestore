# frozen_string_literal: true

require 'rails_helper'

module Migrator
  module Plugins
    module FileStore

      EXPECTED_FILES_COUNT = 1_000_000

      RSpec.describe NormalizerReader do
        subject(:normalizer) { described_class.new(options: options, status: status) }

        let(:options) { Options.default_options }
        let(:status) { Status.new(EXPECTED_FILES_COUNT, options: options) }

        context "when there are #{EXPECTED_FILES_COUNT} records" do
          subject { ::FilePath }

          its(:count) { is_expected.to eq EXPECTED_FILES_COUNT }
        end

        context "with zero records in #{NormalizerReader::TARGET_TABLE_NAMES.join(', ')}" do
          NormalizerReader::TARGET_TABLE_NAMES.each do |model_class|
            context "#{model_class.singularize.camelize.constantize.name}.count should zero" do
              subject { model_class }

              its(:count) { is_expected.to be_zero }
            end
          end
        end
      end
    end
  end
end
