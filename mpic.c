

	#include<mpi.h>
	#include<stdio.h>

	struct unit_map
	{
		int unit;
		MPI_File fhdl;
	
	}map[10];
	int counter=1;

	void caf_file_open(int* unit, char* file_name, int* access, int* ndim, int** dims, int* recl)
	{
		map[counter].unit=unit;
		/*"MPI_MODE_RDONLY" is 2 and "MPI_MODE_WRONLY" is 4*/

		MPI_File_open (MPI_COMM_WORLD, file_name , access ,MPI_INFO_NULL,  &map[counter].fhdl);

	
	}



	void setup_(int* rank, int* size)
	{
	
		int buff[3];
		MPI_File fh;
		MPI_Offset disp=((*rank)-1)*4;
		MPI_Datatype etype, datatype, ftype;
		MPI_File_open (MPI_COMM_WORLD, "file" , MPI_MODE_RDONLY ,MPI_INFO_NULL,  &fh);
		printf("MPI_MODE_RDONLY=%d",MPI_MODE_WRONLY);

		etype = datatype = MPI_INT;

		MPI_Type_vector ( 3, 1, *size, etype, &ftype );
		MPI_Type_commit(&ftype);

		printf("Image %d: disp=%d",*rank,disp);

		MPI_File_set_view (fh, disp,  etype, ftype, "native", MPI_INFO_NULL);

		MPI_File_read (fh, buff, 3, datatype, NULL );

		MPI_File_close(&fh);
		printf("Image %d:\n buff[0]=%d\n buff[1]=%d\n buff[2]=%d\n ", (*rank), buff[0], buff[1], buff[2]);
	
	}
