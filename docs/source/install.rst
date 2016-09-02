Software installation
=====================

In this section, we will install all the necessary software and ensure the
system is prepared to run it. The next section will discuss the programs'
usage.

Installing the softtware
------------------------

Download the `Outernet demodulator/decoder kit
<https://github.com/Outernet-Project/outernet-linux-lband/archive/master.tar.gz>`_
and untar it::

    $ wget https://github.com/Outernet-Project/outernet-linux-lband/archive/master.tar.gz -O outernet.tar.gz
    $ tar xvf outernet.tar.gz

To install::

    $ cd outernet-linux-lband-master
    $ sudo ./installer.sh

During installation, you will be asked to decide whether you wish to configure
udev. By default, access to the SDR dongles is restricted to root. The udev
rules relax these rules so that any user can acess them.

You will also be asked to create the temporary download folder as well as the
download folder. The temporary download folder is used to store incomplete
downloads, while the download folder is the final destination for the
downloaded files. You can chose to create these folders later by youself, or
have the installer create them (default). 

.. warning::
    If the installer is asked to create the download folders, the created
    folders will be world-writable (any user will have read-write access to
    them).
