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

  DEFAULT_SIR_TREVOR_BLOCK_TYPES = ['Text', 'Image', 'Video', 'Heading', 'Quote', 'List']
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

  def sir_trevor_settings_json
    if sir_trevor_settings
      j = JSON.parse(sir_trevor_settings)
    else
      j = {}
      DEFAULT_SIR_TREVOR_BLOCK_TYPES.each do |block_type|
        j[block_type] = {:required => false, :limit => 0 }
      end
    end
    j
  end

  def sir_trevor_limit_data
    # Hash to give to Sir Trevor JS initialize options
    settings = sir_trevor_settings_json
    block_type_limits = {}
    settings.map {|k,v| block_type_limits[k] = v["limit"]}
    {
      :blockTypeLimits => block_type_limits, 
      :blockTypes => settings.reject{|k,v| v["limit"] == "0" }.keys, 
      :required => settings.reject{|k,v| v["required"] == true }.keys 
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
