namespace :subtitles do

  task :build_srt, [:locale] => [:environment] do |t, args|
    args.with_defaults(:locale => 'en')



  end

  task :import_default_from_srt => :environment do
    file = "tmp/captions.srt"
    key_prefix = 'demo_video_2.t'

    result = [] ; hash = {}

    File.open(file, 'r').read.each_line do |line|
      line = line.chomp("\n")

      if line =~ /^[0-9]+$/
        hash[:id] = line
        hash[:key] = key_prefix + line
      elsif line =~ /^[0-9\,\:]+\s+-->\s+[0-9\,\:]+$/
        hash[:time] = line
      elsif line =~ /.+/ && line !~ /^\s*$/
        if hash[:t].nil?
          hash[:t] = line
        else
          hash[:t] += "\n" + line
        end
      else
        result << hash
        hash = {}
      end
    end
    puts result ; result
  end

end