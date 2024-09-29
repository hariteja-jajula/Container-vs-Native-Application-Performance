#!/bin/bash
#SBATCH --job-name=OSU_Native_2_Tasks               # Job name
#SBATCH --partition=normal                          # Partition
#SBATCH --nodes=2                                   # Number of nodes
#SBATCH --ntasks=2                                  # Number of tasks (MPI processes)
#SBATCH --cpus-per-task=1                           # Number of CPUs per task
#SBATCH --ntasks-per-node=1
#SBATCH --time=24:00:00                             # Time limit
#SBATCH --nodelist=compute003,compute004                       # List the nodes
#SBATCH --output=./log_multinode/log_2_tasks_%j.log           # Output file

# Load necessary modules
module load OpenMPI

# Paths to the OSU Micro-Benchmarks
COLLECTIVE_BENCHMARKS_PATH=/home/hjajula/Container_vs_native/OSU_benchmarks/Data/osu-micro-benchmarks-5.6.3/mpi/collective
ONE_SIDED_BENCHMARKS_PATH=/home/hjajula/Container_vs_native/OSU_benchmarks/Data/osu-micro-benchmarks-5.6.3/mpi/one-sided
PT2PT_BENCHMARKS_PATH=/home/hjajula/Container_vs_native/OSU_benchmarks/Data/osu-micro-benchmarks-5.6.3/mpi/pt2pt

# # Run the benchmarks that require exactly 2 tasks and redirect output to log files
# echo 'Running Point-to-Point Communication Benchmarks with 2 tasks...'
# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $PT2PT_BENCHMARKS_PATH/osu_latency > latency.log 2>&1
# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $PT2PT_BENCHMARKS_PATH/osu_bibw > bibw.log 2>&1
# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $PT2PT_BENCHMARKS_PATH/osu_bw > bw.log 2>&1

# echo 'Running One-Sided Communication Benchmarks with 2 tasks...'
# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $ONE_SIDED_BENCHMARKS_PATH/osu_put_latency > put_latency.log 2>&1
# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $ONE_SIDED_BENCHMARKS_PATH/osu_put_bw > put_bw.log 2>&1
# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $ONE_SIDED_BENCHMARKS_PATH/osu_get_latency > get_latency.log 2>&1
# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $ONE_SIDED_BENCHMARKS_PATH/osu_get_bw > get_bw.log 2>&1
# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $ONE_SIDED_BENCHMARKS_PATH/osu_acc_latency > acc_latency.log 2>&1


mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $PT2PT_BENCHMARKS_PATH/osu_latency

mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 \
singularity exec --bind /home/hjajula/Container_vs_native/OSU_benchmarks/Data/osu-micro-benchmarks-5.6.3/mpi/pt2pt/osu_latency:/usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency \
/home/hjajula/Container_vs_native/multinode_test/container_v4 /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency 


