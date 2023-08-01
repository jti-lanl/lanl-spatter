# Modules for
#   Platform: Darwin
#   Partition: sapphire-rapids
#              sapphire-rapids-hbm
#

module purge

# gcc >= 11.x to generate AVX-512 instructions in spatter/openmp/ompenmp_kernel.c

# module load cmake/3.26.3 gcc/12.2.0  openmpi/4.1.5-gcc_12.2.0
module load cmake gcc/11.2.0 openmpi/3.1.6-gcc_11.2.0
