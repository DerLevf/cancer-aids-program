class DebtProject < ApplicationRecord
  belongs_to :creator, class_name: "User"

  has_many :group_memberships, dependent: :destroy
  has_many :activity_logs, dependent: :destroy
  has_many :tasks, dependent: :destroy

  has_many :schuldner, -> { where(group_memberships: { role: :schuldner }) }, 
             class_name: "User", 
             source: :user, 
             through: :group_memberships 
             
  has_many :users, through: :group_memberships 
  def update_total_amount(amount_to_subtract)
    validated_amount = amount_to_subtract.to_f.abs 

    DebtProject.transaction do
      project_to_update = self.lock!
      
      # FIX: Wir verwenden explizit die Subtraktion (-)
      new_total = (project_to_update.total_amount || 0) - validated_amount
      
      # Speichert den neuen Wert
      project_to_update.update!(total_amount: new_total)
    end
    
  rescue => e
    Rails.logger.error "FEHLER: Gesamtbetrag-Update für Projekt #{self.id} fehlgeschlagen: #{e.message}"
    raise 
  end
end
