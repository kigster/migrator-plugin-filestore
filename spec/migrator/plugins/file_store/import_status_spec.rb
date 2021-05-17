require 'spec_helper'
require 'migrator/plugins/file_store/import_status'

module Migrator
  module Plugins
    module FileStore
      RSpec.describe ImportStatus do
        let(:args) { [] }
        let(:opts) { {} }
        subject { described_class.new(*args, **opts) }
        its(:processed) { is_expected.to be 0 }
        its(:imported) { is_expected.to be 0 }
        its(:erored) { is_expected.to be 0 }
      end
    end
  end
end
