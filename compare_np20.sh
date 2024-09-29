#!/bin/bash
#SBATCH --job-name=OSU_Collective_40_Tasks          # Job name
#SBATCH --partition=normal                          # Partition
#SBATCH --nodes=3                                   # Number of nodes
#SBATCH --ntasks=120                                 # Number of tasks (MPI processes)
#SBATCH --cpus-per-task=1                           # Number of CPUs per task
##SBATCH --ntasks-per-node=40                        # Number of tasks per node
#SBATCH --time=24:00:00                             # Time limit
##SBATCH --nodelist=compute003            # List the nodes
#SBATCH --output=./log_multinode/collective_40_tasks_%j.log # Output file

# Load necessary modules
module load OpenMPI/4.1.6-GCC-13.2.0

# Paths to the OSU Micro-Benchmarks (Collective)
COLLECTIVE_BENCHMARKS_PATH=/home/hjajula/Container_vs_native/OSU_benchmarks/Data/osu-micro-benchmarks-5.6.3/mpi/collective
CONTAINER_PATH=/home/hjajula/Container_vs_native/multinode_test/container_v4
CONTAINER_EXEC="singularity exec --bind $COLLECTIVE_BENCHMARKS_PATH:/usr/local/libexec/osu-micro-benchmarks/mpi/collective"
ONE_SIDED_BENCHMARKS_PATH=/home/hjajula/Container_vs_native/OSU_benchmarks/Data/osu-micro-benchmarks-5.6.3/mpi/one-sided

# ----------------------
# Native Collective Benchmarks
# ----------------------

echo 'Running Collective Communication Benchmarks with 40 tasks (Native)...'
mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 $COLLECTIVE_BENCHMARKS_PATH/osu_allgather > allgather_native.log 2>&1
mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 $COLLECTIVE_BENCHMARKS_PATH/osu_allreduce > allreduce_native.log 2>&1
mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 $COLLECTIVE_BENCHMARKS_PATH/osu_alltoall > alltoall_native.log 2>&1
mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 $COLLECTIVE_BENCHMARKS_PATH/osu_gather > gather_native.log 2>&1
mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 $COLLECTIVE_BENCHMARKS_PATH/osu_scatter > scatter_native.log 2>&1

# mpirun for missing one-sided tests with 2 tasks
mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 $ONE_SIDED_BENCHMARKS_PATH/osu_fop_latency > fop_latency_native.log 2>&1
mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 $ONE_SIDED_BENCHMARKS_PATH/osu_cas_latency > cas_latency_native.log 2>&1
mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 $ONE_SIDED_BENCHMARKS_PATH/osu_get_acc_latency > get_acc_latency_native.log 2>&1
mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 $ONE_SIDED_BENCHMARKS_PATH/osu_get_bw > get_bw_native.log 2>&1
mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 $ONE_SIDED_BENCHMARKS_PATH/osu_put_bibw > put_bibw_native.log 2>&1

# ----------------------
# Container Collective Benchmarks
# ----------------------

echo 'Running Collective Communication Benchmarks with 120 tasks (Container)...'
mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 \
$CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allgather > allgather_container.log 2>&1

mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 \
$CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce > allreduce_container.log 2>&1

mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 \
$CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_alltoall > alltoall_container.log 2>&1

mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 \
$CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_gather > gather_container.log 2>&1

mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 \
$CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_scatter > scatter_container.log 2>&1

# mpirun for missing collective tests with 120 tasks (Container)
mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 \
$CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_barrier > barrier_container.log 2>&1

mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 \
$CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_bcast > bcast_container.log 2>&1

mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 \
$CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_reduce_scatter > reduce_scatter_container.log 2>&1

mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 \
$CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_ibarrier > ibarrier_container.log 2>&1

mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 \
$CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_ibcast > ibcast_container.log 2>&1

mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 \
$CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_ireduce > ireduce_container.log 2>&1

mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 120 \
$CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_iscatter > iscatter_container.log 2>&1



echo "All collective benchmarks (Native and Container) completed."

# ----------------------
# Comparison Function for Collective Benchmarks
# ----------------------

# Generalized function to compare latency results and calculate overhead
compare_latency_overhead() {
    local test_name="$1"          # Test name
    local native_log="$2"         # Native log file path
    local container_log="$3"      # Container log file path
    local comparison_output="$4"  # Output comparison log file

    # Ensure both log files exist
    if [[ ! -f "$native_log" || ! -f "$container_log" ]]; then
        echo "One or both of the log files for $test_name do not exist."
        return 1
    fi

    # Extract relevant benchmark output data from both logs
    native_latencies=$(grep -Eo "[0-9]+\.[0-9]+" "$native_log")
    container_latencies=$(grep -Eo "[0-9]+\.[0-9]+" "$container_log")

    # Check if both logs have the same number of latency values
    native_count=$(echo "$native_latencies" | wc -l)
    container_count=$(echo "$container_latencies" | wc -l)

    if [[ "$native_count" -ne "$container_count" ]]; then
        echo "The number of latencies in the two logs for $test_name does not match."
        return 1
    fi

    # Initialize comparison output
    echo "Comparison for $test_name between Native and Container OSU Collective Benchmark" > "$comparison_output"
    echo "-------------------------------------------------------------------------" >> "$comparison_output"
    echo -e "Size\tNative Latency (us)\tContainer Latency (us)\tOverhead (%)" >> "$comparison_output"

    # Convert latencies to arrays
    native_array=($native_latencies)
    container_array=($container_latencies)

    # Iterate over the latencies and compute overhead
    for i in "${!native_array[@]}"; do
        native_latency=${native_array[$i]}
        container_latency=${container_array[$i]}
        
        if [[ $(echo "$native_latency > 0" | bc -l) -eq 1 ]]; then
            overhead=$(echo "scale=2; (($container_latency - $native_latency) / $native_latency) * 100" | bc -l)
        else
            overhead="N/A"
        fi

        # Log the comparison result
        echo -e "$i\t$native_latency\t\t$container_latency\t\t$overhead%" >> "$comparison_output"
    done

    echo "Comparison complete for $test_name. Results saved to $comparison_output"
}

# # Call the function to compare different collective tests
compare_latency_overhead "osu_allgather" "allgather_native.log" "allgather_container.log" "comparison_allgather.log"
compare_latency_overhead "osu_allreduce" "allreduce_native.log" "allreduce_container.log" "comparison_allreduce.log"
compare_latency_overhead "osu_alltoall" "alltoall_native.log" "alltoall_container.log" "comparison_alltoall.log"
compare_latency_overhead "osu_gather" "gather_native.log" "gather_container.log" "comparison_gather.log"
compare_latency_overhead "osu_scatter" "scatter_native.log" "scatter_container.log" "comparison_scatter.log"
# Call to compare function for collective benchmarks
compare_latency_overhead "osu_barrier" "barrier_native.log" "barrier_container.log" "comparison_barrier.log"
compare_latency_overhead "osu_bcast" "bcast_native.log" "bcast_container.log" "comparison_bcast.log"
compare_latency_overhead "osu_reduce_scatter" "reduce_scatter_native.log" "reduce_scatter_container.log" "comparison_reduce_scatter.log"
compare_latency_overhead "osu_ibarrier" "ibarrier_native.log" "ibarrier_container.log" "comparison_ibarrier.log"
compare_latency_overhead "osu_ibcast" "ibcast_native.log" "ibcast_container.log" "comparison_ibcast.log"
compare_latency_overhead "osu_ireduce" "ireduce_native.log" "ireduce_container.log" "comparison_ireduce.log"
compare_latency_overhead "osu_iscatter" "iscatter_native.log" "iscatter_container.log" "comparison_iscatter.log"



echo "All comparisons for collective benchmarks completed."
