# frozen_string_literal: true

class FileStruct < AppSchema
  required(:component_id).filled(:uuid)
  required(:file_path).filled(:string)
  required(:fingerprint_sha_256).filled(:string)
  optional(:fingerprint_comment_stripped_sha_256).maybe(:string)
  optional(:license_info).maybe(:hash)
end
