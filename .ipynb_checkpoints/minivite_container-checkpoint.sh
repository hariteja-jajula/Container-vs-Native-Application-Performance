#!/bin/bash
#SBATCH --job-name=miniVite_Performance_Test         # Job name
#SBATCH --partition=normal                           # Partition
#SBATCH --nodes=2                                    # Number of nodes
#SBATCH --ntasks=40                                  # Number of tasks (MPI processes)
#SBATCH --cpus-per-task=1                            # Number of CPUs per task
#SBATCH --ntasks-per-node=20                         # Tasks per node (adjust based on node capacity)
#SBATCH --time=24:00:00                              # Time limit
#SBATCH --nodelist=compute003,compute004             # List of nodes
#SBATCH --output=./log_multinode/miniVite_%j.log     # Output file

# Load necessary modules (adjust as needed)
module load OpenMPI/4.1.6-GCC-13.2.0

# **Container Execution Command**
mpirun --mca pml ucx --mca btl_openib_allow_ib true \
       --mca btl_openib_if_include mlx4_0:1 --mca btl ^tcp \
       -np 40 \
       singularity exec --bind /home/hjajula/Container_vs_native/MiniVite/miniVite/:/mnt/minivite/ \
       /home/hjajula/Container_vs_native/Minivite_container/minivite \
       /home/hjajula/Container_vs_native/MiniVite/miniVite/miniVite -f /mnt/minivite/neuron_16384.bin \
       > miniVite_container.log 2>&1



# **Native Execution Command**
# Uncomment the following lines to run natively instead of inside the container

# mpirun --mca pml ucx --mca btl_openib_allow_ib true \
#        --mca btl_openib_if_include mlx4_0:1 --mca btl ^tcp \
#        -np 80 \
#        /home/hjajula/Container_vs_native/MiniVite/miniVite/miniVite \
#        -f /home/hjajula/Container_vs_native/MiniVite/miniVite/neuron_16384.bin \
#        > miniVite_native.log 2>&1
