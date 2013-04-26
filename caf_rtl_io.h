/*
 Header file for runtime library interfaces for Parallel I/O

 Copyright (C) 2009-2012 University of Houston.

 This program is free software; you can redistribute it and/or modify it
 under the terms of version 2 of the GNU General Public License as
 published by the Free Software Foundation.

 This program is distributed in the hope that it would be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 Further, this software is distributed without any warranty that it is
 free of the rightful claim of any third person regarding infringement
 or the like.  Any license provided herein, whether implied or
 otherwise, applies only to this software file.  Patent licenses, if
 any, provided herein do not apply to combinations of this program with
 other software, or any other product whatsoever.

 You should have received a copy of the GNU General Public License along
 with this program; if not, write the Free Software Foundation, Inc., 59
 Temple Place - Suite 330, Boston MA 02111-1307, USA.

 Contact information:
 http://www.cs.uh.edu/~hpctools
*/


	// open/close
	void caf_file_open_(int* unit, char* file_name, int* access, int* ndim, int* dims, int* recl, int* async);
	void caf_file_close_(int *unit);
	void caf_file_delete_(char* file_nm);


	/**** non-strided operations ****/
	void caf_file_read_(int* unit, int* rec_lb, int* rec_ub, int* buf, int * len);
	void caf_file_write_(int* unit, int* rec_lb, int* rec_ub, int* buf, int * len);
	void caf_set_file_view(int idx, int * rec_lb, int * rec_ub);
	/**** end of non-strided operations ****/


	/**** strided operations ****/
	void caf_file_read_str_(int* unit, int* rec_lb, int* rec_ub, int* str, int* buf, int * len);
	void caf_file_write_str_(int* unit, int* rec_lb, int* rec_ub, int* str, int* buf, int * len);
	void caf_set_file_view_str(int idx, int* rec_lb, int* rec_ub, int* str);
	/**** end of strided operations ****/

	// support functions
	int get_fh_idx(int unit);
