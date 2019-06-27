require 'active_record'
ENV['RAILS_ENV'] = 'test'

ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = Logger.new(nil)

#ActiveRecord::Migrator.migrate(File.expand_path("../../rails_app/db/migrate/", __FILE__))
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../../rails_app/db/migrate/", __FILE__)]
ActiveRecord::MigrationContext.new(File.expand_path("../../rails_app/db/migrate/", __FILE__)).migrate
#ActiveRecord::Migrator.current_version

