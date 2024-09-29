#!/bin/bash
#SBATCH --job-name=OSU_Native_2_Tasks               # Job name
#SBATCH --partition=normal                          # Partition
#SBATCH --nodes=1                                   # Number of nodes
#SBATCH --ntasks=2                                  # Number of tasks (MPI processes)
#SBATCH --cpus-per-task=1                           # Number of CPUs per task
##SBATCH --ntasks-per-node=1
#SBATCH --time=24:00:00                             # Time limit
#SBATCH --nodelist=compute003           # List the nodes
#SBATCH --output=./log_multinode/log_2_tasks_%j.log # Output file

# Load necessary modules
module load OpenMPI/4.1.6-GCC-13.2.0

# Paths to the OSU Micro-Benchmarks
COLLECTIVE_BENCHMARKS_PATH=/home/hjajula/Container_vs_native/OSU_benchmarks/Data/osu-micro-benchmarks-5.6.3/mpi/collective
ONE_SIDED_BENCHMARKS_PATH=/home/hjajula/Container_vs_native/OSU_benchmarks/Data/osu-micro-benchmarks-5.6.3/mpi/one-sided
PT2PT_BENCHMARKS_PATH=/home/hjajula/Container_vs_native/OSU_benchmarks/Data/osu-micro-benchmarks-5.6.3/mpi/pt2pt

CONTAINER_PATH=/home/hjajula/Container_vs_native/multinode_test/container_v4
CONTAINER_EXEC="singularity exec --bind $PT2PT_BENCHMARKS_PATH:/usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt"

# ----------------------
# Native Benchmarks
# ----------------------

# Running Point-to-Point Communication Benchmarks with 2 tasks (Native)
echo 'Running Point-to-Point Communication Benchmarks with 2 tasks (Native)...'
# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $PT2PT_BENCHMARKS_PATH/osu_latency > latency_native.log 2>&1

# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $PT2PT_BENCHMARKS_PATH/osu_bibw > bibw_native.log 2>&1
# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $PT2PT_BENCHMARKS_PATH/osu_bw > bw_native.log 2>&1

# # Running One-Sided Communication Benchmarks with 2 tasks (Native)
# echo 'Running One-Sided Communication Benchmarks with 2 tasks (Native)...'
# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $ONE_SIDED_BENCHMARKS_PATH/osu_put_latency > put_latency_native.log 2>&1
# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $ONE_SIDED_BENCHMARKS_PATH/osu_put_bw > put_bw_native.log 2>&1
# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $ONE_SIDED_BENCHMARKS_PATH/osu_get_latency > get_latency_native.log 2>&1
# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $ONE_SIDED_BENCHMARKS_PATH/osu_get_bw > get_bw_native.log 2>&1

# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 $ONE_SIDED_BENCHMARKS_PATH/osu_acc_latency > acc_latency_native.log 2>&1


# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 \
# --mca btl ^tcp --mca btl_base_verbose 100 --mca pml_ucx_verbose 1 --mca btl_openib_verbose 100 -np 2 \
# $PT2PT_BENCHMARKS_PATH/osu_latency > latency_native.log 2> verbose_native.log





# ----------------------
# Container Benchmarks
# ----------------------

# Running Point-to-Point Communication Benchmarks with 2 tasks (Container)
echo 'Running Point-to-Point Communication Benchmarks with 2 tasks (Container)...'
mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 \
$CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency > latency_container.log 2>&1

# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 \
# $CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bibw > bibw_container.log 2>&1

# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 \
# $CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw > bw_container.log 2>&1

# # Running One-Sided Communication Benchmarks with 2 tasks (Container)
# echo 'Running One-Sided Communication Benchmarks with 2 tasks (Container)...'
# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 \
# $CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/one-sided/osu_put_latency > put_latency_container.log 2>&1

# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 \
# $CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/one-sided/osu_put_bw > put_bw_container.log 2>&1

# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 \
# $CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/one-sided/osu_get_latency > get_latency_container.log 2>&1

# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 \
# $CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/one-sided/osu_get_bw > get_bw_container.log 2>&1

# mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 -np 2 \
# $CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/one-sided/osu_acc_latency > acc_latency_container.log 2>&1



# # mpirun --mca pml ucx --mca btl_openib_allow_ib true --mca btl_openib_if_include mlx4_0:1 \
# # --mca btl ^tcp --mca btl_base_verbose 100 --mca pml_ucx_verbose 1 -np 2 \
# # $CONTAINER_EXEC $CONTAINER_PATH /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency > latency_container.log 2> verbose_container.log





# echo "All benchmarks (Native and Container) completed."

# # ----------------------
# # Comparison Function
# # ----------------------

# # Generalized function to compare latency results and calculate overhead
# compare_latency_overhead() {
#     local test_name="$1"          # Test name
#     local native_log="$2"         # Native log file path
#     local container_log="$3"      # Container log file path
#     local comparison_output="$4"  # Output comparison log file

#     # Ensure both log files exist
#     if [[ ! -f "$native_log" || ! -f "$container_log" ]]; then
#         echo "One or both of the log files for $test_name do not exist."
#         return 1
#     fi

#     # Extract relevant benchmark output data from both logs
#     native_latencies=$(grep -Eo "[0-9]+\.[0-9]+" "$native_log")
#     container_latencies=$(grep -Eo "[0-9]+\.[0-9]+" "$container_log")

#     # Check if both logs have the same number of latency values
#     native_count=$(echo "$native_latencies" | wc -l)
#     container_count=$(echo "$container_latencies" | wc -l)

#     if [[ "$native_count" -ne "$container_count" ]]; then
#         echo "The number of latencies in the two logs for $test_name does not match."
#         return 1
#     fi

#     # Initialize comparison output
#     echo "Comparison for $test_name between Native and Container OSU Latency Test" > "$comparison_output"
#     echo "----------------------------------------------------------------------" >> "$comparison_output"
#     echo -e "Size\tNative Latency (us)\tContainer Latency (us)\tOverhead (%)" >> "$comparison_output"

#     # Convert latencies to arrays
#     native_array=($native_latencies)
#     container_array=($container_latencies)

#     # Iterate over the latencies and compute overhead
#     for i in "${!native_array[@]}"; do
#         native_latency=${native_array[$i]}
#         container_latency=${container_array[$i]}
        
#         if [[ $(echo "$native_latency > 0" | bc -l) -eq 1 ]]; then
#             overhead=$(echo "scale=2; (($container_latency - $native_latency) / $native_latency) * 100" | bc -l)
#         else
#             overhead="N/A"
#         fi

#         # Log the comparison result
#         echo -e "$i\t$native_latency\t\t$container_latency\t\t$overhead%" >> "$comparison_output"
#     done

#     echo "Comparison complete for $test_name. Results saved to $comparison_output"
# }

# # Call the function to compare different tests
# compare_latency_overhead "osu_latency" "latency_native.log" "latency_container.log" "comparison_latency.log"
# compare_latency_overhead "osu_bibw" "bibw_native.log" "bibw_container.log" "comparison_bibw.log"
# compare_latency_overhead "osu_bw" "bw_native.log" "bw_container.log" "comparison_bw.log"
# compare_latency_overhead "osu_put_latency" "put_latency_native.log" "put_latency_container.log" "comparison_put_latency.log"
# compare_latency_overhead "osu_put_bw" "put_bw_native.log" "put_bw_container.log" "comparison_put_bw.log"
# compare_latency_overhead "osu_get_latency" "get_latency_native.log" "get_latency_container.log" "comparison_get_latency.log"
# compare_latency_overhead "osu_get_bw" "get_bw_native.log" "get_bw_container.log" "comparison_get_bw.log"
# # compare_latency_overhead "osu_acc_latency" "acc_latency_native.log" "acc_latency_container.log" "comparison_acc_latency.log"

# echo "All comparisons completed."
