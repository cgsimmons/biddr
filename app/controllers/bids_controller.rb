class BidsController < ApplicationController
  before_action :authenticate_user
  def index
    @bids = current_user.bids
  end

  def create
    @auction = Auction.find(params[:auction_id])
    bid_params = params.require(:bid).permit(:price)
    @bid = Bid.new bid_params
    @bid.auction = @auction
    @user = current_user
    @bid.user = @user
    @previous_bid = @auction.current_bid
    respond_to do |format|
      if cannot? :bid, @auction
        format.js { render :create_failure }
        format.html  {redirect_to auction_path(@auction), notice: 'Cannot bid on this auction.' }
      elsif @bid.save
        format.js { render :create_success }
        format.html { redirect_to auction_path(@auction), notice: "Bid Successful!"}
      else
        format.js { render :create_failure }
        format.html { render 'auctions/show' }
      end
    end
  end
end
