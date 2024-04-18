class RemoveGroupMembershipsGroupsNotes < ActiveRecord::Migration[7.1]
  def change
    drop_table :group_memberships do |t|
      t.bigint "user_id", null: false
      t.bigint "group_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["group_id"], name: "index_group_memberships_on_group_id"
      t.index ["user_id"], name: "index_group_memberships_on_user_id"
    end

    drop_table :groups do |t|
      t.string "name", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end

    drop_table :notes do |t|
      t.string "title"
      t.text "body"
      t.bigint "user_id", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["user_id"], name: "index_notes_on_user_id"
    end
  end
end
