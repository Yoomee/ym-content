module YmContent
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include YmCore::Generators::Migration
      include YmCore::Generators::Ability

      source_root File.expand_path("../templates", __FILE__)
      desc "Installs YmContent."

      def manifest
        # models
        copy_file "models/content_type.rb",      "app/models/content_type.rb"
        copy_file "models/content_attribute.rb", "app/models/content_attribute.rb"
        copy_file "models/content_package.rb",   "app/models/content_package.rb"
        copy_file "models/content_chunk.rb",     "app/models/content_chunk.rb"
        copy_file "models/persona.rb",           "app/models/persona.rb"
        copy_file "models/persona_group.rb",     "app/models/persona_group.rb"
        copy_file "models/navigation_item.rb",   "app/models/navigation_item.rb"

        # views
        copy_file "views/users/_form.html.haml", "app/views/users/_form.html.haml"

        # controllers
        copy_file "controllers/content_types_controller.rb",      "app/controllers/content_types_controller.rb"
        copy_file "controllers/content_packages_controller.rb",   "app/controllers/content_packages_controller.rb"
        copy_file "controllers/personas_controller.rb",           "app/controllers/personas_controller.rb"
        copy_file "controllers/navigation_items_controller.rb",   "app/controllers/navigation_items_controller.rb"

        # migrations
        try_migration_template "migrations/create_content_types.rb",      "db/migrate/create_content_types"
        try_migration_template "migrations/create_content_attributes.rb", "db/migrate/create_content_attributes"
        try_migration_template "migrations/create_content_packages.rb",   "db/migrate/create_content_packages"
        try_migration_template "migrations/create_content_chunks.rb",     "db/migrate/create_content_chunks"
        try_migration_template "migrations/create_personas.rb",           "db/migrate/create_personas"
        try_migration_template "migrations/create_navigation_items.rb",   "db/migrate/create_navigation_items"

      end

    end
  end
end
