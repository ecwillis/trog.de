class AuthToken < ActiveRecord::Base
  belongs_to :user

  def self.is_used?(token)
    _return = false
    if AuthToken.where('token=?', token).length == 1
      _return = true
    end

    _return
  end
  
end
