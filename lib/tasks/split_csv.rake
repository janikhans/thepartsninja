namespace :split_csv do
  desc 'Split larger CSVs into more manageable chunks'
  task :process, [:original, :file_count] => [:environment] do |_t, args|
    header_lines = 1
    file_count = args[:file_count].to_i
    lines = `cat #{args[:original]} | wc -l`.to_i - header_lines
    lines_per_file = (lines / file_count) + header_lines
    header = `head -n #{header_lines} #{args[:original]}`

    start = header_lines
    generated_files = []
    file_count.times do |i|
      finish = start + lines_per_file
      file = "#{args[:original].gsub('.csv', '')}-#{i}.csv"

      File.open(file, 'w') do |f|
        f.write header
      end
      sh "tail -n #{lines - start} #{args[:original]} | head -n #{lines_per_file} >> #{file}"

      start = finish
      generated_files << file
    end

    generated_files
  end
end
