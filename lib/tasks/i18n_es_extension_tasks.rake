namespace :radiant do
  namespace :extensions do
    namespace :es do
      
      desc "Runs the migration of the I18n Es extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          I18nEsExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          I18nEsExtension.migrator.migrate
        end
      end
      
      desc "Copies public assets of the I18n Es to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        puts "Copying assets from I18nEsExtension"
        Dir[I18nEsExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(I18nEsExtension.root, '')
          directory = File.dirname(path)
          mkdir_p RAILS_ROOT + directory, :verbose => false
          cp file, RAILS_ROOT + path, :verbose => false
        end
      end  
    end
  end
end
