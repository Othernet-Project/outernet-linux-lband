Software installation
=====================

In this section, we will install all the necessary software and ensure the
system is prepared to run it. The next section will discuss the programs'
usage.

Download locations
------------------

Before we begin, we need to decide on where to put the downloaded files. There
are two directories where files will be stored:

- temporary cache directory for unfinished downloads
- permanent directory for finished downloads

In this guide, we will use ``/var/spool/ondd`` for temporary download cache,
and ``/srv/downloads`` for finished downloads. Whether you go with these or
some other locations, it is recommended you write them down for future
reference.

You can always specify these paths when starting the decoder, but if you don't
want to keep remembering the command line options, it's easier to set the
environment variables::

    $ echo 'ONDD_DATA="/srv/downloads"' | sudo tee -a /etc/profile
    $ echo 'ONDD_CACHE="/var/spool/ondd"' | sudo tee -a /etc/profile

An alternative is to create an alias::

    $ alias decoder='/usr/local/bin/decoder -o /srv/downloads -c /var/spool/ondd'

Add the above command to your ``~/.bashrc`` or whatever your shell starup
file is. 

Regardless of what method you end up using, you'll be able to run the decoder
without extra arguments once it's installed.

Installing the build tools
--------------------------

The library used by the demodulator will need to be built on your machine, so
build tools will need to be installed. On most distros, the build tools usually
come as a single package/metapackage that are named build-essential,
base-devel, and similar name. Additionally pkg-config and development headers
for libusb 1.0 should also be installed.

Here are some ways to install them on different distros.

Ubuntu/Debian and derivatives::

    $ sudo apt-get install build-essential pkg-config libusb-1.0-0-dev

Fedora::

    $ sudo yum groupinstall "Development Tools" "Development Libraries"
    $ sudo yum install libusb1 pkgconfig

Arch Linux::

    $ sudo pacman -Sy base-devel pkg-config libusb

Opensuse::

    $ sudo zypper install --type pattern devel_basis
    $ sudo zypper install pkg-config libusb-1_0

Installing StarSDR
------------------

Download `StarSDR sources
<https://github.com/Outernet-Project/StarSDR/archive/master.tar.gz>`_ and untar
it. ::

    $ wget https://github.com/Outernet-Project/StarSDR/archive/master.tar.gz -O starsdr.tar.gz
    $ tar xvf starsdr.tar.gz

To compile and install::

    $ cd StarSDR-master
    $ make installables
    $ sudo make install

.. note::
    To uninstall, run ``sudo make uninstall`` from the ``StarSDR-master``
    directory. You don't have to keep the original directory around to do this,
    though. You can always untar a new tarball and uninstall.

StarSDR libraries are installed in ``/usr/local/sdr.d`` by default. The library
supports RTL-SDR radios as well as the Mirics ones. These will be automatically
selected depending on what radio you have, so normally you don't need to do
anything yourself.

Installing the demodulator and decoder
--------------------------------------

Download the `Outernet demodulator/decoder kit
<https://github.com/Outernet-Project/outernet-linux-lband/archive/master.tar.gz>`_
and untar it::

    $ wget https://github.com/Outernet-Project/outernet-linux-lband/archive/master.tar.gz -O outernet.tar.gz
    $ tar xvf outernet.tar.gz

To install::

    $ cd outernet-linux-lband-master
    $ sudo ./installer.sh install


