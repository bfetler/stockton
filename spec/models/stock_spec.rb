require 'rails_helper'

describe Stock do
# need stock.rb model w/ validations, migration, rake db:test:prepare to pass

  before(:each) do
    @attr = { :companyname 	=> "Google",
              :companysymbol 	=> "GOOG",
              :value  	 	=> "567.8",
              :delta  	 	=> "12.3"
            }
  end

  describe "companyname" do
    it "should create stock" do
      new_stock = Stock.create!(@attr)
      new_stock.should be_valid
    end
    
    it "should require a companyname" do
      new_stock = Stock.new(@attr.merge(:companyname => ""))
      new_stock.should_not be_valid
    end
  end
    
  describe "company symbol" do
    it "should require a companysymbol" do
      new_stock = Stock.new(@attr.merge(:companysymbol => ""))
      new_stock.should_not be_valid
    end

    it "should require a unique companysymbol" do
      new_stock = Stock.create!(@attr)
      new_stock.should be_valid
      copy_stock = Stock.new(@attr.merge(:companyname => "Ogle"))
      copy_stock.should_not be_valid
    end
  
    it "companysymbol should have no lowercase" do
      new_stock = Stock.new(@attr.merge(:companysymbol => "Abc"))
      new_stock.should_not be_valid
    end
  
    it "companysymbol should not have extraneous characters" do
      new_stock = Stock.new(@attr.merge(:companysymbol => "_=7@"))
      new_stock.should_not be_valid
    end
  
    it "companysymbol should have no more than 4 characters" do
      new_stock = Stock.new(@attr.merge(:companysymbol => "Abcde"))
      new_stock.should_not be_valid
    end
  
    it "companysymbol should have no more than 4 uppercase characters" do
      new_stock = Stock.new(@attr.merge(:companysymbol => "ASDFG"))
      new_stock.should_not be_valid
    end
    
    it "companysymbol should not have 7 uppercase characters" do
      new_stock = Stock.new(@attr.merge(:companysymbol => "DOCTYPE"))
      new_stock.should_not be_valid
    end
  
    it "companysymbol should have no spaces" do
      new_stock = Stock.new(@attr.merge(:companysymbol => "AB C"))
      new_stock.should_not be_valid
    end
  
    it "companysymbol should have at least one uppercase character" do
      new_stock = Stock.new(@attr.merge(:companysymbol => "A"))
      new_stock.should be_valid
    end
  
    it "companysymbol may have two uppercase characters" do
      new_stock = Stock.new(@attr.merge(:companysymbol => "CB"))
      new_stock.should be_valid
    end
  
    it "companysymbol may have three uppercase characters" do
      new_stock = Stock.new(@attr.merge(:companysymbol => "VAR"))
      new_stock.should be_valid
    end
  end
  
  describe "numbers" do
    describe "value" do
      it "value should be a number" do
        new_stock = Stock.new(@attr.merge(:value => "40.4"))
        new_stock.should be_valid
      end
      
      it "value should not be negative" do
        new_stock = Stock.new(@attr.merge(:value => "-40.4"))
        new_stock.should_not be_valid
      end
      
      it "value should not be non-number" do
        new_stock = Stock.new(@attr.merge(:value => "abz"))
        new_stock.should_not be_valid
      end
      
      it "value should not be random chars" do
        new_stock = Stock.new(@attr.merge(:value => "\n"))
        new_stock.should_not be_valid
      end
    end
      
    describe "delta" do
      it "delta should be a number" do
        new_stock = Stock.new(@attr.merge(:delta => "40.4"))
        new_stock.should be_valid
      end
      
      it "delta should not be a non-number" do
        new_stock = Stock.new(@attr.merge(:delta => "abz"))
        new_stock.should_not be_valid
      end
      
      it "delta should not be partial number" do
        new_stock = Stock.new(@attr.merge(:delta => "."))
        new_stock.should_not be_valid
      end
      
      it "delta should not be random chars" do
        new_stock = Stock.new(@attr.merge(:delta => "\n"))
        new_stock.should_not be_valid
      end
      
      it "delta should be less than value" do
        new_stock = Stock.new(@attr.merge(:value => "40.4", :delta => "-30"))
        new_stock.should be_valid
      end
      
      it "delta should not be more than value" do
        new_stock = Stock.new(@attr.merge(:value => "40.4", :delta => "-50.5"))
        new_stock.should_not be_valid
      end
    end
  end
  
  describe "helpers" do
    describe "find in db:" do
      before(:each) do
        @stock = Stock.new(@attr)
      end
      
      it "should not find new stock in db" do
        stock_from_db = @stock.find_in_db
        stock_from_db.should be_empty
      end
      
      it "should find non-empty array from db" do
        @stock.save!
        stock_from_db = @stock.find_in_db
        stock_from_db.should_not be_empty
      end
      
      it "should find saved stock in db" do
        @stock.save!
        stock_from_db = @stock.find_in_db
        stock_from_db.first.should eq(@stock)
      end
    end
  end

  describe "web request" do
    it "companysymbol valid_request should respond to http request" do
      WebMock.allow_net_connect!
      new_stock = Stock.new(@attr.merge(:companysymbol => "VAR"))
      new_stock.valid_request?.should be_true
      WebMock.disable_net_connect!
    end
  
    it "companysymbol valid_request should reject invalid http request" do
      WebMock.allow_net_connect!
      new_stock = Stock.new(@attr.merge(:companysymbol => "ZYX"))
      new_stock.valid_request?.should be_false
      WebMock.disable_net_connect!
    end
  
    it "companysymbol valid_request should reject lowercase" do
      WebMock.allow_net_connect!
      new_stock = Stock.new(@attr.merge(:companysymbol => "abc"))
      new_stock.valid_request?.should be_false
      WebMock.disable_net_connect!
    end
  
    it "companysymbol valid_request should reject bad characters" do
      WebMock.allow_net_connect!
      new_stock = Stock.new(@attr.merge(:companysymbol => "_=7@"))
      new_stock.valid_request?.should be_false
      WebMock.disable_net_connect!
    end
  
    it "companysymbol valid_request should reject more than 4 uppercase chars" do
      WebMock.allow_net_connect!
      new_stock = Stock.new(@attr.merge(:companysymbol => "ASDFG"))
      new_stock.valid_request?.should be_false
      WebMock.disable_net_connect!
    end
  
    it "companysymbol valid_request should reject more than 4 chars" do
      WebMock.allow_net_connect!
      new_stock = Stock.new(@attr.merge(:companysymbol => "Abcde"))
      new_stock.valid_request?.should be_false
      WebMock.disable_net_connect!
    end
  
    it "companysymbol valid_request should reject spaces" do
      WebMock.allow_net_connect!
      new_stock = Stock.new(@attr.merge(:companysymbol => "AB C"))
      new_stock.valid_request?.should be_false
      WebMock.disable_net_connect!
    end
  end

end
