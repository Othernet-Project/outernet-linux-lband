---------------------------------
Outernet L-band for desktop Linux
---------------------------------

These files are used to build Outernet L-band receivers using a desktop Linux
distribution. Currently only 64-bit Linux is supported.

Full guide is here:

    http://outernet-l-band-on-linux.readthedocs.io

Installing
----------

To install:

    $ sudo installer.sh install

Default installation is in /usr/local. To Change this:

    $ sudo PREFIX=/your/path installer.sh install

Uninstalling
------------

To uninstall:

    $ sudo installer.sh uninstall

If you installed to a custom location:

    $ sudo PREFIX=/your/path installer.sh uninstall

Documentation
-------------

Documentation is available at:

    outernet-l-band-on-linux.readthedocs.io

Licenses
--------

By using any portion of this repository, you are bound by the licenses found in
this repository.

The binary files closed-source are released under the proprietary freeware
licenses:

* sdr100* - see SDR100_LICENSE.txt
* ondd* - see ONDD_LICENSE.txt

The scripts in the repository including any example scripts found in the
documentation folder are released under GNU GPL version 3 or any later
version. See COPYING for more information.

The documentation, except example scripts found in the docs directory, is
released under GNU FDL version 1.3 or any later version.  See COPYING.docs for
more information.
