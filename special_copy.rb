require 'fileutils'


# Copy all converted video files, but no DVD/BD files
class SpecialCopy
  attr_accessor :source_dir, :dest_dir

  def initialize(source_dir, dest_dir)
    self.source_dir = source_dir
	self.dest_dir = dest_dir
  end

  def process
	puts "Coping all video files from \"#{source_dir}\" to \"#{dest_dir}\" ..."
	process_dir source_dir
  end

  private
  def process_dir(dir)
	puts "====> Processing dir " + dir
	Dir.foreach(dir) do |x|
	  next unless (x != "." && x != "..")

	  from_file = File.join(dir,x)
	  print from_file
	  if File.directory?(from_file)  then
		puts "\t DIR"
		process_dir from_file
		puts "<== DONE with " + from_file
		next
	  end

	  if x.match(/.mp4|.jpg|.nfo|.avi|.m4v/).nil? then
		puts "\t --> IGNORED"
		next
	  end

	  to_file = from_file.sub(source_dir,dest_dir)
	  puts "\t FILE --> "  + to_file.to_s + " Size: " + File.size(from_file).to_s

	  copy from_file,to_file
	end

  rescue => e
	p "Exception caught:" + e.message
	p e.backtrace.join("\n")
	p e.inspect

  end

  def copy(from_file, to_file)

	if File.exist?(to_file) then
	  to_file_time = File.ctime(to_file)
	  from_file_time = File.ctime(from_file)
	  to_file_size = File.size(to_file)
	  from_file_size = File.size(from_file)

	  puts "FILE EXISTS: #{to_file}, Size #{to_file_size} bytes, Date #{to_file_time}"
	  puts "OVERWRITE WITH: #{from_file} Size #{from_file_size} bytes, Date #{from_file_time}"
	  if (to_file_size != from_file_size) then
		puts "SOURCE AND TARGET FILES ARE DIFFERENT --> OVERWRITING"
	  else
		puts "Files are same size --> IGNORED"
		return
	  end
	end
	to_dir = File.dirname(to_file)
	FileUtils.mkpath to_dir
	FileUtils.copy(from_file,to_file, :preserve => true)

  rescue => e
	p e.message
	p e.backtrace.join("\n")
	p e.inspect


  end

end

################## VIDEO COPY ################
begin
	puts "#{ARGV.length} args: " + ARGV.to_s
	if ARGV.length != 2 then
	  puts "Usage: special_copy from_dir to_dir"
	  exit false
	end

	sc = SpecialCopy.new(ARGV[0],ARGV[1])
  	sc.process

end
