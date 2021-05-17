# frozen_string_literal: true

require 'rails_helper'
require 'digest'

RSpec.describe FileContent do
  context 'with no file_path created' do
    subject {
      described_class.create(sha:       sha,
                             sha_clean: sha_clean)
    }

    let(:component_id) { UUID.generate }
    let(:file_path) { UUID.generate }
    let(:source) {
      <<~SOURCE
        #!/usr/bin/env bash
        #———————————————————————————————————————————————————————————————————————————————
        # © 2016-2020 Konstantin Gredeskoul, All rights reserved. MIT License.
        # Ported from the licensed under the MIT license Project Pullulant, at
        # https://github.com/kigster/pullulant
        #
        # Any modifications, © 2016-2020 Konstantin Gredeskoul, All rights reserved. MIT License.
        #———————————————————————————————————————————————————————————————————————————————
      SOURCE
    }
    let(:sha) { Digest::SHA2.new(256).digest(source) }
    let(:sha_clean) { nil }

    its(:sha) { is_expected.to eq sha }
  end
end
