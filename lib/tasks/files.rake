namespace :verba do
  namespace :files do
    desc 'Load words and phrases located in Rails.root/words/*.words'
    task load: [ :environment ] do
      files = Dir.glob Rails.root.join('words', '*.words')
      
      print "Loading words and phrases …\n\n"

      FileList['words/*.words'].each do |filename|
        print "> #{filename}: "

        imported_items = Vocabulary.import File.new(filename)

        print "#{imported_items} words and phrases imported\n"
      end
    end
  end
end
