class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    can :manage_auction, Auction do |a|
      a.user == user
    end

    can :bid, Auction do |a|
      a.user != user
    end

  end
end
