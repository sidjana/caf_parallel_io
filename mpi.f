

	program mpi_test
	   !include 'mpif.h'

	   integer*4 :: rank, num_procs 
	      
	   !call MPI_INIT(ierror)
	   rank = this_image()
	   num_procs = num_images()

	   call setup(rank, num_procs) 

	   !call MPI_FINALIZE(ierror)

	end program
