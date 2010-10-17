class User < ActiveRecord::Base
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :name, :e_mail, :password, :password_confirmation, :salt


  attr_accessor :password, :password_confirmation
  before_save :prepare_password

  validates_presence_of :name
  validates_uniqueness_of :name, :e_mail, :allow_blank => true
  validates_format_of :name, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :e_mail, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_presence_of :password, :on => :create
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 4, :allow_blank => true

  # login can be either username or email address
  def self.authenticate(login, pass)
    user = find_by_name(login) || find_by_e_mail(login)
    return user if user && user.matching_password?(pass)
  end

  def matching_password?(pass)
    self.hashed_password == encrypt_password(pass)
  end



 # sp1-6.3.2 ----- start 
    def remember_token?
     (!remember_token.blank?) &&
       remember_token_expires_at && (Time.now.utc < remember_token_expires_at.utc)
   end

   # These create and unset the fields required for remembering users between browser closes
   def remember_me
     remember_me_for 2.weeks
   end

   def remember_me_for(time)
     remember_me_until time.from_now.utc
   end

   def remember_me_until(time)
     self.remember_token_expires_at = time
     self.remember_token = self.class.make_token
     save(:validate => false) 
   end
   # SP1-6.4 make mobile token 
   def check_m_token
     span = 40.weeks
     self.m_token_expires_at = span.from_now.utc
     self.m_token = self.class.make_token
     save(:validate => false) 
   end 
   
   
   # SP1-6.4 end 
   # refresh token (keeping same expires_at) if it exists
   def refresh_token
     if remember_token?
       self.remember_token = self.class.make_token
       save(:validate => false) 
     end
   end

   #
   # Deletes the server-side record of the authentication token. The
   # client-side (browser cookie) and server-side (this remember_token) must
   # always be deleted together.
   #
   def forget_me
     self.remember_token_expires_at = nil
     self.remember_token = nil
      save(:validate => false) 
   end

   
  private

   def self.secure_digest(*args)
     Digest::SHA1.hexdigest(args.flatten.join('--'))
   end

   def self.make_token
     secure_digest(Time.now, (1..10).map{ rand.to_s })
   end
 # SP1-6.3.2 ------ end
  
  def prepare_password
    unless password.blank?
      self.salt =self.class.secure_digest([Time.now, rand])
      self.hashed_password = encrypt_password(password)
    end
  end

  def encrypt_password(pass)
    self.class.secure_digest([pass, salt])
#    Digest::SHA1.hexdigest([pass,salt].join)
  end
end
