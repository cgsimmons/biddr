class AuctionsController < ApplicationController
  before_action :authenticate_user, except: [:index, :show]
  before_action :find_auction, except: [:index, :new, :create]

  def index
    @auctions = Auction.all
    if params[:search]
      @auctions = Auction.search(params[:search]).order(params[:sort_by]).page(params[:page]).per(10)
    else
     @auctions = Auction.order(title: :ASC).page(params[:page]).per(10)
   end
  end

  def new
    @auction = Auction.new
  end

  def create
    @auction = Auction.new auction_params
    @user = current_user
    @auction.user = @user
    if @auction.save
      redirect_to auction_path(@auction)
    else
      render :new
    end
  end

  def show
    @bid = Bid.new
  end

  def edit
    if cannot? :manage_auction, @auction
      redirect_to auction_path(@auction), alert: 'Access Denied!'
    end
  end

  def update
    if cannot? :manage_auction, @auction
      redirect_to auction_path(@auction), alert: 'Access Denied!'
    elsif @auction.update auction_params
      redirect_to auction_path(@auction), notice: 'Saved auction changes.'
    else
      render :edit
    end
  end

  def destroy
    if cannot? :manage_auction, @auction
      redirect_to auction_path(@auction), alert: 'Access Denied!'
    elsif @auction.destroy
      redirect_to auctions_path, notice: 'Auction deleted.'
    else
      redirect_to auction_path(@auction), alert: @auction.errors.full_messages.join(", ")
    end
  end

  private

  def find_auction
    @auction = Auction.find(params[:id])
  end

  def auction_params
    params.require(:auction).permit(:title, :details, :reserve_price, :end_date)
  end
end
