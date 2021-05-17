# frozen_string_literal: true

# noinspection RubyResolve

# == Schema Information
#
# Table name: files
#
#  component_id                         :uuid             not null, primary key
#  file_path                            :text             not null
#  fingerprint_sha_256                  :binary           not null
#  fingerprint_comment_stripped_sha_256 :binary
#  license_info                         :json
#
# Indexes
#
#  index_files_on_component_id_and_file_path            (component_id,file_path) UNIQUE
#  index_files_on_fingerprint_comment_stripped_sha_256  (fingerprint_comment_stripped_sha_256) WHERE (fingerprint_comment_stripped_sha_256 IS NOT NULL)
#  index_files_on_fingerprint_sha_256                   (fingerprint_sha_256)
#
require 'rails_helper'

# In this spec we migrate a random record that has not been migrated yet.
# Every test run it should be a different record: one random, and one
# specifically with the license_info.
class FilePath
  class << self
    def a_file
      find(pluck(:component_id).sample)
    end

    def a_file_with_a_license
      @a_file_with_a_license ||= where.not(license_info: nil).order('random()').first
    end

    def a_file_with_a_clean_sha
      @a_file_with_a_clean_sha ||= where.not(fingerprint_comment_stripped_sha_256: nil).order('random()').first
    end
  end
end

RSpec.describe FilePath, migrate: true do
  include RSpec::Benchmark::Matchers
  subject!(:the_file) { described_class.a_file_with_a_clean_sha }
  let(:output) { StringIO.new }
  let(:argv) { %w[] }

  context 'when using #fast_counter as a substitute for #count' do
    subject {  FilePath.fast_counter }
    it { ex_expected.to eq 1_000_000}
  end
  let(:import_status) { ::Migrator::Plugins::FileStore::ImportStatus.new(todo: todo)}
  let(:sha_clean) { the_file.fingerprint_comment_stripped_sha_256 }
  let(:sha) { the_file.fingerprint_sha_256 }
  let(:file_path) { the_file.file_path }
  let(:component_id) { the_file.component_id }

  describe '.fast_counter class method' do
    it { is_expected.to eq described_class.count }
  end

  its(:component_id) { is_expected.to eql component_id }
  its(:file_path) { is_expected.to eql file_path }
  its(:fingerprint_sha_256) { is_expected.to eq sha }
  its('fingerprint_sha_256.size') { is_expected.to eq 64 }
  its(:fingerprint_comment_stripped_sha_256) { is_expected.to eq sha_clean }
  its('fingerprint_comment_stripped_sha_256.size') { is_expected.to eq 64 }

  describe 'is migrated without a license' do
    it 'creates FileContent record' do
      expect { the_file.migrate() }.to change(FileContent, :count).by(1)
    end
  end

  describe 'is migrated with a license' do
    # grab a record with a license_info
    subject!(:the_file) { described_class.a_file_with_a_license }

    let(:license_info) { the_file.license_info }

    its(:license_info) { is_expected.to eq license_info }
    its(:license_info) { is_expected.not_to be_nil }

    %i[FileContent ComponentsFileContent FileLicense].each do |table|
      context "#{table}.count" do
        subject(:model) { Kernel.const_get(table) }

        it "increases" do
          expect(the_file.license_info).not_to be_nil
          expect { the_file.migrate(import_status: import_status) }.to change(model, :count).by(1)
        end
      end
    end
  end
end
