rfuse_symbolic_fs
=================

Relies on rfuse (latest 0.7.0) gem.

This mounts the file system to the first Argument and the second Argument is the location to 'link to'.
This filesystem is similar to a symbolic link but is an example of most methods available in rfuse.

    $ mkdir ~/tmp_fs
    $ rfuse_symbolic_fs ~/tmp_fs ~/Movies


