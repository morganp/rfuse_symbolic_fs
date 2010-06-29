# fixed_point_spec.rb
require 'amaras_fs'
require 'pp'

# def initialize(number, signed=1, int_bits=12, frac_bits=20, decimal_mark=".")
# to_f float
# to_i integer
# fraction 
# to_fixp fixedpoint
# to_h hex
# to_b binary
#
#
#

$AMARASFS = '/merged'


def clear_and_set_std_structure ( path )
   FileUtils.rm_rf(path)
   FileUtils.mkdir_p(path + $AMARASFS)
   FileUtils.mkdir_p(path + '/A/1')
   FileUtils.mkdir_p(path + '/A/2')
   FileUtils.mkdir_p(path + '/B/3')
   FileUtils.mkdir_p(path + '/B/4')
end

def check_std_structure(path)
   File.symlink?(path + $AMARASFS + '/1').should == true
   File.readlink(path + $AMARASFS + '/1').should == path + '/A/1'
   File.symlink?(path + $AMARASFS + '/2').should == true
   File.readlink(path + $AMARASFS + '/2').should == path + '/A/2'
   File.symlink?(path + $AMARASFS + '/3').should == true
   File.readlink(path + $AMARASFS + '/3').should == path + '/B/3'
   File.symlink?(path + $AMARASFS + '/4').should == true
   File.readlink(path + $AMARASFS + '/4').should == path + '/B/4'
end

describe AmarasFS, "AmarasFS" do
   it "Merge two simple folders" do
      path =  File.expand_path __FILE__ 
      path =  File.dirname(path)
      path =  path + '/tmp'
      puts path

      clear_and_set_std_structure( path )
     
      x = AmarasFS.new((path + $AMARASFS), (path + '/A'), (path + '/B'))

      check_std_structure( path )

   end
   
   it "Merge two simple folders when links partialy exist" do
      path =  File.expand_path __FILE__ 
      path =  File.dirname(path)
      path =  path + '/tmp'
      puts path

      clear_and_set_std_structure( path )
      File.symlink( path +'/A/1', path + $AMARASFS + '/1' )
      x = AmarasFS.new((path + $AMARASFS), (path + '/A'), (path + '/B'))

      check_std_structure( path )

   end


   it "Merge two simple folders, SubFolders already exist" do
      path =  File.expand_path __FILE__ 
      path =  File.dirname(path)
      path =  path + '/tmp'
      puts path

      clear_and_set_std_structure( path )
      #File.symlink( path +'/A/1', path + $AMARASFS + '/1' )
      FileUtils.mkdir_p(path + $AMARASFS)
      FileUtils.mkdir_p(path + $AMARASFS + '/1')
      FileUtils.mkdir_p(path + '/A/1/X')
      FileUtils.mkdir_p(path + '/A/1/Y')
      FileUtils.mkdir_p(path + '/A/2')
      #FileUtils.mkdir_p(path + '/B/1/Z')
      FileUtils.mkdir_p(path + '/B/3')
      FileUtils.mkdir_p(path + '/B/4')

      x = AmarasFS.new((path + $AMARASFS), (path + '/A'), (path + '/B'))

      File.symlink?(path + $AMARASFS + '/1').should   == false
      File.directory?(path + $AMARASFS + '/1').should == true
      File.symlink?(path + $AMARASFS + '/1/X').should == true
      File.symlink?(path + $AMARASFS + '/1/Y').should == true
      #File.symlink?(path + $AMARASFS + '/1/Z').should == true

      File.readlink(path + $AMARASFS + '/1/X').should == path + '/A/1/X'
      File.readlink(path + $AMARASFS + '/1/Y').should == path + '/A/1/Y'
      #File.readlink(path + $AMARASFS + '/1/Z').should == path + '/B/1/Z'

      File.readlink(path + $AMARASFS + '/2').should == path + '/A/2'
      File.symlink?(path + $AMARASFS + '/3').should == true
      File.readlink(path + $AMARASFS + '/3').should == path + '/B/3'
      File.symlink?(path + $AMARASFS + '/4').should == true
      File.readlink(path + $AMARASFS + '/4').should == path + '/B/4' 

   end

   it "Merge two simple folders, deep links already exist" do
      path =  File.expand_path __FILE__ 
      path =  File.dirname(path)
      path =  path + '/tmp'
      puts path
      
      puts 
      puts "First inspection"
      pp Dir.glob(path + '/**/*')

      clear_and_set_std_structure( path )
      puts 
      puts "Second inspection"
      pp Dir.glob(path + '/**/*')

      #File.symlink( path +'/A/1', path + $AMARASFS + '/1' )
      FileUtils.mkdir_p(path + $AMARASFS)
      FileUtils.mkdir_p(path + $AMARASFS + '/1')
      FileUtils.mkdir_p(path + '/A/1/X')
      FileUtils.mkdir_p(path + '/A/1/Y')
      FileUtils.mkdir_p(path + '/A/2')
      FileUtils.mkdir_p(path + '/B/1/Z')
      FileUtils.mkdir_p(path + '/B/3')
      FileUtils.mkdir_p(path + '/B/4')

      puts 
      puts "Third inspection"
      pp Dir.glob(path + '/**/*')


      x = AmarasFS.new((path + $AMARASFS), (path + '/A'), (path + '/B'))

      File.symlink?(path + $AMARASFS + '/1').should   == false
      File.directory?(path + $AMARASFS + '/1').should == true
      File.symlink?(path + $AMARASFS + '/1/X').should == true
      File.symlink?(path + $AMARASFS + '/1/Y').should == true
      File.symlink?(path + $AMARASFS + '/1/Z').should == true

      File.readlink(path + $AMARASFS + '/1/X').should == path + '/A/1/X'
      File.readlink(path + $AMARASFS + '/1/Y').should == path + '/A/1/Y'
      File.readlink(path + $AMARASFS + '/1/Z').should == path + '/B/1/Z'

      File.readlink(path + $AMARASFS + '/2').should == path + '/A/2'
      File.symlink?(path + $AMARASFS + '/3').should == true
      File.readlink(path + $AMARASFS + '/3').should == path + '/B/3'
      File.symlink?(path + $AMARASFS + '/4').should == true
      File.readlink(path + $AMARASFS + '/4').should == path + '/B/4' 

   end


it "Merge two simple folders, Need to handle creating deep links" do
      path =  File.expand_path __FILE__ 
      path =  File.dirname(path)
      path =  path + '/tmp'
      puts path
      
      clear_and_set_std_structure( path )

      #File.symlink( path +'/A/1', path + $AMARASFS + '/1' )
      FileUtils.mkdir_p(path + $AMARASFS)
      #FileUtils.mkdir_p(path + $AMARASFS + '/1') <-- this was the pre created deep link
      FileUtils.mkdir_p(path + '/A/1/X')
      FileUtils.mkdir_p(path + '/A/1/Y')
      FileUtils.mkdir_p(path + '/A/2')
      FileUtils.mkdir_p(path + '/B/1/Z')
      FileUtils.mkdir_p(path + '/B/3')
      FileUtils.mkdir_p(path + '/B/4')

      x = AmarasFS.new((path + $AMARASFS), (path + '/A'), (path + '/B'))

      File.symlink?(path + $AMARASFS + '/1').should   == false
      File.directory?(path + $AMARASFS + '/1').should == true
      File.symlink?(path + $AMARASFS + '/1/X').should == true
      File.symlink?(path + $AMARASFS + '/1/Y').should == true
      File.symlink?(path + $AMARASFS + '/1/Z').should == true

      File.readlink(path + $AMARASFS + '/1/X').should == path + '/A/1/X'
      File.readlink(path + $AMARASFS + '/1/Y').should == path + '/A/1/Y'
      File.readlink(path + $AMARASFS + '/1/Z').should == path + '/B/1/Z'

      File.readlink(path + $AMARASFS + '/2').should == path + '/A/2'
      File.symlink?(path + $AMARASFS + '/3').should == true
      File.readlink(path + $AMARASFS + '/3').should == path + '/B/3'
      File.symlink?(path + $AMARASFS + '/4').should == true
      File.readlink(path + $AMARASFS + '/4').should == path + '/B/4' 

   end



end




