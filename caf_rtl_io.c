
	#include<mpi.h>
	#include<caf_rtl_io.h>
	#include<stdio.h>

	#define MAX_DIM 15
	#define MAX_FILE_CNT 10  // Tolerate upto 10 file OPEN operations

	struct FILE_INFO 
	{
		int unit;
		MPI_File fhdl;
		int access; 
		int ndim; 
		int *dims;
		int async;
		MPI_Datatype etype;
		int recl;
	}map[MAX_FILE_CNT];

	int counter=0;

	// Note: ndim has a val 1 more than the actual num of dim. This is to allow the third dim to grow
	void caf_file_open_(int* unit, char* file_name, int* access, int* ndim, int* dims, int* recl, int* async)
	{
		map[counter].unit = *unit;
		/*For OpenMPI, "MPI_MODE_RDONLY" is 2 and "MPI_MODE_WRONLY" is 4*/
		map[counter].access = *access;
		map[counter].ndim = *ndim;
		map[counter].dims = dims;
		map[counter].async = *async;
		map[counter].recl = *recl;

		MPI_Type_contiguous(*recl, MPI_BYTE, &(map[counter].etype));
		MPI_Type_commit(&(map[counter].etype));
		MPI_File_open(MPI_COMM_WORLD, file_name , *access , MPI_INFO_NULL,  &(map[counter].fhdl));

		//TODO: handling dynamic opening and closing of files (add a linked list)
		counter++;
	}


	void caf_file_close_(int *unit)
	{
		int idx=get_fh_idx(*unit);
		MPI_File_close(&(map[idx].fhdl));
	}


	//non-strided operations
	//TODO: add support for non-unit stride along each dimension
	void caf_file_read_(int* unit, int* rec_lb, int* rec_ub, int* buf, int* rank , int * len)
	{
		MPI_Status status;
		int idx=get_fh_idx(*unit);

		caf_set_file_view(idx, rec_lb, rec_ub);

		MPI_File_read_all(map[idx].fhdl, buf, *len,
		                      map[idx].etype, &status);
	
	}


	//TODO: add support for non-unit stride along each dimension
	void caf_file_write_(int* unit, int* rec_lb, int* rec_ub, int* buf, int* rank , int * len)
	{
		MPI_Status status;
		int idx=get_fh_idx(*unit);

		caf_set_file_view(idx, rec_lb, rec_ub);

		MPI_File_write_all(map[idx].fhdl, buf, *len,
		                      map[idx].etype, &status);
	
	}



	// strided operations
	void caf_file_read_str_(int* unit, int* rec_lb, int* rec_ub, int* str, int* buf, int* rank , int * len)
	{
		int idx=get_fh_idx(*unit);
		MPI_Status status;

		int blklens[3];
		MPI_Aint indices[3];
		MPI_Datatype old_types[3];
		MPI_Datatype etype = map[idx].etype, vtype, stype;
		int extent, offset=0, disp= map[idx].recl;
		int lb, ub, count, i;

		for (i = 0 ; i < map[idx].ndim-1 ; i++)
		{
		
			lb = rec_lb[i]-1; 
			ub = rec_ub[i]-1;

			if (i>0)
		        {	disp = disp*map[idx].dims[i-1];
			}
			offset = disp*lb;
			extent = disp * (map[idx].dims[i]);
			
			count = (int)((ub-lb+1)/str[i]);
			if(str[i] != 1)
			{count++;
			}
			printf("%d, disp:%d,off:%d,ext:%d,cnt:%d\n",i,disp, offset, extent,count);
			
			
			MPI_Type_vector(count, 1, str[i], etype, &vtype);
			MPI_Type_commit(&vtype);

			blklens[0] = 1;
			old_types[0] = MPI_LB;
			indices[0] = 0;

			blklens[1] = 1;
			old_types[1] = vtype;
			indices[1] = offset;

			blklens[2] = 1;
			old_types[2] = MPI_UB;
			indices[2] = extent;

			MPI_Type_struct(3, blklens, indices, old_types, &stype);
			MPI_Type_commit(&stype);

			etype = stype;
		}
		MPI_Type_commit(&stype);

		MPI_File_set_view(map[idx].fhdl, 0, map[idx].etype,
			         stype, "native", MPI_INFO_NULL);

		MPI_File_read_all(map[idx].fhdl, buf, *len,
		                      map[idx].etype, &status);
	}



	// support functions
	void caf_set_file_view(int idx, int* rec_lb, int* rec_ub)
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
		for (i = counter-1; i >= 0; i++) 
		{
			if (map[i].unit == unit )
			return i; 
		}
		return -1;
	}


