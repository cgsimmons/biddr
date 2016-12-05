class BidsController < ApplicationController

  def create
    @auction = Auction.find(params[:auction_id])
    bid_params = params.require(:bid).permit(:price)
    @bid = Bid.new bid_params
    @bid.auction = @auction
    @user = current_user
    @bid.user = @user

    if @bid.save
      redirect_to auction_path(@auction), notice: "Bid Successful!"
    else
      flash.now[:alert] = 'Wrong Credentials'
      render 'auctions/show'
    end
  end
end