class RedactorImageUpload < ActiveRecord::Base

  image_accessor :file
  validates_property :format, :of => :image, :in => [:jpeg, :jpg, :png, :gif, :JPEG, :JPG, :PNG, :GIF], :message => "must be an image"
  validate :file_uid, :presence => true
  self.table_name = "redactor_uploads"

  def image
    file_type == 'image' ? file : nil
  end
end