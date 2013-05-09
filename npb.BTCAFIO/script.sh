

for BM in  bt
do
	for CLASS in W A B C
	do

  		       NPROCS_LST="9";

  		  for NP in  $NPROCS_LST
  		  do

		  NPROCS=$NP
		  make clean
		  make BT NPROCS=$NP CLASS=$CLASS SUBTYPE=full

		  done
		  done
		  done

