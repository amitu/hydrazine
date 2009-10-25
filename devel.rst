Development related notes.
==========================

The development steps after the scripts are ready:

requires on developer machine: apt-cacher-ng, schroot, debootstrap.

(host) $ svn co svn+ssh://nfs/home/public/svn/ami/trunk hydrazine
(host) $ cd hydrazine
(host) $ # work work
(host) $ ./build
(host) $ sudo ./prepare_mbox
(mbox) $ ./init_mbox
(mbox) $ ./test_mbox
(mbox) if errors, tinker tinker
(mbox) $ ./test_mbox
(mbox) no errors!
(mbox) ^D
(host) $ # incorporate result of the tinker tinker, and do more work
(host) $ # repeat the above process, and if things are fine, svn ci

For iterative development, where build step woud be run multiple times, the
following flow may be used:

(host) $ cd hydrazine
(host) $ # work
(host) $ ./build -p # build, delete and prepare mbox
(mbox) $ ./init_mbox -t # init and test


~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

My Development Setup, I have the following in ~/p/matchbox:

* ami       -- svn+ssh://nfs/home/public/svn/ami/trunk  [1]
* mbox      -- to be used for building new ubuntu
* ubuntu-8.04-server-i386.iso   -- ubuntu hardy

For consistency, *ami* is the trunk for our svn checkout. *mbox* is the name
of chroot.

**basic setup**

* install packages
* add schroot config file

**to create a fresh mbox**

* go to ~/p/matchbox
* sudo mount -o loop ubuntu-8.04-server-i386.iso ubuntu_mount/
* sudo debootstrap --variant=buildd --arch i386 hardy /home/amitu/p/matchbox/mbox/ file:///home/amitu/p/matchbox/ubuntu_mount
* sudo chroot mbox/
* apt-get install gnupg
* apt-get update
* apt-get upgrade
* apt-get install ubuntu-minimal language-pack-en
* setup sudo, really required? we shud have as little as possible here. i am thinking there should be script to do this step, and then a script to then prep the real install. infact we can put this things in real install only.

**to use the mbox**

* schroot -c mbox

The ideal setup: 
===============

* sudo do_once: a script that will install debootstrap etc and set /etc file, based on current user and current directory. convenction is as defined above.
* sudo create_mbox: mounts iso, creates mbox, copies our matchbox script across, schroots us in
* matchbox: to be run from inside mbox, does everything else

TODO: is it possible that we keep on gathering all the deb files that it installs, so that we can speedup the process?


[1]: My ~/.ssh/config contains::

    Host nfs
        Hostname ssh.phx.nearlyfreespeech.net
        User amitu_zero

Debootstrap Setup
=================

We are going to use debootstrap:

* http://www.debian-administration.org/articles/426
* https://help.ubuntu.com/community/BasicChroot
* https://wiki.ubuntu.com/DebootstrapChroot

**Basic setup**

A nice way to deal with chroot environments is the schroot utility. The
assumption here is that our chroots will be managed only via schroot. This
allows us to leave a lot of things like mounting /proc, copying
/etc/resolv.conf, /etc/hosts, /etc/passwd etc to schroot.

To set up a hardy chroot environment inside /home/ami :

* install debootstrap and schroot::

    sudo aptitude install debootstrap schroot

* bootstrap a bare bones debian system::

    sudo debootstrap --variant=buildd --arch i386 hardy /home/ami \
         http://archive.ubuntu.com/ubuntu/

* After that's done, set up schroot. Add the following section to your
  ``/etc/schroot/schroot.conf``::

    [hardy]
    description=Ubuntu Hardy
    location=/home/ami
    priority=1
    users=gera
    groups=users
    root-groups=admin
    aliases=ami
    run-setup-scripts=true
    run-exec-scripts=true

  Here, replace ``gera`` with your username on the host system. Adjust the
  groups if you want to. The ``root-users`` and ``root-groups`` are the users
  and groups which are allowed to chroot to this without a password.

* chroot into it, *without using schroot*. This is just to install the updates
  and required packages.::

    sudo chroot /home/ami

* install updates. Doing an ``apt-get update`` will give you an error about
  ``gpgv``, so first do a ``apt-get install gnupg``, then an ``apt-get
  update`` followed by an ``apt-get upgrade``.

* install a minimal system. This can be done by a simple ``apt-get install
  ubuntu-minimal``. Then, install the locale/language packs to fix the
  language warnings, via ``apt-get install language-pack-en``.

* install ``sudo`` and copy the sudoers file from your host system into the
  chroot. Or, you can edit the chroot's sudoers from your host system (``sudo
  visudo -f /home/ami/etc/sudoers``).

* chroot into your new chroot::

    schroot -c ami

  Note that we are using the alias (``ami``) for our chroot called ``hardy``.


