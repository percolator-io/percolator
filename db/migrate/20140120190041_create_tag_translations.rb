class CreateTagTranslations < ActiveRecord::Migration
  def change
    create_table :tag_translations do |t|
      t.string :title
      t.string :lang
      t.references :tag, index: true

      t.timestamps
    end
  end
end
