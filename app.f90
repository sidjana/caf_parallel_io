

	program compatibility_test
	   include 'caf_io.h'

	   integer*4 :: rank, num_procs 
	   integer*4 :: buff(12)
	      
	   !call MPI_INIT(ierror)
	   rank = this_image()
	   num_procs = num_images()

 	   call caf_file_open(10,"test_file", CAF_MODE_RDONLY, 3,(/3,3/), 4, 1)
	   buff(:) = -1 

	   if (rank == 1) then
	   call caf_file_read_str(10, (/2,2,1/), (/2,3,3/), (/1,1,2/), buff, 4)
	   !call caf_file_read(10, (/2,2/), (/3,3/), buff, 4)

	   else if(rank == 2 ) then
	   call caf_file_read_str(10, (/1,1,1/), (/3,3,3/), (/2,2,2/), buff, 8)
	   !!call caf_file_read(10, (/1,3/), (/2,4/), buff, 4)

	   else if(rank == 3 ) then
	   call caf_file_read_str(10, (/1,2,2/), (/3,3,3/), (/2,1,1/), buff, 8)
	   !!call caf_file_read(10, (/3,1/), (/4,2/), buff, 4)

	   else if(rank == 4 ) then
	   call caf_file_read_str(10, (/2,3,1/), (/3,3,3/), (/1,1,1/), buff, 6)
	   !!call caf_file_read(10, (/3,3/), (/4,4/), buff, 4)

	   end if

	   print *, "image", rank , "has", buff(:)

	   call caf_file_close(10)

	   !call MPI_FINALIZE(ierror)

	end program

