#!/bin/bash
run_tests()
{
cd /home/mly/v327/src/ && make && make install && \
cd /home/mly/v327/user_drivers/lagrange_square/ && \
make square0

PRECLIST="0 2" # Doing either exact, lsc amg
WPRECLIST="0" # 0 - Exact, 1 - AMG
NSPRECLIST="0" # 0 - Exact, 1 - LSC
PPRECLIST="0" # Only for LSC, 0 - Exact, 1 - AMG
FPRECLIST="0" # Only for LSC, 0 - Exact, 1 - AMG
VISLIST="Sim"
ANGLIST="30"
RELIST="100"
NOELLIST="6 8"
  

for PREC  in $PRECLIST
do
  case "$PREC" in
    0)
    WPRECLIST="0"
    NSPRECLIST="0"
    ;;
    1)
    WPRECLIST="0"
    NSPRECLIST="1"
    PPRECLIST="0"
    FPRECLIST="0"
    ;;
    2)
    WPRECLIST="0"
    NSPRECLIST="1"
    PPRECLIST="1"
    FPRECLIST="1"
    ;;
    esac
for WPREC in $WPRECLIST 
do
  for NSPREC in $NSPRECLIST
  do
    if [ $NSPREC == 1 ]; then
      for PPREC in $PPRECLIST 
      do
        for FPREC in $FPRECLIST 
        do
          for VIS in $VISLIST
          do
            for ANG in $ANGLIST
            do
              for RE in $RELIST
              do
                for NOEL in $NOELLIST
                do
./square0 --w_solver $WPREC --ns_solver $NSPREC --p_solver $PPREC --f_solver $FPREC --visc $VIS --ang $ANG --rey $RE --noel $NOEL --diagw
./square0 --w_solver $WPREC --ns_solver $NSPREC --p_solver $PPREC --f_solver $FPREC --visc $VIS --ang $ANG --rey $RE --noel $NOEL
                done
              done
            done
          done
        done
      done
    else
      for VIS in $VISLIST 
      do
        for ANG in $ANGLIST
        do
          for RE in $RELIST
          do
            for NOEL in $NOELLIST
            do
./square0 --w_solver $WPREC --ns_solver $NSPREC --visc $VIS --ang $ANG --rey $RE --noel $NOEL --diagw
./square0 --w_solver $WPREC --ns_solver $NSPREC --visc $VIS --ang $ANG --rey $RE --noel $NOEL
            done
          done
        done
      done
    fi
  done
done
done

} # run_tests function

run_tests > ./data/itscmp.dat

egrep "RAYITS" ./data/itscmp.dat > ./data/RAYITS_itscmp.dat
rm -rf ./data/itscmp.dat

diff ./data/RAYITS_itscmp.dat ./data/RAYITS_itscmp_comparer.dat

rm -rf RAYITS_itscmp.dat
