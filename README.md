# OpenBSD + Electron

<p align="center">
    <img src=".readme/openbsd-electron.png" alt="OpenBSD + Electron logo" width="256"/>
</p>

An effort to port Electron (and, by extension, VS Code) to OpenBSD.  
It includes custom `modnpm` and `modyarn` modules to facilitate the integration of Node-based ports.

***Status : Working**, need some more cleaning.*

## Electron

Electron is built on Chromium, utilizing the same patches and features as the current port.
The implementation includes OpenBSD-specific support for pledge and unveil, with a per-application design.

Electron is installed system-wide with a single installation, and applications should be compatible with this shared version.
Instead of creating distfiles or bundling Electron with individual applications (though technically feasible), each application 
includes a dedicated wrapper to properly initialize Electron with its specific configuration and resources.

*Efforts are underway to implement [fuses](https://www.electronjs.org/docs/latest/tutorial/fuses) support with a single, sensible default.*

## Node packages managers

To avoid network usage during the build process, the available options are quite limited:

* Using a pre-made cache for offline functionality, which requires someone to distribute the archive
* Filling the cache before the extraction phase, necessitating a tool to populate the cache
* Extracting directly into node_modules, which should be the package manager's job and is complex to implement

*The most viable solution seems to fill the cache before extraction.*

* `yarn`: works well with a simple, flat, directory cache
* `npm`: use cacache and also repository API, not only package module
* `pnpm`: todo
* `berry`: to study

Each package manager generates a lock file that describes all dependencies and the structure of `node_modules`.  
The `port-modules` tool parses these lock files to produce a `modules.inc` file.

* `moyarn`: fill the cache during extract, limited support for Electron ports only
* `modnpm`: setup node_modules, lightly tested on different kinds of ports

*The plan is to implement a `cache-add` CLI for each package manager, aiming for upstream adoption.*

## Ports included

* VScode : everythings seems to works **without sandboxing**, kerberos support not tested
* teams-for-linux : screen share, webcam, audio tested ok
* signal-desktop : screen share, webcam, audio tested ok
* stretchly : ok
* byar-chobby : ok
