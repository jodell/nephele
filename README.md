Nephele
========
Nephele is a thin administration layer around major cloud service API's.  Its main goals are simplicity and a unified command line interface for common tasks.

Planned support
----------------
* Rackspace
* EC2

Setting Your Credentials
------------------------
Currently, Nephele expects environment variables to set your service keys.

    RACKSPACE_KEY=your_api_key
    RACKSPACE_USER=your_user_name
    NEPHELE_SERVICE_DEFAULT=rackspace

Examples
--------
Here's an example of someone inspecting available images and flavors on a Rackspace account, deciding to create and save various 'foo' images based on roles and recipes from joeuser's chef git repo:

    neph images | grep lucid

    neph flavors | grep 512

    neph create foo 'Ubuntu 10.04 LTS (lucid)' '512 server'

    neph create foo 'Ubuntu 10.04 LTS (lucid)' '512 server'

    neph bootstrap foo 'Ubuntu 10.04 LTS (lucid)' '512 server' -r webserver -c git@github.com:joeuser/cookbooks.git

    neph save foo lucid-webserver

    neph restrap foo lucid-webserver '512 server' -r webserver-prod -c git@github.com:joeuser/cookbooks.git

    neph save foo 'lucid-webserver-prod'

    neph destroy foo

Usage
-----
Example usage at time of writing:

<pre>
$ neph --help
Commands

list                                             # Display a list of servers
images                                           # Display available images
flavors                                          # List available flavors
status                                           # Display server status
create [name] [image] [flavor]                   # Creates a node with name, image name, flavor
  -C/--count=[NUMERIC]                           # create foo, foo2, foo3, ...
save [nodename] [savename]                       # Save an image of the node
destroy [name]                                   # Destroy a given node
password [node] [password]                       # Change a password on given node
delete [image]                                   # Delete an image
bootstrap [name] [image] [flavor]                # Create a VM and run a chef bootstrapper, optional recipe, bootstrap, cookbooks args
restrap [name] [image] [flavor]                  # Destroy and bootstrap
archive [name] [image] [flavor] [savename]       # Boostrap a VM and save an image of it

Global options

-c/--cookbooks=[STRING]                          # optional cookbooks URI
-p/--personality=[STRING]                        # comma-separated tuple of contents,targetfile to be placed at startup
-b/--bootstrap=[STRING]                          # optional bootstrapper URI, defaults to https://github.com/jodell/cookbooks/raw/master/bin/bootstrap.sh
-r/--recipe=[STRING]                             # run this recipe after bootstrapping
-v/--vpn-credential-file=[STRING]                # specify a vpnpass file to seed the target vm
-P/--prestrap=[STRING]                           # Executes a command or the contents of a file on a VM prior to bootstrapping
-?/--help                                        # Print help message
</pre>

LICENSE
-------
SEE LICENSE

Other Interesting Projects
--------------------------
* Fog - https://github.com/geemus/fog
* EC2 DSL - https://github.com/auser/poolparty
