# OpenBSD + Electron

<p align="center">
    <img src=".readme/openbsd-electron.png" alt="OpenBSD + Electron logo" width="256"/>
</p>

An effort to port electron (and thus VScode) on OpenBSD.
It comes with customs modnpm and modyarn modules.

Status : Working, need some more cleaning.

## Electron

Electron is based on Chromium, thus we share all features with this port.
We have OpenBSD support for pledge, unveil and are working on a per application design.

Electron is installed only once on the system and all applications have to support this version.
We do not build distfiles, and we do not bundle Electron in each application (we could).
Each application has its wrapper to start Electron properly with it's configuration and resources.

Fuses are a subject we are working on, we want sensible defaults for all applications.

## Node package manager in ports

When it comes to node package manager, there aren't a lot of options.

* use a pre-made cache to work offline, someone has to distribute this archive
* fill the cache before extract, some tool has to be able to insert into the cache 
* extract directly into node_modules, that should be the package manager job and is tricky

We think the best solution is to fill the cache before extract.

* Yarn : works well with a simple, flat, directory cache
* Npm : use cacache and also repository API, not only package module
* Pnpm : todo
* Berry : to study

Each package manager implements a *lock* file describing all depends and the *node_modules* shape.
Thus, port-modules have to parse this file in order to generate a *modules.inc* file.

* moyarn : fill the cache during extract, limited support for Electron ports only
* modnpm : setup node_modules, lightly tested on different kinds of ports

Our plan is to implement a **cache add** cli for each package manager in hope this could be upstream.

## Main app 

* VScode : everythings seems to works **without sandboxing**, kerberos support not tested
* teams-for-linux : screen share, webcam, audio tested ok
* signal-desktop : screen share, webcam, audio tested ok
* stretchly : ok
* byar-chobby : ok
