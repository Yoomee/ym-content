class Ability
  include CanCan::Ability

  def initialize(user)
    # open ability
    can [:search, :show], ContentPackage do |content_package|
      content_package.visible_to_user?(nil)
    end
    if user.try(:admin?)
      can :manage, :all
      # admin ability
    elsif user.role == "author"
      # author ability
      can [:edit, :update], ContentPackage, :author_id => user.id
      can [:show], ContentPackage
      can [:index, :dashboard], ContentType
    elsif user
      # user ability
      can :show, ContentPackage do |content_package|
        content_package.visible_to_user?(user)
      end
    end
  end

end
