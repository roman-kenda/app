class Product < ActiveRecord::Base

    has_many :line_items
    has_many :orders, through: :line_items

    before_destroy :ensure_not_referenced_by_any_line_item

    LOCALES = [ "en", "es" ]
    validates :title, :description, :image_url, presence: true
    validates :price, numericality: {greater_then_or_equal_to: 0.01}
    validates :title, uniqueness: true
    validates :image_url, allow_blank: true, format:{
        with: %r{\.(gif|jpg|png)\Z}i,
        message: 'URL должен указывать на изображения в формата GIF, JPG или PNG'
    }
    validates :title, allow_blank: true, length: {minimum: 10}

    def self.latest
        Product.order(:updated_at).last 
    end

    private 

    #убеждаемся в отсутствии товарных позиций, ссылающийхся на данный товар

    def ensure_not_referenced_by_line_item
        if line_items.empty?
            return true
        else
            errors.add(:base, 'cуществуют товарные позиции')
            return false
        end
    end

end
