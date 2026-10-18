class CreateChatRooms < ActiveRecord::Migration[8.1]
  def change
    create_table :chat_rooms do |t|
      t.text :situation, null: false
      t.integer :level, null: false, default: 0

      t.timestamps
    end
  end
end
