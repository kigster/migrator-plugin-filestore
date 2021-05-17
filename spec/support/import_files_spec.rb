# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'ImportFiles loads only once' do
  it 'should be set to true' do
    expect(Migrator::ImportFiles.new.ensure_loaded).to be(true)
  end
end

