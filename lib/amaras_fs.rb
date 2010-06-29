require 'pp'

class AmarasFS

   def initialize(*args)
      begin
         @root = args[0]
   
         @partitions = Array.new
         (1...(args.size)).each_with_index do |x, index|
            @partitions << args[x]
            #puts args[x]
         end
         
         puts
         puts "Starting Linking"
         @partitions.each do |y|
            build_links( @root, y )         
         end
   
   
   
      rescue => e
         puts
         puts "ERROR caught Exception"
         puts $!
         puts e.inspect
         puts e.backtrace
         puts 
      end
   end


   private

   def build_links( root, y )
         puts "build_links( root, y )"
         puts "build_links( #{root}, #{y})"
      
         files = Dir.glob(y + '/*')

         pp files

         #puts "Iterating of SubFiles"
         files.each do |x|

            #TODO validation that link does not already exist

            new_link = x.dup
            new_link[y] = "" 
            new_link = root + new_link

            puts "Thinking about linking #{new_link} "
            puts " sub file #{x}" 

            #Verify that new_link does not exists
            if not File.exist?( new_link )
               puts "File.symlink(#{x}, #{new_link} )"
               File.symlink(x, new_link)
            elsif ( ( File.symlink?(new_link)) and ( File.readlink(new_link) == x))
               #readlink rasies exception if called on non links so check is a link first
               #Link exists but points to location we tried to set
               puts "INFO   : Link Exists & correct"
            elsif File.directory?(new_link)
               #new_link already exists as folder
               # this implies it already exists on another drive
               # just recurse on this lower level
               puts "Doing recursive call to build links"
               new_root = x.dup
               new_root[y] = "" 
               new_root = root + new_root

               build_links(new_root, x )
            else 
               #Link does exist and points to different Location
               # What could have caused this?
               #  1) Data has been completely moved to another Drive
               #  2) Drive was running out of room and this folder has been split across 2 or more drives
               #
               # To resolve this copy current link location if it exists save location for later
               # Create this folder and link in contnents from new drive then repeat for original location

               puts "ERROR  :#{new_link} already exists"
               puts "       This section requires programming"
            end
         end
   end

end

