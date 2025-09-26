class RemoveNotNullConstraintFromTasksAssignedToId < ActiveRecord::Migration[7.1]
  def change
    # Change the column to allow NULL values
    change_column_null :tasks, :assigned_to_id, true
  end
end