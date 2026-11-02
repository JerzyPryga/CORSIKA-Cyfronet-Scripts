#!/bin/bash 

primary_nr=0
primary_names=("p" "He" "N" "Si" "Fe" "gamma")
prime_ID=(14 402 1407 2814 5626 1)

#E=(1000 1460 2132 3112 4544 6634 10000 14141 22908 37111 60120 100000 157777 291888 539993 1000000 1848130 4000000)
E=(90 125 200 300 500 4000000)
#E=(125 1000 3112 100000 1000000)

#n=(9000 8000 7500 6500 5500 4500 3500 2500 1500 1200 1000 900 450 250 180 60 40 20)
n=(30000 20000 15000 12000 10000 30)
#n=(15000 4000 2000 500 50)
#n=(25000 8000 3000 1000 750 50)

#theta=(0 10 20 30 40 50 60 70)
theta=(0 30 60)

h=(0 100000 200000 300000 400000 500000)

Bpos1=(20.0 9.5 38.1 41.1)
Bpos2=(42.8 -22.6 26.5 1.1)
# [uT]
Bname=("EU" "RPA" "India" "SriLanca")

seed1=9033
seed2=4736

mkdir -p InputsAll
mkdir -p OutputsAll
mkdir -p OUTPUT_slurm/

for ie in {0..5}
do

for it in {0..2}
do

for ih in {0..0}
do

for ib in {0..3}
do

cat > "input_particle_${primary_names[${primary_nr}]}_E_${E[ie]}_theta_${theta[it]}_h_${h[ih]}_seed_${seed1}${seed2}_${Bname[ib]}" << !
RUNNR   ${ie}${it}${ih}                          run number
NSHOW   ${n[ie]}                           number of showers to generate
PRMPAR  ${prime_ID[${primary_nr}]}                       prim. particle (1=gamma, 14=proton, ...)
ESLOPE  -2.7                          slope of primary energy spectrum
ERANGE  ${E[ie]}  ${E[ie]}                    energy range of primary particle (GeV)
THETAP  ${theta[it]}  ${theta[it]}                        range of zenith angle (degree)
PHIP    270. 270.                   range of azimuth angle (degree)SEED    ${seed1}   0   0                      seed for 1. random number sequence
SEED    ${seed2}   0   0                      seed for 2. random number sequence
*THIN    1.E-2  1.E2  0.               thinning definition
*THINH   10.  10.                      relative threshold and weight for hadron thinning
OBSLEV  ${h[ih]}.                            observation level (in cm)
MAGNET  ${Bpos1[ib]}  ${Bpos2[ib]}                    magnetic field centr. Europe
HADFLG  0  0  0  0  0  2              flags hadr.interact.&fragmentation
ECUTS   0.3  0.3  0.003  0.003        energy cuts for particles
MUADDI  F                             additional info for muons
MUMULT  T                             muon multiple scattering angle
ELMFLG  T   T                         em. interaction flags (NKG,EGS)
STEPFC  1.0                           mult. scattering step length fact.
RADNKG  200.E2                        outer radius for NKG lat.dens.distr.
EPOPAR input epos.param             !initialization input file for epos
EPOPAR fname inics epos.inics       !initialization input file for epos
EPOPAR fname iniev epos.iniev       !initialization input file for epos
EPOPAR fname initl epos.initl       !initialization input file for epos
EPOPAR fname inirj epos.inirj       !initialization input file for epos
EPOPAR fname inihy epos.ini1b       !initialization input file for epos
EPOPAR fname check none                !dummy output file for epos
EPOPAR fname histo none                !dummy output file for epos
EPOPAR fname data  none                !dummy output file for epos
EPOPAR fname copy  none                !dummy output file for epos
LONGI   T  10.  F  F                  longit.distr. & step size & fit & outfile
ECTMAP  1.E9                          cut on gamma factor for printout
MAXPRT  1                             max. number of printed events
DIRECT  ./                            output directory
USER    you                           user 
*PAROUT F F                            suppress DAT file
DEBUG   F  6  F  1000000              debug flag and log.unit for out
EXIT                                  terminates input
!

mv *input_* InputsAll/
sbatch corsika.slurm ${primary_names[${primary_nr}]} ${E[ie]} ${n[ie]} ${theta[it]} ${h[ih]} ${seed1} ${seed2} ${Bname[ib]}

done

done

done

done

                                                                                   1,12         Góra
