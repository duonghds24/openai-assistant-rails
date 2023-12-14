class Grape::RequestPolicy < ApplicationPolicy
  def admin?
    user.present? && user.role == "admin"
  end
end
