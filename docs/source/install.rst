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

Adjusting permissions for of the /var/run folder
------------------------------------------------

The demodulator and decoder software can be run as a non-root user. In addition
to udev rules that the installer creates, you will need to adjust the
permission of the ``/var/run`` (or ``/run`` in most modern distros) folder in
order to run the decoder as a non-root user.

.. note::
    If you'd rather not mess with permissions, you can always run the decoder
    as root.

While there are couple of approaches, the simplest is to give ``/var/run`` (or
``/run``) 777 permissions::

    $ sudo chmod 777 /run /var/run

The more correct way would be to assign your user account's default group to
``/var/run`` (or ``/run``) and give the folder a more conservative set of
permissions::

    $ sudo chown root.$(whoami) /run /var/run
    $ sudo chmod 775 /run /var/run
