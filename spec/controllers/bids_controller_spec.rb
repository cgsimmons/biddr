require 'rails_helper'

RSpec.describe BidsController, type: :controller do
  describe '#create' do
    let(:auction) { create(:auction) }
    let(:user) { create(:user) }

    def valid_request
      post :create,
      params: { bid: attributes_for(:bid), auction_id: auction.id}
    end

    context 'with user signed in' do
      before { request.session[:user_id] = user.id }

      context 'with valid params' do
        it 'created a bid associated with signed in user' do
          valid_request
          expect(Bid.last.user).to eq(user)
        end

        it 'redirects to auction show page' do
          valid_request
          expect(response).to redirect_to(auction_path(auction))
        end

        it 'bid is added to DB' do
          count_before = Bid.count
          valid_request
          count_after = Bid.count
          expect(count_after).to eq(count_before + 1)
        end
      end
    end
  end

end
