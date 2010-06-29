require 'pp'

class AmarasFS

   def initialize(*args)
      start_time = Time.now
      begin
         @root = args[0]
   
         @partitions = Array.new
         (1...(args.size)).each_with_index do |x, index|
            @partitions << args[x]
            #puts args[x]
         end
         puts
         puts

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
      puts "Run Time #{start_time - Time.now}"

   end


   private

   def build_links( root, y , spacer=' ')
         #puts "build_links( root, y )"
         puts "#{spacer}build_links( #{root}, #{y})"
      
         files = Dir.glob(y + '/*')

         pp files

         #puts "Iterating of SubFiles"
         files.each do |x|

            #TODO validation that link does not already exist

            new_link = x.dup
            new_link[y] = "" 
            new_link = root + new_link

            puts 
            puts "#{spacer}Thinking about linking #{new_link} "
            #puts " sub file #{x}" 

            #Verify that new_link does not exists
            if not File.exist?( new_link )
               puts "#{spacer}Mode :1 INFO   : File.symlink(#{x}, #{new_link} )"
               File.symlink(x, new_link)

            elsif ( ( File.symlink?(new_link)) and ( File.readlink(new_link) == x))
               #readlink rasies exception if called on non links so check is a link first
               #Link exists but points to location we tried to set
               puts "#{spacer}Mode :2 INFO   : Link Exists & correct"
            elsif ( ( File.symlink?(new_link)) and  ( not File.readlink(new_link) == x ))
               test_folder(new_link)
               
               puts "#{spacer}Mode :3 ERROR   : #{new_link} already exists"
               puts "#{spacer}                  This section requires programming"
               
               current_pointer =  File.readlink(new_link)
               
               puts "current_pointer #{current_pointer}"
               puts "                #{root}"
               puts "                #{x}"
               puts "                #{y}"
               
               pos = current_pointer.rindex(File::SEPARATOR)
               extra_bit = current_pointer[pos...(current_pointer.size)]

               puts "extra_bit #{extra_bit}"

               #/A/1/x
               #/A/1/Y
               #/B/1/z
               #
               # current_pointer = /A/1

               #current pointer already has the extra_bit
               new_root                = root + extra_bit               
               next_pointer            = x    + extra_bit
             
               puts "File Maintenance"

               FileUtils.rm(    new_root )
               FileUtils.mkdir( new_root )
               
               build_links(new_root , x, spacer+' ')
               build_links(new_root , current_pointer, spacer+' ')


            elsif File.directory?(new_link)
               #new_link already exists as folder
               # this implies it already exists on another drive
               # just recurse on this lower level
               puts "#{spacer}Mode :4 INFO   : Doing recursive call to build links"

               

               new_root = x.dup
               new_root[y] = "" 
               new_root = root + new_root

               build_links(new_root, x, spacer+' ' )
            else 
               #Link does exist and points to different Location
               # What could have caused this?
               #  1) Data has been completely moved to another Drive
               #  2) Drive was running out of room and this folder has been split across 2 or more drives
               #
               # To resolve this copy current link location if it exists save location for later
               # Create this folder and link in contnents from new drive then repeat for original location

               puts "#{spacer}Mode :5 ERROR   : #{new_link} already exists"
               puts "#{spacer}                  This section requires programming"
            end
         end
   end


   def test_folder(path)
      puts "File    #{File.file?(path)}"
      puts "Folder  #{File.directory?(path)}"
      puts "Symlink #{File.symlink?(path)}"
   end

end

