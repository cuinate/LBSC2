class User < ActiveRecord::Base
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :name, :e_mail, :password, :password_confirmation

  attr_accessor :password
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

  private

  def prepare_password
    unless password.blank?
      self.salt = Digest::SHA1.hexdigest([Time.now, rand].join)
      self.hashed_password = encrypt_password(password)
    end
  end

  def encrypt_password(pass)
    Digest::SHA1.hexdigest([pass, salt].join)
  end
end
