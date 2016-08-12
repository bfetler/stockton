require 'rails_helper'
require 'webmock/rspec'  # needed for stub_request()
require 'net/http'

describe "WebMock StockService" do
# before(:each) do
#   WebMock.disable_net_connect!
# end
# after(:each) do
#   WebMock.allow_net_connect!
# end
  before(:each) do
    @rbody = '"GOOG","Google Inc.","Aug 15 - <b>667.54</b>","-1.12 - -0.17%"'
#   stub_request(:get,
#     "http://finance.yahoo.com/d/quotes.csv?s=GOOG&f=snlc").
#     with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
#     to_return(:status => 200, :body => "", :headers => {})
    stub_request(:get,
      "http://finance.yahoo.com/d/quotes.csv?s=GOOG&f=snlc").
      with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => @rbody, :headers => {})
    @res = StockService.request_stocks('GOOG')
  end

  describe "webmock should respond to request_stocks('GOOG')" do    
    it "response code is 200" do
      @res.code.should eq("200")
    end
    #it "response message is OK" do
    #  @res.message.should eq("OK")  # webmock does not return OK
    #end
    it "response class name is HTTPOK" do
      @res.class.name.should eq("Net::HTTPOK")
    end
    it "response body correct" do
      @res.body.should eq(@rbody)
    end
  end

  describe "webmock should parse_response: request_stocks('GOOG')" do
    before(:each) do
      @outp = StockService.parse_response(@res)
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
