#/bin/bash
set -e

JL_REF_ENV="$1"
JL_ENV_NAME=`basename "$JL_REF_ENV"`

export JULIA_DEPOT_PATH="/opt/julia/local/share/julia:" 
export JULIA_PKG_PRESERVE_TIERED_INSTALLED="true"

DEFAULT_NUM_THREADS=`lscpu -p | grep '^[0-9]\+,[0-9]\+,[0-9]\+,0,' | cut -d ',' -f 2 | sort | uniq | wc -l`
export JULIA_NUM_THREADS="${DEFAULT_NUM_THREADS}"
export OPENBLAS_NUM_THREADS="${DEFAULT_NUM_THREADS}"
export OMP_NUM_THREADS="${DEFAULT_NUM_THREADS}"
export GKSwstype="nul"

julia -e 'import Pkg; Pkg.Registry.add("General"); Pkg.Registry.add(url = "https://github.com/legend-exp/LegendJuliaRegistry.git")'

JL_ENVDIR=$(dirname $(dirname `julia -e 'import Pkg; println(Pkg.project().path)'`))
export JULIA_PROJECT="${JL_ENVDIR}/$JL_ENV_NAME"

mkdir -p "${JULIA_PROJECT}"
cp -a "$JL_REF_ENV"/*.toml "${JULIA_PROJECT}"/
chown -R root:root "${JULIA_PROJECT}"

julia -e 'import Pkg; Pkg.instantiate()'

unset JULIA_PROJECT
export JULIA_PROJECT=$(dirname `julia -e 'import Pkg; println(Pkg.project().path)'`)
mkdir -p "${JULIA_PROJECT}"
julia -e 'import Pkg; Pkg.add(["Revise", "IJulia", "Pluto"]); Pkg.build("IJulia")'
rm /opt/julia/local/share/julia/logs/manifest_usage.toml
# rm -rf /opt/julia/local/share/julia/logs
chmod -R go+rX  "/opt/julia/local/share/julia"
