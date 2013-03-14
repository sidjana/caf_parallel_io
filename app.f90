

	program compatibility_test
	   include 'caf_io.h'

	   integer*4 :: rank, num_procs 
	   integer*4 :: buff(4)
	      
	   !call MPI_INIT(ierror)
	   rank = this_image()
	   num_procs = num_images()

 	   call caf_file_open(10,"file", CAF_MODE_RDONLY, 3,(/4,4/), 4, 1)
	   !call setup(rank, num_procs) 
	   buff(:) = 0 

	   if (rank == 1) then
	   call caf_file_read(10, (/1,1/), (/2,2/), buff, rank, 4)

	   else if(rank == 2 ) then
	   call caf_file_read(10, (/1,3/), (/2,4/), buff, rank, 4)

	   else if(rank == 3 ) then
	   call caf_file_read(10, (/3,1/), (/4,2/), buff, rank, 4)

	   else if(rank == 4 ) then
	   call caf_file_read(10, (/3,3/), (/4,4/), buff, rank, 4)

	   end if

	   print *, "image", rank , "has", buff(:)

	   call caf_file_close(10)

	   !call MPI_FINALIZE(ierror)

	end program

