#!/bin/bash
#SBATCH --job-name="shw"
#SBATCH --partition=plgrid
#SBATCH --nodes=1
#SBATCH --tasks-per-node=1
#SBATCH --time=24:00:00
#SBATCH --mem=32000
#SBATCH -A plgcredosim2025-cpu
#SBATCH --mail-user=jerzy.pryga@doktorant.up.krakow.pl
#SBATCH --mail-type=FAIL
#SBATCH --chdir="/net/pr2/projects/plgrid/plggcredo/JPryga/Sims/corsika-77100/run"
#SBATCH --output=OUTPUT_slurm/slurm-%j.o
#SBATCH --error=OUTPUT_slurm/slurm-%j.e

primary=$1
E=$2
n=$3
theta=$4
h=$5
seed=$6$7
B=$8

# load ROOT env
export ROOTSYS=/net/pr2/projects/plgrid/plggcredo/SPS_DGORA/root/root_v5.34.21.source/root
export PATH=$ROOTSYS/bin:$PATH
export LD_LIBRARY_PATH=$ROOTSYS/lib:$LD_LIBRARY_PATH
# add PATH to apptainer container
C7SIF=/net/software/testing/containers/centos7-dev.sif

SIMDIR=/net/pr2/projects/plgrid/plggcredo/JPryga/Sims/corsika-77100/run
SCRATCHDIR=$SCRATCH/particle_${primary}_E_${E}_theta_${theta}_h_${h}_seed_${seed}_${B}
RESULTDIR=/net/pr2/projects/plgrid/plggcredo/JPryga/Analysis/SimulationsNew

mkdir -p ${RESULTDIR}/${primary}/E_${E}/out_text_files
mkdir -p ${RESULTDIR}/${primary}/E_${E}/Theta_${theta}_h_${h}

rm -rf ${SCRATCHDIR}
mkdir -p ${SCRATCHDIR}

cp ${SIMDIR}/* ${SCRATCHDIR}

cd ${SCRATCHDIR}

apptainer run -B /net,${TMP}:/tmp --env LD_LIBRARY_PATH=$LD_LIBRARY_PATH --env PATH=$PATH $C7SIF  ./corsika77100Linux_EPOS_urqmd_root<${SIMDIR}/InputsAll/input_particle_${primary}_E_${E}_theta_${theta}_h_${h}_seed_${seed}_${B}>${SIMDIR}/OutputsAll/output_particle_${primary}_E_${E}_theta_${theta}_h_${h}_seed_${seed}_${B}.txt

module add root/6.24.06-foss-2021b

FILE=shw_particle_${primary}_E_${E}_theta_${theta}_h_${h}_n_${n}_seed_${seed}_${B}.root
hadd -f -k ${FILE} *.root
#mv *.root ${FILE}

if [ -s "$FILE" ];
then
        mv ${FILE} ${RESULTDIR}/${primary}/E_${E}/Theta_${theta}_h_${h}
        mv ${SIMDIR}/OutputsAll/*.txt ${RESULTDIR}/${primary}/E_${E}/out_text_files
fi

rm -rf ${SCRATCHDIR}

