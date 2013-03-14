


	// compiler-aware I/O API
	void caf_file_open_(int* unit, char* file_name, int* access, int* ndim, int* dims, int* recl, int* async);
	void caf_file_close_(int *unit);
	void caf_file_read_(int* unit, int* rec_lb, int* rec_ub, int* buf, int* rank , int * count);
	void caf_file_write_(int* unit, int* rec_lb, int* rec_ub, int* buf, int* rank , int * count);

	// support functions
	void caf_set_file_view(int idx, int * rec_lb, int * rec_ub);
	int get_fh_idx(int unit);
