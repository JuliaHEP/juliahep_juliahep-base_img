FROM registry.cern.ch/juliahep/juliahep-core:latest

# Install Julia packages:

COPY provisioning/install-julia-packages.sh provisioning/
COPY environments/hep-base/*.toml environments/hep-base/

ENV \
    JULIA_CPU_TARGET="generic;sandybridge,-xsaveopt,clone_all;haswell,-rdrnd,base(1);x86-64-v4,-rdrnd,base(1)" \
    JULIA_PKG_PRESERVE_TIERED_INSTALLED="true"

RUN true \
    && echo "export JULIA_CPU_TARGET=\"$JULIA_CPU_TARGET\"" >> /unpacked/env.sh \
    && echo "export JULIA_PKG_PRESERVE_TIERED_INSTALLED=\"$JULIA_PKG_PRESERVE_TIERED_INSTALLED\"" >> /unpacked/env.sh \
    && provisioning/install-julia-packages.sh julia environments/hep-base \
    true

# Set unpacked image name:
COPY provisioning/unpacked/image-name /unpacked/image-name
RUN chmod 644 /unpacked/image-name
