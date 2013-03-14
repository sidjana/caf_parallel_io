
	#include<mpi.h>
	#include<caf_rtl_io.h>

	#define MAX_DIM 15
	#define MAX_FILE_CNT 10 

	struct 
	{
		int unit;
		MPI_File fhdl;
		int access; 
		int ndim; 
		int *dims;
		int async;
		MPI_Datatype etype;
	}map[MAX_FILE_CNT];

	int counter=0;

	// Note: ndims has a val 1 more than the actual num of dim. This is to allow the third dim to grow
	void caf_file_open_(int* unit, char* file_name, int* access, int* ndim, int* dims, int* recl, int* async)
	{
		map[counter].unit = *unit;
		/*For OpenMPI, "MPI_MODE_RDONLY" is 2 and "MPI_MODE_WRONLY" is 4*/
		map[counter].access = *access;
		map[counter].ndim = *ndim;
		map[counter].dims = dims;
		map[counter].async = *async;

		MPI_Type_contiguous(*recl, MPI_BYTE, &(map[counter].etype));
		MPI_Type_commit(&(map[counter].etype));
		MPI_File_open(MPI_COMM_WORLD, file_name , *access , MPI_INFO_NULL,  &(map[counter].fhdl));

		counter++;
	}


	void caf_file_close_(int *unit)
	{
		int idx=get_fh_idx(*unit);
		MPI_File_close(&(map[idx].fhdl));
	}


	//TODO: add support for non-unit stride along each dimension
	void caf_file_read_(int* unit, int* rec_lb, int* rec_ub, int* buf, int* rank , int * count)
	{
		MPI_Status status;
		int idx=get_fh_idx(*unit);

		caf_set_file_view(idx, rec_lb, rec_ub);

		MPI_File_read_all(map[idx].fhdl, buf, *count,
		                      map[idx].etype, &status);
	
	}


	//TODO: add support for non-unit stride along each dimension
	void caf_file_write_(int* unit, int* rec_lb, int* rec_ub, int* buf, int* rank , int * count)
	{
		MPI_Status status;
		int idx=get_fh_idx(*unit);

		caf_set_file_view(idx, rec_lb, rec_ub);

		MPI_File_write_all(map[idx].fhdl, buf, *count,
		                      map[idx].etype, &status);
	
	}


	void caf_set_file_view(int idx, int * rec_lb, int * rec_ub)
	{
		int subsizes[MAX_DIM];
		int i;
		MPI_Datatype ftype;

		for (i = 0 ; i < map[idx].ndim-1; i++)
		{
	           subsizes[i] = rec_ub[i]-rec_lb[i] + 1;
		   rec_lb[i]--; // 0-shift adjustment
		}

           	MPI_Type_create_subarray(map[idx].ndim-1, map[idx].dims, subsizes,
      				         rec_lb, MPI_ORDER_FORTRAN, map[idx].etype,
                			 &ftype);
		MPI_Type_commit(&ftype);
		MPI_File_set_view(map[idx].fhdl, 0, map[idx].etype,
			         ftype, "native", MPI_INFO_NULL);
	}


	int get_fh_idx(int unit)
	{
		int i;
		for (i = 0 ; i < counter; i++) 
		{
			if (map[i].unit == unit )
			return i; 
		}
		return -1;
	}


