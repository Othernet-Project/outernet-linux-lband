Troubleshooting
===============

This section contains some common issues and known ways to fix them. Note that
no two machines are exactly the same, and therefore some problems may have more
than one root cause. If a fix listed here does not work for you, please ask for
help in the `Outernet forum <https://discuss.outernet.is/>`_ or, if you've
found a fix, please `file a bug report 
<https://github.com/Outernet-Project/outernet-linux-lband/issues>`_.

Unable to load config: /etc/ondd.conf
-------------------------------------

This is normal, and you shouldn't worry about it. If you sill see issues, they
are most likely not related to this message.

error while loading shared libraries: libncurses.so.5
-----------------------------------------------------

If you see this, your distro probably has a newer version of libncurse
installed. First find out what version of libncurses your distro has::

    $ ls -1 /usr/lib/libncurses*
    /usr/lib/libncurses.so
    /usr/lib/libncurses++.so
    /usr/lib/libncurses++w.so
    /usr/lib/libncursesw.so
    /usr/lib/libncurses++w.so.6
    /usr/lib/libncursesw.so.6
    /usr/lib/libncurses++w.so.6.0
    /usr/lib/libncursesw.so.6.0

In this case, we are dealing with version 6, so we make two symlinks::

    $ sudo ln -s /usr/lib/libncursesw.so.6.0 /usr/lib/libncurses.so.5
    $ sudo ln -s /usr/lib/libncursesw.so.6.0 /usr/lib/libtinfo.so.5

After this, the program should run normally.

/usr/lib/....: no version information available
-----------------------------------------------

This is normal for some Linux distros, and should not cause any issues. If you
are still having some problem, it is more likely *not* because of this warning
message.

Kernel driver is active, or device is claimed...
------------------------------------------------

You probably need to blacklist the ``dvb_usb_rtl28xxu`` driver. Please search
online for instructions on how to blacklist modules on your distro.

No sdr devices found
--------------------

Your shoudl plug in your RTL-SDR dongle. If it is already plugged in, it may
not be working correctly or may not have enough power.
