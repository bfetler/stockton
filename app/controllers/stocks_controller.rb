class StocksController < ApplicationController
  include ControllerHelper

  before_filter :authenticate_user!, :except => [:home, :guestlog]
  before_filter :is_admin?, :only => [:sservice]

  # GET /stocks
  # GET /stocks.json
  def index
    if current_user.admin?
      @stocks = Stock.all
    else
      @stocks = current_user.stocks
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stocks }  # needed for getJSON
    end
  end


# StockService is usually called from background task,
#   but admin may also run update
  def sservice
    if current_user.admin?
      if params[:random] == "true"
        # StockService.fake_request
      else
        StockService.request
      end
    end
    redirect_to stocks_path
  end

  def home
    if user_signed_in?
      redirect_to stocks_path
    else
      redirect_to new_user_session_path
    end
  end

  def guestlog
    if params[:guest] == "login"
      sign_in guest_user
    end
    redirect_to stocks_path
  end

  # GET /stocks/new
  # GET /stocks/new.json
  def new
    @stock = Stock.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @stock }
    end
  end

  # POST /stocks
  # POST /stocks.json
  def create
    # initialize value, delta if not defined
    params[:stock][:value] ||= 0.0
    params[:stock][:delta] ||= 0.0

#   @stock = Stock.new(params[:stock])
    @stock = Stock.new(stock_params)

    # stock_from_db = Stock.where("companysymbol = ?", @stock.companysymbol)
    stock_from_db = @stock.find_in_db
    
    respond_to do |format|
      if is_in_user_stocklist?(@stock)
        format.html { redirect_to :action => "index" }
        format.json { render json: @stock, status: :created, location: @stock }
      elsif stock_from_db.any?
        current_user.stocks << stock_from_db  unless current_user.admin?
        format.html { redirect_to :action => "index" }
        format.json { render json: @stock, status: :created, location: @stock }
      elsif @stock.valid_request? and @stock.save
        current_user.stocks << @stock  unless current_user.admin?
        format.html { redirect_to :action => "index" }
        format.json { render json: @stock, status: :created, location: @stock }
      else
        format.html { render action: "new" }
        format.json { render json: @stock.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /stocks/1
  # DELETE /stocks/1.json
  def destroy
# should only destroy if admin; else just remove from current_user.stocks
    if current_user.admin?
      @stock = Stock.find(params[:id])
      @stock.users.clear
      @stock.destroy
    else
      current_user.stocks.clear
    end

    respond_to do |format|
      format.html { redirect_to stocks_url }
      format.json { head :no_content }
    end
  end

  private
#   strong params
    def stock_params
      params.require(:stock).permit(:companyname, :companysymbol, :delta, :value)
    end

end
