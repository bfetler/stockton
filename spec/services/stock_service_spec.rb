require 'rails_helper'
require 'net/http'

describe StockService do
  
  before(:each) do
    WebMock.allow_net_connect!
  end
  
  after(:each) do
    WebMock.disable_net_connect!
  end

  it "should stub request_stocks" do
    StockService.stub(:request_stocks).and_return("200")
    StockService.request_stocks('GOOG').should eq("200")
  end

  it "request_stocks should receive 'GOOG'" do
    StockService.should_receive(:request_stocks).with('GOOG')
    StockService.request_stocks('GOOG')
  end

  describe "should parse_csv correctly" do
    before(:each) do
      body_line = '"GOOG","Google Inc.","Aug 15 - <b>667.54</b>","-1.12 - -0.17%"'
      @sash = StockService.parse_csv(body_line)
    end
    
    it "companysymbol is GOOG" do
      @sash["companysymbol"].should eq("GOOG")
    end
    it "companyname is nil" do
      # @sash["companyname"].should be_nil
      @sash["companyname"].should eq("Google Inc.")  # should ignore it
    end
    it "stock value is 667.54" do
      @sash["value"].should eq("667.54")
    end
    it "stock delta is -1.12" do
      @sash["delta"].should eq("-1.12")
    end
  end

  describe "should respond to fetch_uri stub" do
    before(:each) do
      @rbody = '"GOOG","Google Inc.","Aug 15 - <b>667.54</b>","-1.12 - -0.17%"'
      http_mock = double('Net::HTTPResponse')
      http_mock.stub(:code => '200', :message => "OK",
        :content_type => "text/html",
        :body => @rbody)
      StockService.stub(:fetch_uri).and_return(http_mock)  # okay!
    end
    
    context "request_stocks('GOOG'):" do
      before(:each) do
        @res = StockService.request_stocks('GOOG')
      end
      
      it "response code 200" do
        @res.code.should eq("200")
      end
      it "response message OK" do
        @res.message.should eq("OK")
      end
      it "response body correct" do
        @res.body.should eq(@rbody)
      end
    end
  
    context "parse_response('GOOG'):" do
      before(:each) do
        res = StockService.request_stocks('GOOG')
        @outp = StockService.parse_response(res)
      end
      
      it "companysymbol is GOOG" do
        @outp[0]["companysymbol"].should eq 'GOOG'
      end
      it "stock value is big" do
        @outp[0]["value"].to_f.should be > 600
      end
      it "stock delta is small" do
        @outp[0]["delta"].to_f.should be < -1
      end
    end
    
  end

  describe "should respond to one arg" do
    
    describe "request_stocks('GOOG'):" do
      before(:each) do
        @res = StockService.request_stocks('GOOG')
      end
      
      it "response code 200" do
        @res.code.should eq("200")
      end
      it "response message OK" do
        @res.message.should eq("OK")
      end
      it "response class HTTPOK" do
        @res.class.name.should eq("Net::HTTPOK")
      end
    end
  
    describe "parse_response('GOOG'):" do
      before(:each) do
        res = StockService.request_stocks('GOOG')
        @outp = StockService.parse_response(res)
      end
      
      it "companysymbol is GOOG" do
        @outp[0]["companysymbol"].should eq 'GOOG'
      end
      it "stock value is big" do
        @outp[0]["value"].to_i.should be > 600
      end
    end
  end

  describe "should respond to two args" do
    describe "request_stocks('GOOG', 'AAPL')" do
      before(:each) do
        @res = StockService.request_stocks('GOOG', 'AAPL')
      end
      
      it "response code 200" do
        @res.code.should eq("200")
      end
      it "response message OK" do
        @res.message.should eq("OK")
      end
    end
    
    describe "parse_response('GOOG', 'AAPL')" do
      before(:each) do
        res = StockService.request_stocks('GOOG', 'AAPL')
        @outp = StockService.parse_response(res)
      end
      
      it "companysymbol #1 is GOOG" do
        @outp[0]["companysymbol"].should eq 'GOOG'
      end
      it "stock value #1 is big" do
        @outp[0]["value"].to_i.should be > 600
      end
      it "companysymbol #2 is AAPL" do
        @outp[1]["companysymbol"].should eq 'AAPL'
      end
      it "stock value #2 is big" do
        @outp[1]["value"].to_i.should be > 100
      end
    end
    
  end

end
