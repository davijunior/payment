class Invoice < ApplicationRecord
    validates :name, :card_number, :value, :due_date, :cvv, presence: true
end
