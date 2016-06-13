class StockService

  require 'net/http'
# has it changed between ruby 1.9 and 2.1 ?

# define stock symbol list, keep in cache (local variable) or db?
# keep in class variable in StockService, get with an action?
  
# public
  # full public method for getting stock values
  def self.request(*stocks)
    res = self.request_stocks(*stocks)
    stocks_hash = self.parse_response(res)
    self.update_db(stocks_hash)
  end

# max length of uri?  2048 in IE, longer in others.  use POST not GET?
# 47 chars + 5 * stocks (5 = 4 char + "+"); (2047-47)/5 = 400 stocks max
# start a thread for each group of 400 rather than wait for response?

  # construct http request to get stock values
  def self.request_stocks(*stocks)   # *stocks is array of companysymbol
    if stocks.empty?
      stocks = []
      Stock.all.each { |s| stocks << s.companysymbol }
    end
#   stocks = Stock.find(:all).collect(&:companysymbol)

    sstr = stocks.join("+")
    sstr = URI.escape(sstr)  # not needed?
#   uri_str = 'http://finance.yahoo.com/d/quotes.csv?s=GOOG+AAPL+YHOO&f=snlc'
    uri_str = 'http://finance.yahoo.com/d/quotes.csv?s=' + sstr + '&f=snlc'

    res = self.fetch_uri(uri_str, 10)
    res  # return response
  end
  
  # one-stock hash from one-line comma-separated-value string
  def self.parse_csv(str)
    sash = Hash.new
#   sash["value"] = "0.00"
#   sash["delta"] = "-"
    sash["companysymbol"] = str[/\w+/]
#   sash["companyname"] = str.split(/[,"]/)[4]
    sash["companyname"] = str.split(/,/)[1][/[^"]+/]
    sash["value"] = str.split(/[<>]/)[2]
    sash["delta"] = str.split(/,/)[3][/[0-9+-\.]+/]
    sash
  end
  
# e.g. response body:
#   "GOOG","Google Inc.","Sep 12 - <b>690.88</b>","-1.31 - -0.19%"
#   "CB","Chubb Corporation","Sep 12 - <b>75.80</b>","+0.58 - +0.77%"
#   "TSLA","Tesla Motors, Inc","Sep 12 - <b>28.28</b>","+0.48 - +1.73%"
#   "ZYX","ZYX","N/A - <b>0.00</b>","N/A - N/A"
  
  # parse http response body, output stocks hash
  def self.parse_response(res)
    stocks_array = res.body.split("\r\n")
    stocks_hash = Hash.new
    stocks_array.each_with_index do |s, index|
      sash = self.parse_csv(s)
      stocks_hash[index] = sash
    end
    # puts "parse_response stocks_hash: " + stocks_hash.inspect
    stocks_hash
  end

  # update database stocks values from hash
  def self.update_db(stocks_hash)
    # send msg to redisplay view? try websockets? backbone?
    
    stocks_hash.each do |index, sash|
      stock = Stock.where("companysymbol = ?", sash["companysymbol"]).first
      unless stock.nil?   # should already be in db
        unless stock.update_attributes(sash)
          puts "can't update stock " + sash.inspect
        end
      end
    end
    
  end

  # public method for randomizing stock values
  def self.fake_request(*stocks)
    stocks_hash = self.randomize_stocks(*stocks)
    self.update_db(stocks_hash)
  end

  # return hash of randomized stock values
  def self.randomize_stocks(*stocks)   # *stocks is an Array of Stock models    
    stocks = Stock.all  if stocks.empty?    
    stocks_hash = Hash.new

    stocks.each_with_index do |stock, index|
# calculate new random value
      oldval = stock["value"].to_f
      del = Random.new().rand(-5.0...5.0).round(2)
      del = -del  if oldval+del < 0.0
      newval = (oldval + del).round(2)  # add/sub not perfect, must round
      sash = Hash.new
      sash["companysymbol"] = stock["companysymbol"]
      sash["value"] = newval.to_s
      sash["delta"] = del.to_s
      stocks_hash[index] = sash
    end

    stocks_hash  
  end

private
# copied from a web site somewhere (rubydoc http)
# replace with httpparty, rest_client gem?
  def self.fetch_uri(uri_str, limit = 10)
  # You should choose a better exception.
    raise ArgumentError, 'too many HTTP redirects' if limit == 0

    response = Net::HTTP.get_response(URI(uri_str))

    case response
    when Net::HTTPSuccess then  # 200, 2xx
      response
    when Net::HTTPRedirection then  # 301, 3xx
      location = response['location']
      # warn "redirected to #{location}"
      self.fetch_uri(location, limit - 1)
# 400 my request error
# 500 their request error
    else
      response.value
    end
  end

end
