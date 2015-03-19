class AddMembershipIndexToMemberships < ActiveRecord::Migration
  def change
    add_index :memberships, [:user_id, :meetup_id], unique: true
  end
end
