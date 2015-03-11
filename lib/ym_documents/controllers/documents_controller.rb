require 'ym_documents'

module YmDocuments::DocumentsController
  def self.included(base)
    base.layout 'ym_content/application'
    super
  end
end
