class Upload
  include Mongoid::Document
  include Mongoid::Timestamps
  extend Dragonfly::Model

  field :file_name, :type => String
  field :file_uid, :type => String
    
  # Dragonfly
  dragonfly_accessor :file  
    
  def self.fields_for_index
    [:file_name, :created_at]
  end
  
  def self.fields_for_form
    {
      :file => :file
    }
  end
  
  def self.filter_options 
    {
      :o => :created_at,
      :d => :desc
    }
  end
      
end
