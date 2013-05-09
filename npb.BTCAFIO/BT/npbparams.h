c NPROCS = 4 CLASS = S SUBTYPE = FULL
c  
c  
c  This file is generated automatically by the setparams utility.
c  It sets the number of processors and the class of the NPB
c  in this directory. Do not modify it by hand.
c  
        integer maxcells, problem_size, niter_default
        parameter (maxcells=2, problem_size=12, niter_default=60)
        double precision dt_default
        parameter (dt_default = 0.010d0)
        integer wr_default
        parameter (wr_default = 5)
        integer iotype
        parameter (iotype = 1)
        character*(*) filenm
        parameter (filenm = 'btio.full.out')
        logical  convertdouble
        parameter (convertdouble = .false.)
        character*11 compiletime
        parameter (compiletime='07 May 2013')
        character*3 npbversion
        parameter (npbversion='3.2')
        character*8 cs1
        parameter (cs1='$(UHCAF)')
        character*8 cs2
        parameter (cs2='$(UHCAF)')
        character*6 cs3
        parameter (cs3='(none)')
        character*6 cs4
        parameter (cs4='(none)')
        character*8 cs5
        parameter (cs5='-O3 -I./')
        character*3 cs6
        parameter (cs6='-O3')
        character*6 cs7
        parameter (cs7='randi8')
