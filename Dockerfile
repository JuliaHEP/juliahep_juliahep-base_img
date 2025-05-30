FROM registry.cern.ch/juliahep/juliahep-core:latest

# Install Julia packages:

COPY provisioning/install-julia-packages.sh provisioning/
COPY environments/hep-base/*.toml environments/hep-base/

ENV JULIA_PKG_PRESERVE_TIERED_INSTALLED="true"

RUN provisioning/install-julia-packages.sh environments/hep-base
