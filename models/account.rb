class Account
  include Mongoid::Document
  include Mongoid::Timestamps
      
  # Picture
  field :picture_uid
  dragonfly_accessor :picture  
  attr_accessor :rotate_picture_by
  before_validation :rotate_picture
  def rotate_picture
    if self.picture and self.rotate_picture_by
      picture.process!(:rotate, self.rotate_picture_by)
    end  
  end
  
  # Connections  
  has_many :connections, :dependent => :destroy
  accepts_nested_attributes_for :connections
  def self.providers
    [
      Provider.new('Twitter', image: ->(hash){ hash['info']['image'].gsub(/_normal/,'') }),
      Provider.new('Facebook', image: ->(hash){ hash['info']['image'].gsub(/square/,'large') }),
      Provider.new('Google', omniauth_name: 'google_oauth2', icon: 'google-plus', nickname: ->(hash) { hash['info']['name'] }, profile_url: ->(hash){ "http://plus.google.com/#{hash['uid']}"}),
      Provider.new('LinkedIn', nickname: ->(hash) { hash['info']['name'] }, profile_url: ->(hash){ hash['info']['urls']['public_profile'] })
    ]
  end  
  def self.provider_object(omniauth_name)    
    providers.find { |provider| provider.omniauth_name == omniauth_name }
  end  
    
  # Fields
  field :name, :type => String
  field :email, :type => String
  field :role, :type => String, :default => 'user'
  field :time_zone, :type => String
  field :crypted_password, :type => String
          
  attr_accessor :password, :password_confirmation 

  validates_presence_of :name, :role, :time_zone    
  validates_presence_of     :email
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :email,    :case_sensitive => false
  validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i  
  validates_presence_of     :password,                   :if => :password_required
  validates_presence_of     :password_confirmation,      :if => :password_required
  validates_length_of       :password, :within => 4..40, :if => :password_required
  validates_confirmation_of :password,                   :if => :password_required  
  
  HUMANIZED_ATTRIBUTES = {
    :password_confirmation => "Password again"
  }  
  def self.human_attribute_name(attr, options={})  
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super  
  end   
      
  def self.fields_for_index
    [:name, :email, :role, :time_zone]
  end
  
  def self.fields_for_form
    {
      :name => :text,
      :email => :text,
      :picture => :image,
      :role => :select,
      :time_zone => :select,
      :password => :password,
      :password_confirmation => :password,
      :connections => :collection
    }
  end
    
  def self.edit_hints
    {
      :password => 'Leave blank to keep existing password'      
    }
  end   
           
  def self.time_zones
    ['']+ActiveSupport::TimeZone::MAPPING.keys.sort
  end  
  
  def self.roles
    ['user','admin']
  end    
  
  def self.lookup
    :email
  end
    
  def uid
    id
  end
  
  def info
    {:email => email, :name => name}
  end
  
  def self.authenticate(email, password)
    account = find_by(email: email) if email.present?
    account && account.has_password?(password) ? account : nil
  end
  
  before_save :encrypt_password, :if => :password_required

  def has_password?(password)
    ::BCrypt::Password.new(crypted_password) == password
  end

  private
  def encrypt_password
    self.crypted_password = ::BCrypt::Password.create(self.password)
  end

  def password_required
    crypted_password.blank? || self.password.present?
  end  
end
