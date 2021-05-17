class AppSchema < Dry::Schema::Params
  define do
    config.file_path.discard_path = true
  end
end
