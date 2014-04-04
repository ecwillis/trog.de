require 'securerandom'

class ShortLink < ActiveRecord::Base
  
  def set_url(url, short=nil)
    
    ## Set the short id, to find the link
    if(self.short_id.nil?)
      if(short.nil?)
        self.short_id = SecureRandom.hex(5)
      else
        self.short_id = short
      end
    end

    self.link = url

    return self

  end

  def self.save_session_links_to_user(session_id, user_id)
    @links = self.get_by_session_id(session_id)

    @links.each do |sl|
      sl.user_id = user_id
      sl.session_id = nil

      sl.save
    end
  end

  def self.get_by_short( short )
    return self.where(short_id: short).first
  end

  def self.get_by_user_id(user_id, limit=10, offset=0)
    return self.where('user_id=?', user_id).limit(limit).offset(offset).order(created_at: :desc)
  end

  def self.get_by_session_id(session_id, limit=10, offset=0)
    return self.where('session_id=?', session_id).limit(limit).offset(offset).order(created_at: :desc)
  end
end
