# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_25_093421) do
  create_table "debt_projects", force: :cascade do |t|
    t.string "name"
    t.decimal "total_amount"
    t.text "description"
    t.date "deadline"
    t.integer "creator_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_debt_projects_on_creator_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "debt_project_id"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["debt_project_id"], name: "index_group_memberships_on_debt_project_id"
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "deadline"
    t.integer "status"
    t.integer "assigned_to_id", null: false
    t.integer "debt_project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_id"], name: "index_tasks_on_assigned_to_id"
    t.index ["debt_project_id"], name: "index_tasks_on_debt_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "username"
    t.string "password_digest"
    t.decimal "budget"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "debt_projects", "users", column: "creator_id"
  add_foreign_key "group_memberships", "debt_projects"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "tasks", "assigned_tos"
  add_foreign_key "tasks", "debt_projects"
end
