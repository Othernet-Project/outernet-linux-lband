Introduction
============

The files that are datacast by Outernet are encoded, modulated, and sent to
several Inmarsat satellites. These satellites transmit the radio waves in the
`L band frequency range <https://en.wikipedia.org/wiki/L_band>`_. The waves are
received by a radio on your receiver and then passed on to the software
demodulator. The demodulator turns the analog signal into bits and then passes
them onto the decoder, which extracts the file information from the data and
reconstructs the files on local storage.

The software components involved in this process are the software demodulator
(sdr100) and the decoder (ondd).

Despite this software coming from a single vendor, they don't come as a
single package for the reasons of flexibility and so that various components
can be replaced by others with same or similar functionality in future. Because
of this, much of this guide is going to be about ensuring that these pieces of
software work together.

.. note::
    Although these pieces of software are all part of the Outernet software
    eco-system, which is predominantly open-source, the demodulator and decoder
    are closed-source freeware.

The relevant license files are installed in ``/usr/local/share/outernet``
folder by the installer.

The software involved in this set-up is meant to be used as long-running
background processes (a.k.a. daemons). Some of the programs already provide
features that let them run as proper well-behaved daemons, while others do not.
We will not discuss daemonizing any of the programs in this guide.
Documentation about command line options will be provided as appropriate, but
daemonization (or conversion into proper system services) is going to be left
to you as an exercise.

In a proper Outernet receiver, there are usually a few more components, like
the web-based user interface software. Since the purpose of such software is to
provide access to files from outside the receiver, they will not be covered in
this guide. It is assumed that, on a regular desktop Linux, user will have
enough options for getting access to files locally.
