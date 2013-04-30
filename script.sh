#!/bin/bash

OUTPUT_DIR=./logs
mkdir -p $OUTPUT_DIR


for file in `ls *.f90`; do

	uhcaf -O3 caf_rtl_io.o $file  rtc.o  -ftpp -DINNER -DXMAX_=1000 -DZMAX_=500 -I/opt/openmpi/gnu/1.6.3/include -pthread -I/opt/openmpi/gnu/1.6.3/lib -Wl,-rpath -Wl,/opt/openmpi/gnu/1.6.3/lib -L/opt/openmpi/gnu/1.6.3/lib -lmpi_f90 -lmpi_f77 -lmpi -ldl -lm -lnuma -Wl,--export-dynamic -lrt -lnsl -lutil -lm -ldl	
	
        echo "$file" | tee  $OUTPUT_DIR/$file.out
        echo "NPROCS  IO  Total  %age" | tee -a  $OUTPUT_DIR/$file.out

	for nprocs in 2 4 6 8 10 12 14 16; do
		cafrun -n $nprocs ./a.out | tee -a $OUTPUT_DIR/$file.out
	done
done
