require 'digest/sha2'
require 'base64'
require 'securerandom'

class User < ActiveRecord::Base

  has_many :auth_tokens
  has_many :entries

  before_save :encrypt_password
  before_save :assign_uniq
  
  validates :username, uniqueness: { case_sensitive: false }, if: :username_not_blank?
  validates :email, uniqueness: { case_sensitive: false }

  def self.new_users
    return self.where("created_at > ?", Time.now.midnight - 1.day)
  end

  ## Instance Methods

  def add_new_auth( auth )
    if !AuthToken.is_used?(auth["credentials"]["token"])
      self.auth_tokens.create(:uuid => auth["uid"], :providor => auth["provider"], :token => auth["credentials"]["token"], :secret => auth["credentials"]["secret"])
    else
      nil
    end
  end

  ## Class Methods

  def self.create_with_auth(auth)
    create! do |user|
      auth_tokens = user.auth_tokens.new(:uuid => auth["uid"], :providor => auth["provider"], :token => auth["credentials"]["token"], :secret => auth["credentials"]["secret"])
      user.name = auth["info"]["name"]
      if auth["info"]["email"]
        user.email = auth["info"]["email"]
      end
      user.password = SecureRandom.urlsafe_base64(9)
      
      ## user.idhash = Digest::SHA1.hexdigest auth["uid"]
    end
  end

  def self.find_by_auth(auth)
    user = User.joins(:auth_tokens).where('auth_tokens.uuid=? AND auth_tokens.providor=?', auth['uid'], auth["provider"])
    return user.first if user
  end

  def self.authenticate username, password
    getusers = User.where(:username => username)
    
    if(getusers.count > 0)
      @thisuser = getusers.first
      if @thisuser.password == @thisuser.send(:do_encryption, (password + @thisuser.salt))
        # SET THE SESSION VARS, return true!
        return @thisuser
      else
        return false
      end
    else
      return false
    end
  end

  def self.check_uniq
    User.all.each do |u|
      u.save
    end
  end
  
  def is_fresh?
    return true if self.username.blank? or self.password.blank?
    return false
  end

  ## Entry Related.. for regular contests
  def contest_entries(contest_id)
    self.entries.where('contest_id=?', contest_id).order(created_at: :desc)
  end

  def assign_points(points)
    if self.points.nil?
      self.points = points
    else
      self.points = self.points + points  
    end
    
    self.save
  end

  def is_admin?
    return true if self.role == 10

    return false
  end

  private
  
  def assign_uniq
    if self.uniqid.nil?
      uniqi = SecureRandom.hex(8)

      self.uniqid = uniqi
    end
  end

  def encrypt_password
    if self.password_changed?
      salt = [Array.new(9){rand(256).chr}.join].pack('m').chomp
      self.salt = salt
      self.password = do_encryption(self.password + salt)
    end
  end

  def do_encryption(passString)
    Digest::SHA256.hexdigest(passString)
  end

  def username_not_blank?
    return false if self.username == '' || self.username.nil?
    return true
  end

end
