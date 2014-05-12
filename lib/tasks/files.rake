namespace :verba do
  namespace :files do
    desc 'Load words and phrases located in Rails.root/words/*.words'
    task load: [ :environment ] do
      files = Dir.glob Rails.root.join('words', '*.words')
      
      print "Loading words and phrases …\n\n"

      FileList['words/*.words'].each do |filename|
        print "> #{filename}:\n"
        
        lemma = ''

        Learnable.transaction do
          File.new(filename).each do |line|
            columns = line.split "\t"
            lemma = columns[0] unless columns[0].empty?
            
            next unless columns.length == 3
            
            print '.'

            if columns[0].empty?
              Phrase.create_with(translation: columns[2]).
                find_or_create_by(lemma: lemma, phrase: columns[1])
            else
              Word.create_with(translation: columns[2]).
                find_or_create_by(lemma: lemma, long_lemma: columns[1])
            end
          end
        end
        
        print "\n"
      end
    end
  end
end
