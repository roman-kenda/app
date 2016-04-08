require 'test_helper'

class ProductTest < ActiveSupport::TestCase
    
    fixtures :products

	test "product attributes must not be empty" do
		#свойства товара не должны бать пустыми
	    product = Product.new
	    assert product.invalid?
	    assert product.errors[:title].any?
	    assert product.errors[:description].any?
	    assert product.errors[:price].any?
	    assert product.errors[:image_url].any?
    end

    test "product price must be positive" do
        #цена товара должна быть положительной 
        product = Product.new(title: "My Book Title", description: "yyyy", image_url: "zzz.jpg")
        
        product.price = -1
        assert product.invalid?
        assert_equal ["must be greater then or equal to 0.01"], product.errors[:price]
            #должна быть больше или равна 0.01

        product.price = 0
        assert product.invalid?
        assert_equal ["must be greater than or equal to 0.01"],  product.errors[:price]


        product.price = 1	
        assert product.valid?
    end

    def new_product(image_url)
    	Product.new(title: "My book title", description: "yyyy", price: 1, image_url: image_url)
    end

    #test "image url" do 
        #url изображения
    #    ok = w%{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg http://a.b.c/x/y/z/fred.gif }
    #    bad = w%{ fred.doc fred.gif/more fred.gif.more }

    #    ok.each do |name|
    #    	assert new_product(name).valid?,  "#{name} shouldn't be invalid "
        	    # не должно быть приемлемым
    #    end

    #    bad.each do |name|
    #    	assert_new_product().invalid?, "#{name} shouldn't be valid"
        	# не должно быть приемлемым
    #    end
    #end

    test "product is not valid without a unique title" do 
    	#если у товара нет уникального названия, то он не допустим
    	product = Product.new( title: products(:ruby).title, description: "yyy", price: 1, image_url: "fred.gif" )

    	assert product.invalid?
    	assert_equal [I18n.translate('activerecords.errors.messages.taken')], product.errors[:title] 
    	    #уже было использовано
    end



end
	