puts "Hello World!"

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
	Dir.foreach(dir) do |x|
	  next unless (x != "." && x != "..")

	  fp = File.join(dir,x)
	  print "#{fp}"
	  if File.directory?(fp)  then
		puts "\t DIR"
		process_dir fp
	  end

	  next unless (x.match(/.mp4|.jpg|.nfo|.avi|.m4v/))

	  to_file = fp.sub(source_dir,dest_dir)
	  puts "\t FILE --> "  + to_file.to_s

	  end
	end
  end

class Greeting
	attr_accessor :names

	# Create the object
    def initialize(names = "World")
      @names = names
    end

	 # Say hi to everybody
	 def say_hi
	   if @names.nil?
		 puts "..."
	   elsif @names.respond_to?("each")

		 # @names is a list of some kind, iterate!
		 @names.each do |name|
		   puts "Hello #{name}!"
		 end
	   else
		 puts "Hello #{@names}!"
	   end
	 end

	 # Say bye to everybody
	 def say_bye
	   if @names.nil?
		 puts "..."
	   elsif @names.respond_to?("join")
		 # Join the list elements with commas
		 puts "Goodbye #{@names.join(", ")}.  Come back soon!"
	   else
		 puts "Goodbye #{@names}.  Come back soon!"
	   end
	 end

end


g = Greeting.new
g.say_hi
g.say_bye

g.names="Alex"
g.say_hi
g.say_bye

# Change the name to an array of names
g.names = ["Albert", "Brenda", "Charles",
			"Dave", "Englebert"]
g.say_hi
g.say_bye
################## VIDEO COPY ################
begin
	puts "#{ARGV.length} args: " + ARGV.to_s
	exit false unless ARGV.length == 2

	vc = SpecialCopy.new(ARGV[0],ARGV[1])
  	vc.process


#rescue SystemExit
#	puts "Systen Exit: "

end
