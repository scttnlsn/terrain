ActiveRecord::Schema.define(version: 1) do
  create_table 'examples' do |t|
    t.string :foo, null: false
    t.string :bar
    t.string :baz
    t.timestamps null: false
  end
end
