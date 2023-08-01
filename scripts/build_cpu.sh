#!/bin/bash

echo ${HOMEDIR}
source ${HOMEDIR}/scripts/cpu_config.sh

cd ${HOMEDIR}
source ${MODULEFILE}


# define C_FLAGS for cmake, to maximize vectorization
CMAKE_C_FLAGS="-march=native"
UNAME=`uname -m`
if [[ "$UNAME" == "x86_64" ]]; then
    VWIDTH=`${HOMEDIR}/scripts/host_details.sh -w`
    CMAKE_C_FLAGS+=" -mprefer-vector-width=$VWIDTH"
fi


cd spatter

rm -rf build_omp_mpi_gnu/*

cmake -DBACKEND=openmp -DCOMPILER=gnu -DUSE_MPI=1 -B build_omp_mpi_gnu -S . \
      -DCMAKE_C_FLAGS="$CMAKE_C_FLAGS"

cd build_omp_mpi_gnu
make -j

