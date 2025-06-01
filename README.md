# JuliaHEP base container image

Container build specification for
[`registry.cern.ch/juliahep/juliahep-base`](https://registry.cern.ch/harbor/projects/3833/repositories/juliahep-base/).

This container image is part of the [JuliaHEP](https://www.juliahep.org/)
effort. It contains pretty much all depencencies that Julia HEP
related packages require, but includes only a few HEP-related packages
themselves (mostly packages with binary dependencies like Geant4).

As the JuliaHEP ecosystem is still evolving rapidly, most HEP software
packages are left out to be installed by the user. This way, users can easily
access the latest HEP-related package versions. Installing those packages,
which sit near the top of the depencency tree, does not require large disk
space or a very large number of files, and so is easily possible also on
networked and size-limited personal directories.

The [`hep-base`](environments/hep-base/Project.toml) Julia environment defines
the set of preinstalled packages.

Users can use

```
pkg> activate @hep-base
```

to activate the `hep-base` environment, which contains all preinstalled
packages, but is a read-only part of the container image (no additional
packages can be added to it).

However, users can also create their own Julia environments and still take
advantage of the preinstalled packages: This container image sets
[`JULIA_PKG_PRESERVE_TIERED_INSTALLED=true`](https://pkgdocs.julialang.org/v1/api/#Pkg.add).
So installation of additional packages should automatically use the
pre-installed dependencies as much as possible, instead of installing
the lastest version of each dependency.

This image is built on top of
[`registry.cern.ch/juliahep/juliahep-core`](https://github.com/JuliaHEP/juliahep_juliahep-core_img).
