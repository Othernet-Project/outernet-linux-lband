================================
Outernet L-band on Linux desktop
================================

This guide demonstrates the process of installing and running the 0uternet SDR
demodulator and decoder software on a desktop Linux operating system. As of
this writing, only 64-bit versions of Linux are supported. 32-bit version are
in the works.

As part of the software repository, a Vagrantfile is provided for use with
`Vagrant <http://vagrantup.com/>`_ and `VirtualBox
<https://www.virtualbox.org/>`_. This file can be used to (automatically)
install and run all the required software on any computer that supports
VirtualBox (including Windows and OSX).

.. warning::
    This guide is a work in progress and may contain wrong and/or incomplete
    information. Please use the `issue tracker 
    <https://github.com/Outernet-Project/outernet-linux-lband/issues>`_ or 
    `our forums <https://discuss.outernet.is>`_ to discuss any problems you
    encounter.

==========  ===================================================================
version     1.0a8
status      unstable/draft
==========  ===================================================================

Licenses
========

The binary files closed-source are released under the proprietary freeware
licenses:

- ``sdr100*`` - see `SDR100_LICENSE.txt
  <https://raw.githubusercontent.com/Outernet-Project/outernet-linux-lband/master/SDR100_LICENSE.txt>`_
- ``ondd*`` - see `ONDD_LICENSE.txt
  <https://raw.githubusercontent.com/Outernet-Project/outernet-linux-lband/master/ONDD_LICENSE.txt>`_

The scripts in the repository including any example scripts found in the
documentation folder are released under GNU GPL version 3 or any later
version. See COPYING for more information, or visit the `GPL homepage
<https://www.gnu.org/licenses/gpl.html>`_.

The documentation, except example scripts found in the docs directory, is
released under GNU FDL version 1.3 or any later version.  See COPYING.docs for
more information, or visit the `FDL homepage
<https://www.gnu.org/licenses/fdl.html>`_.


Guide contents
==============

.. toctree::
    :maxdepth: 2

    requirements
    intro
    virtual
    install
    running
    troubleshooting
