# frozen_string_literal: true

require 'logger'

Rails.logger = Logger.new(nil) if Rails.env.development?
