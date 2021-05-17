require "dry-types"
require "dry-struct"

module Types
  include Dry.Types()
end

User = Dry.Struct(name: Types::String, age: Types::Integer)

u = User.new(name: "kiggie", age: 75)

puts u.to_json
