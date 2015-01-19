module YmContent::ContentAttribute

  def self.included(base)
    base.belongs_to :content_type
    base.belongs_to :default_attribute, :class_name => 'ContentAttribute'
    base.after_validation :set_meta_title, :if => :meta?
    base.after_validation :set_slug
    base.validates :slug, :name, :field_type, :presence => true
    base.validates :slug, :name, :uniqueness => { :scope => :content_type_id }
    base.extend(ClassMethods)
  end

  module ClassMethods

    def field_types
      {
        :string => 'Single line of text',
        :text => 'Block of text',
        :link => 'Link',
        :image => 'Image',
        :file => 'File',
        :embeddable => 'Embeddable content - Flickr, Instagram, Scribd, Slideshare, SoundCloud, Vimeo, YouTube',
        :tags => 'Tag list',
        :boolean => 'Check box',
        :user => "User",
        :location => "Location",
        :rich => "Rich content"
      }
    end

    def fields_to_duplicate
      column_names - %w{id content_type_id slug position}
    end

  end

  META_TAG_TYPES = ["title", "description", "image", "keywords"]

  def field_type
    ActiveSupport::StringInquirer.new(read_attribute(:field_type).to_s)
  end

  def input_type
    case field_type
    when 'file' then 'file_with_preview'
    when 'text' then 'redactor'
    when 'boolean' then 'content_boolean'
    when 'user' then 'select'
    when 'rich' then 'text'
    else field_type
    end
  end

  def input_method
    case field_type
    when 'embeddable' then slug + "_url"
    when 'tags' then slug.singularize + "_list"
    when 'user' then slug + "_id"
    else slug
    end
  end

  def input_options
    case field_type
    when 'user'
      {
        :collection => ::User.all,
        :prompt => "None selected"
      }
    else {}
    end
  end

  def limitable?
    %w{string text}.include?(field_type.to_s)
  end

  def removable?
    new_record? || content_type.missing_view?
  end

  def sir_trevor_limit_data
    default_block_types = ['Text', 'Image', 'Video', 'Heading', 'Quote', 'List']
    allowed_block_types = default_block_types.select { |type| send("num_#{type.downcase}_blocks") != 0 }
    {
      :blockTypeLimits => {
        :Text => num_text_blocks,
        :Image => num_image_blocks,
        :Quote => num_quote_blocks,
        :Heading => num_heading_blocks,
        :Video => num_video_blocks,
        :List => num_list_blocks
      }, 
      :blockTypes => allowed_block_types,
    }
  end

  def to_s
    name
  end

  private

  def set_meta_title
    unless name.start_with?('Meta ')
      self.name = 'Meta ' << name
      valid?
    end
  end

  def set_slug
    if slug.blank? && name.present? && errors['name'].blank?
      slug_name = name.gsub('-',' ').parameterize("_").sub(/^\d+/,'n')
      if ::ContentPackage.new().respond_to_without_content_attributes?(slug_name,true)
        slug_name = 'content_package_' + slug_name
      end
      self.slug = slug_name
      valid?
    end
  end

end
