require "rubygems"
require 'fusefs'
require 'rfuse_symbolic_fs_opts'


class RFuseSymbolicFS
   # contents( path )
   # file?( path )
   # directory?( path )
   # read_file( path )
   # size( path )
   # 
   # save
   # touch( path )
   # can_write?(path)
   # write_to(path,body)
   # 
   # can_delete?(path)
   # delete( path )
   #
   # can_mkdir?( path )
   # mkdir( path )
   # can_rmdir( path )
   # rmdir( path )
   # 



   def initialize( options )
      @base_dir = options.input
   end

   def contents(path)
      n_path = File.expand_path( @base_dir + path )
      Dir.chdir(n_path)  

      files = Dir.glob('*')
      #Added command to OS X Finder not to index.
      files << 'metadata_never_index'

      return files
   end
  
   def file?(path)
      #If path ends with metadata_never_index it is a file
      if path =~ /metadata_never_index$/
         return true
      end

      return (not File.directory?( @base_dir + path ))
   end

   def directory?(path)
      File.directory?(@base_dir + path)
   end
  
   def read_file(path)
      
      #puts "read file #{path}"
      if File.exists?( @base_dir + path )
         return File.new(@base_dir + path , "r").read
      end
      return "ERROR, file not found\n"

   end


   def size(path)
      if File.exists?( @base_dir + path )
         return File.size( @base_dir + path )
      else
         return 16
      end
   end
end


if $0 == __FILE__

   options = RFuseSymbolicFSOpts.parse(ARGV)
   filesystem = RFuseSymbolicFS.new( options )
   FuseFS.set_root( filesystem )

   # Mount under a directory given on the command line.
   FuseFS.mount_under options.mountpoint
   FuseFS.run
end

