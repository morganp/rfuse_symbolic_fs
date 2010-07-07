require 'optparse'
require 'optparse/time'
require 'ostruct'

class RFuseSymbolicFSOpts


    #
    # Return a structure describing the options.
    #
    def self.parse(args)
      @VERSION = "0.0.1"
      
      # The options specified on the command line will be collected in *options*.
      # We set default values here.
      options = OpenStruct.new
      
      options.verbose = false
      options.mountpoint = ""
      options.input   = ""
       

      opts = OptionParser.new do |opts|
         opts.banner = "Usage: #{__FILE__} [options]"
         opts.separator ""
         opts.separator "Common options:"

         # No argument, shows at tail. This will print an options summary.
         opts.on("-h", "--help", "Show this message") do
            puts opts
            exit
         end

         # Another typical switch to print the version.
         opts.on("--version", "Show version") do
            #puts OptionParser::Version.join('.')
            puts "Version #{@VERSION}"
            exit
         end

         # Boolean switch.
         #opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
         #   options.verbose = v
         #end

         opts.separator ""
         opts.separator "Specific options:"


         # Cast 'delay' argument to a Float.
         opts.on("--mountpoint path", String, "Root of new Filesystem") do |n|
            options.mountpoint = n
         end
         
         opts.on("--input N", String, "Folder FS will point to") do |n|
            options.input = n
         end
         
        
      end
      
      options.leftovers = opts.parse!(args)

      if (options.mountpoint == "") and (options.input == "") and (options.leftovers.size==2)
         options.mountpoint = options.leftovers[0]
         options.input      = options.leftovers[1]
      end
      return options
    end # parse()

  end # class OptparseExample

