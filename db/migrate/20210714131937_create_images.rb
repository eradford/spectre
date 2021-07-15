class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |i|
      i.binary :data, null: false, limit: 2**32 - 1
      i.text :meta, null: false
    end
  end
end
