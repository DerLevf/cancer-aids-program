class MakeDebtProjectOptionalInGroupMemberships < ActiveRecord::Migration[8.0]
  def change
    change_column_null :group_memberships, :debt_project_id, true
  end
end
