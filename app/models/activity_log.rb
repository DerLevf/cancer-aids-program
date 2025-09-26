require 'csv'

class ActivityLog < ApplicationRecord
  belongs_to :user
  belongs_to :debt_project, optional: true
  belongs_to :trackable, polymorphic: true, optional: true
  serialize :details, coder: JSON

  # Definiert die Spaltenreihenfolge für den CSV-Export
  CSV_ATTRIBUTES = %w{id created_at user_id debt_project_id action details}

  # Dies ist eine Klassenmethode zur Datengenerierung.
  def self.to_csv
    CSV.generate(headers: true, col_sep: ';') do |csv|
      csv << CSV_ATTRIBUTES

      all.each do |log|
        values = log.attributes.values_at(*CSV_ATTRIBUTES)

        # Spezielle Behandlung für komplexe Felder (wie JSON oder Hashes)
        values[CSV_ATTRIBUTES.index('details')] = log.details.to_json if log.details.present?

        csv << values
      end
    end
  end
  
  # Die Methode 'index' gehört NICHT hierher!
end