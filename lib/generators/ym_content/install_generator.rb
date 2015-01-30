require 'ym_core'
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
        insert_into_file "app/models/user.rb", "\n  def self.available_roles\n    %w(admin editor author)\n  end\n", :after => "class User < ActiveRecord::Base"
        copy_file "models/meta_datum.rb",   "app/models/meta_datum.rb"

        # views
        copy_file "views/users/_form.html.haml", "app/views/users/_form.html.haml"

        # controllers
        copy_file "controllers/content_types_controller.rb",      "app/controllers/content_types_controller.rb"
        copy_file "controllers/content_packages_controller.rb",   "app/controllers/content_packages_controller.rb"
        copy_file "controllers/personas_controller.rb",           "app/controllers/personas_controller.rb"
        copy_file "controllers/navigation_items_controller.rb",   "app/controllers/navigation_items_controller.rb"
        copy_file "controllers/meta_data_controller.rb",   "app/controllers/meta_data_controller.rb"

        # migrations
        try_migration_template "migrations/create_content_types.rb",      "db/migrate/create_content_types.rb"
        try_migration_template "migrations/create_content_attributes.rb", "db/migrate/create_content_attributes.rb"
        try_migration_template "migrations/create_content_packages.rb",   "db/migrate/create_content_packages.rb"
        try_migration_template "migrations/create_content_chunks.rb",     "db/migrate/create_content_chunks.rb"
        try_migration_template "migrations/create_personas.rb",           "db/migrate/create_personas.rb"
        try_migration_template "migrations/create_navigation_items.rb",   "db/migrate/create_navigation_items.rb"
        try_migration_template "migrations/create_navigation_items.rb",   "db/migrate/create_navigation_items.rb"
        try_migration_template "migrations/add_meta_data_to_content_packages.rb",   "db/migrate/add_meta_data_to_content_packages.rb"
        try_migration_template "migrations/create_meta_data.rb",   "db/migrate/create_meta_data.rb"
        try_migration_template "migrations/add_full_path_to_permalinks.rb",   "db/migrate/add_full_path_to_permalinks.rb"
        try_migration_template "migrations/create_sir_trevor_images.rb",   "db/migrate/create_sir_trevor_image.rb"

        # initializers
        copy_file 'initializers/ym_content.rb',
          'config/initializers/ym_content.rb'

          # stylesheets
          copy_file 'stylesheets/_cms_styles.scss',
          'app/assets/stylesheets/sass/_cms_styles.scss'

        #Copy features folder
        directory "../../../../features/", "features"
      end

    end
  end
end
