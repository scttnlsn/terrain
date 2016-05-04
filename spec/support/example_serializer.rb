class ExampleSerializer < ActiveModel::Serializer
  attributes :foo, :bar, :baz
  has_many :widgets
end
