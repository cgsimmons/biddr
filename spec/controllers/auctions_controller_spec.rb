require 'rails_helper'

RSpec.describe AuctionsController, type: :controller do
  let(:user) { create(:user) }
  def signed_in
    request.session[:user_id] = user.id
  end

  describe '#new' do
    it 'renders the new template' do
      signed_in
      get :new
      expect(response).to render_template(:new)
    end

    it 'instantiates a new auction object' do
      signed_in
      get :new
      expect(assigns(:auction)).to be_a_new(Auction)
    end
  end

  describe '#create' do
    context 'with valid params' do
      def valid_request
        signed_in
        post :create, params: {auction: attributes_for(:auction)}
      end

      it 'saves a record to the database' do
        count_before = Auction.count
        valid_request
        count_after = Auction.count
        expect(count_after).to eq(count_before + 1)
      end

      it 'redirects to the auction show page' do
        valid_request
        expect(response).to redirect_to(auction_path(Auction.last))
      end
    end

    context 'with invalid params' do
      def invalid_request
        signed_in
        post :create, params: { auction: attributes_for(:auction, title: nil)}
      end

      it 'doesn\'t save a record to the database' do
        count_before = Auction.count
        invalid_request
        count_after = Auction.count
        expect(count_after).to eq(count_before)
      end

      it 'renders the new template' do
        invalid_request
        expect(response).to render_template(:new)
      end

    end
  end
end
