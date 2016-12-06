class PublishingsController < ApplicationController

  def create
    auction = Auction.find params[:auction_id]
    if auction.publish!
      redirect_to auction, notice: 'Auction Published'
    else
      redirect_to auction, alert: 'Can\'t publish the auction'
    end
  end
end
