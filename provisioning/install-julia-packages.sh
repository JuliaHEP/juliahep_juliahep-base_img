#/bin/bash
set -e

JL_EXE="$1"
JL_REF_ENV="$2"
JL_ENV_NAME=`basename "$JL_REF_ENV"`

JL_LOCAL_DIR=`julia -e 'println(first(filter(p -> !startswith(p, homedir()), DEPOT_PATH)))'`

export JULIA_DEPOT_PATH="${JL_LOCAL_DIR}:"
# Same real path as symlink:
# export JULIA_DEPOT_PATH="/opt/julia-local/share/julia:"

export JULIA_PKG_PRESERVE_TIERED_INSTALLED="true"

DEFAULT_NUM_THREADS=`lscpu -p | grep '^[0-9]\+,[0-9]\+,[0-9]\+,0,' | cut -d ',' -f 2 | sort | uniq | wc -l`
export JULIA_NUM_THREADS="${DEFAULT_NUM_THREADS}"
export OPENBLAS_NUM_THREADS="${DEFAULT_NUM_THREADS}"
export OMP_NUM_THREADS="${DEFAULT_NUM_THREADS}"
export GKSwstype="nul"

"${JL_EXE}" -e 'import Pkg; Pkg.Registry.add("General"); Pkg.Registry.add(url = "https://github.com/legend-exp/LegendJuliaRegistry.git")'

JL_ENVDIR=$(dirname $(dirname `"${JL_EXE}" -e 'import Pkg; println(Pkg.project().path)'`))
export JULIA_PROJECT="${JL_ENVDIR}/$JL_ENV_NAME"

mkdir -p "${JULIA_PROJECT}"
cp -a "$JL_REF_ENV"/*.toml "${JULIA_PROJECT}"/
chown -R root:root "${JULIA_PROJECT}"

"${JL_EXE}" -e 'import Pkg; Pkg.instantiate()'

unset JULIA_PROJECT
export JULIA_PROJECT=$(dirname `"${JL_EXE}" -e 'import Pkg; println(Pkg.project().path)'`)
mkdir -p "${JULIA_PROJECT}"
"${JL_EXE}" -e 'import Pkg; Pkg.add(["Revise", "IJulia", "Pluto"]); Pkg.build("IJulia")'
rm "${JL_LOCAL_DIR}/logs/manifest_usage.toml"
chmod -R go+rX  "${JL_LOCAL_DIR}"

# Revise precompilation result stores path "/opt/julia-VERSION/share/julia",
# and Revise complains if containers image is unpacked to a different path
# and Julia run directly, e.g. from CVMFS. So remove Revise precompilation
# from image:
rm -rf "$JL_LOCAL_DIR"/compiled/*/Revise
