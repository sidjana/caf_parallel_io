!==========================================================================
! Forward 2D : Variable z grid implementation.
!
!   * vg_fwd_2d
!   * vg_fwd_inner_2d
!   * vg_fwd_taper_2d
!
!==========================================================================

      module cg_2d
       implicit none
      contains

         !========================================================================
         subroutine cg_fwd_2d(                                          &
                              lx,lz,                                    &
                              xmin,xmax,zmin,zmax,                      &
                              hdx_2,hdz_2,                              &
                              coefx,coefz,                              &
                              u,v,roc2,phi,eta,                         &
                              x1,x2,x3,x4,x5,x6,z1,z2,z3,z4,z5          &
                             )
       
           implicit none
       
           integer,intent(in) :: lx,lz
           integer,intent(in) :: x1,x2,x3,x4,x5,x6,z1,z2,z3,z4,z5
           integer,intent(in) :: xmin,xmax,zmin,zmax
           real,intent(in)    :: hdx_2,hdz_2
           real,intent(in)    :: coefx(0:lx)
           real,intent(in)    :: coefz(0:lz)
           real,intent(inout) :: phi(xmin:xmax,1,zmin:zmax)
           real,intent(inout) :: u(xmin-lx:xmax+lx,1,zmin-lz:zmax+lz)
           real,intent(in)    :: v(xmin-lx:xmax+lx,1,zmin-lz:zmax+lz)
           real,intent(in)    :: roc2(xmin:xmax,1,zmin:zmax)
           real,intent(in)    :: eta(xmin-1:xmax+1,1,zmin-1:zmax+1)
       
           integer            :: i,k
           real               :: lap,coef0


           coef0=coefx(0)+coefz(0)
           do k=zmin,zmax
               if ((k>=z3).and.(k<=z4)) then
                  do i=x1,x2
                     !! DAMPING LEFT.
                     lap=coef0*v(i,1,k)                                 &
                          +coefx(1)*(v(i+1,1,k)+v(i-1,1,k))             &
                          +coefz(1)*(v(i,1,k+1)+v(i,1,k-1))             &
                          +coefx(2)*(v(i+2,1,k)+v(i-2,1,k))             &
                          +coefz(2)*(v(i,1,k+2)+v(i,1,k-2))             &
                          +coefx(3)*(v(i+3,1,k)+v(i-3,1,k))             &
                          +coefz(3)*(v(i,1,k+3)+v(i,1,k-3))             &
                          +coefx(4)*(v(i+4,1,k)+v(i-4,1,k))             &
                          +coefz(4)*(v(i,1,k+4)+v(i,1,k-4))
       
                     !! Update the wavefield.
                     u(i,1,k)=((2.-eta(i,1,k)*eta(i,1,k)                &
                          +2.*eta(i,1,k))*v(i,1,k)                      &
                          -u(i,1,k)                                     &
                          +roc2(i,1,k)*(lap                             &
                          +phi(i,1,k)))/(1.+2.*eta(i,1,k))
       
                     !! Update the PML function.         
                     phi(i,1,k)=(phi(i,1,k)-                            &
                          ((eta(i+1,1,k)-eta(i-1,1,k))                  &
                          *(v(i+1,1,k)-v(i-1,1,k))*hdx_2                &
                          +(eta(i,1,k+1)-eta(i,1,k-1))                  &
                          *(v(i,1,k+1)-v(i,1,k-1))*hdz_2                &
                          ))/(1.+eta(i,1,k))
                  enddo
                  do i=x3,x4
                     !! BASIC.
                     lap=coef0*v(i,1,k)                                 &
                          +coefx(1)*(v(i+1,1,k)+v(i-1,1,k))             &
                          +coefz(1)*(v(i,1,k+1)+v(i,1,k-1))             &
                          +coefx(2)*(v(i+2,1,k)+v(i-2,1,k))             &
                          +coefz(2)*(v(i,1,k+2)+v(i,1,k-2))             &
                          +coefx(3)*(v(i+3,1,k)+v(i-3,1,k))             &
                          +coefz(3)*(v(i,1,k+3)+v(i,1,k-3))             &
                          +coefx(4)*(v(i+4,1,k)+v(i-4,1,k))             &
                          +coefz(4)*(v(i,1,k+4)+v(i,1,k-4))
       
                     !! Update the wavefield.         
                     u(i,1,k)=2.*v(i,1,k)-u(i,1,k)+roc2(i,1,k)*lap
                  enddo
                  do i=x5,x6
                     !! DAMPING RIGHT.
                     lap=coef0*v(i,1,k)                                 &
                          +coefx(1)*(v(i+1,1,k)+v(i-1,1,k))             &
                          +coefz(1)*(v(i,1,k+1)+v(i,1,k-1))             &
                          +coefx(2)*(v(i+2,1,k)+v(i-2,1,k))             &
                          +coefz(2)*(v(i,1,k+2)+v(i,1,k-2))             &
                          +coefx(3)*(v(i+3,1,k)+v(i-3,1,k))             &
                          +coefz(3)*(v(i,1,k+3)+v(i,1,k-3))             &
                          +coefx(4)*(v(i+4,1,k)+v(i-4,1,k))             &
                          +coefz(4)*(v(i,1,k+4)+v(i,1,k-4))
       
                     !! Update the wavefield.
                     u(i,1,k)=((2.-eta(i,1,k)*eta(i,1,k)                &
                          +2.*eta(i,1,k))*v(i,1,k)                      &
                          -u(i,1,k)                                     &
                          +roc2(i,1,k)*(lap                             &
                          +phi(i,1,k)))/(1.+2.*eta(i,1,k))
       
                     !! Update the PML function.         
                     phi(i,1,k)=(phi(i,1,k)-                            &
                          ((eta(i+1,1,k)-eta(i-1,1,k))                  &
                          *(v(i+1,1,k)-v(i-1,1,k))*hdx_2                &
                          +(eta(i,1,k+1)-eta(i,1,k-1))                  &
                          *(v(i,1,k+1)-v(i,1,k-1))*hdz_2                &
                          ))/(1.+eta(i,1,k))
                  enddo
               else
                  do i=xmin,xmax
                     !! DAMPING TOP and BOTTOM.
                     lap=coef0*v(i,1,k)                                 &
                          +coefx(1)*(v(i+1,1,k)+v(i-1,1,k))             &
                          +coefz(1)*(v(i,1,k+1)+v(i,1,k-1))             &
                          +coefx(2)*(v(i+2,1,k)+v(i-2,1,k))             &
                          +coefz(2)*(v(i,1,k+2)+v(i,1,k-2))             &
                          +coefx(3)*(v(i+3,1,k)+v(i-3,1,k))             &
                          +coefz(3)*(v(i,1,k+3)+v(i,1,k-3))             &
                          +coefx(4)*(v(i+4,1,k)+v(i-4,1,k))             &
                          +coefz(4)*(v(i,1,k+4)+v(i,1,k-4))
       
                     !! Update the wavefield.
                     u(i,1,k)=((2.-eta(i,1,k)*eta(i,1,k)                &
                          +2.*eta(i,1,k))*v(i,1,k)                      &
                          -u(i,1,k)                                     &
                          +roc2(i,1,k)*(lap                             &
                          +phi(i,1,k)))/(1.+2.*eta(i,1,k))
       
                     !! Update the PML function.         
                     phi(i,1,k)=(phi(i,1,k)-                            &
                          ((eta(i+1,1,k)-eta(i-1,1,k))                  &
                          *(v(i+1,1,k)-v(i-1,1,k))*hdx_2                &
                          +(eta(i,1,k+1)-eta(i,1,k-1))                  &
                          *(v(i,1,k+1)-v(i,1,k-1))*hdz_2                &
                          ))/(1.+eta(i,1,k))
                  enddo
               endif
           enddo
           return
         end subroutine cg_fwd_2d

         !========================================================================
         subroutine cg_fwd_inner_2d(                                    &
                                     im,ip,km,kp,                       &
                                     lx,lz,                             &
                                     xmin,xmax,zmin,zmax,               &
                                     coefx,coefz,                       &
                                     u,v,roc2                           &
                                    )
           !
           ! This subroutine updates the wavefield with no damping.
           !
       
           implicit none
       
           integer,intent(in) :: im,ip,km,kp
           integer,intent(in) :: lx,lz
           integer,intent(in) :: xmin,xmax,zmin,zmax
           real,intent(in)    :: coefx(0:lx)
           real,intent(in)    :: coefz(0:lz)
           real,intent(inout) :: u(xmin-lx:xmax+lx,1,zmin-lz:zmax+lz)
           real,intent(in)    :: v(xmin-lx:xmax+lx,1,zmin-lz:zmax+lz)
           real,intent(in)    :: roc2(xmin:xmax,1,zmin:zmax)
       
           integer            :: i,k
           real               :: lap,coef0
           coef0=coefx(0)+coefz(0)
           do k=km,kp
               do i=im,ip
                  !! BASIC.
                  lap=coef0*v(i,1,k)                                    &
                       +coefx(1)*(v(i+1,1,k)+v(i-1,1,k))                &
                       +coefz(1)*(v(i,1,k+1)+v(i,1,k-1))                &
                       +coefx(2)*(v(i+2,1,k)+v(i-2,1,k))                &
                       +coefz(2)*(v(i,1,k+2)+v(i,1,k-2))                &
                       +coefx(3)*(v(i+3,1,k)+v(i-3,1,k))                &
                       +coefz(3)*(v(i,1,k+3)+v(i,1,k-3))                &
                       +coefx(4)*(v(i+4,1,k)+v(i-4,1,k))                &
                       +coefz(4)*(v(i,1,k+4)+v(i,1,k-4))
       
                  !! Update the wavefield.         
                  u(i,1,k)=2.*v(i,1,k)-u(i,1,k)+roc2(i,1,k)*lap
               enddo
           enddo
           return
         end subroutine cg_fwd_inner_2d
      end module


      !================================================== main program
      program cg_main

      use cg_2d
      implicit none

      include 'caf_io.h'

      integer,parameter :: npx=2
      integer           :: px,pz,me,npz
      integer           :: i
      integer, parameter:: lx=4,lz=4,nt=100
      integer, parameter:: xmin=1,xmax=XMAX_,zmin=1,zmax=ZMAX_
      real,parameter    :: dx=4,dz=4,fmax=15,c=3000
      integer           :: it,xsource,zsource,l,z
      integer           :: x1,x2,x3,x4,x5,x6,z1,z2,z3,z4,z5
      integer           :: im,ip,km,kp
      integer           :: ix, iz
      integer           :: ub, lb
      real              :: dt
      real              :: source (nt)
      real              :: coefx(0:lx),coefz(0:lz)
      real              :: hdx_2,hdz_2
      character(len=16) :: char
      real              :: rmax, rmin
      real              :: roc2(xmin:xmax, zmin:zmax)
#ifndef INNER
      real              :: phi(xmin:xmax,1,zmin:zmax)
#endif
      real              :: u(xmin-lx:xmax+lx, zmin-lz:zmax+lz)[npx,1,*]
      real              :: v(xmin-lx:xmax+lx, zmin-lz:zmax+lz)[npx,1,*]
      real              :: max_u[*], min_u[*]
#ifndef INNER
      real              :: eta(xmin-1:xmax+1,zmin-1:zmax+1)[npx,1,*]
#endif

      integer :: x_size, z_size, x_size_total, z_size_total
      integer :: rec_lb(2), rec_ub(2)

      integer(kind=8)   :: crtc, srtc,ertc,res
      real(kind=8)      :: io_rtc, full_rtc, rtmp

      call get_rtc(crtc)

      npz = num_images() / npx

      ! compute coefs
      call second_derivative_coef(coefx,lx)
      call second_derivative_coef(coefz,lz)
      coefx=coefx/dx/dx
      coefz=coefz/dz/dz

      ! set propagator coef
      dt=0.4*max(dx,dz)/c
      hdx_2=1./(4.*dx*dx)
      hdz_2=1./(4.*dz*dz)
      roc2=c*c*dt*dt

      ! initialize arrays
      source=0
      u=0.
      v=0.
      me = this_image()
      px = this_image(v,1)
      pz = this_image(v,3)

      x1 = xmin
      x6 = xmax
      if (px == 1) then
          x2 = xmin+4
          x3 = xmin+5
      else
          x2 = 0
          x3 = xmin
      end if 
      if (px == npx) then
          x4 = xmax-5
          x5 = xmax-4
      else 
          x4 = xmax
          x5 = xmax+1
      end if 
      z3=zmin
      z4=zmax
      if (pz == 1) then
          z3 = 2
      end if 

      ! computer source term
      if ( mod(npx,2) == 0) then
          xsource = xmax
          ix = npx/2
      else 
          xsource = xmax/2
          ix = npx/2+1
      end if 
      if ( mod(npz,2) == 0) then
          zsource = zmax
          iz = npz/2
      else
          zsource = zmax/2
          iz = npz/2+1
      endif 

      call csource(nt,fmax,dt,source)

#ifdef INNER
      im = xmin
      ip = xmax
      km = zmin
      kp = zmax
      if (px ==1) im = xmin+lx
      if (px ==npx) ip = xmax-lx
      if (pz ==1) km = zmin+lz

      ub = ucobound(v, 3)

      if (pz == ub ) kp = zmax-lz
#endif

      sync all

      do it=1,nt,2
        max_u = maxval( u(xmin:xmax,zmin:zmax) )
        min_u = minval( u(xmin:xmax,zmin:zmax) )

        sync all

        if (me ==1) then
            do i=2,num_images()
                rmax = max_u[i]
                rmin = min_u[i]
                if (rmax > max_u) max_u = rmax
                if (rmin < min_u) min_u = rmin
            end do
!            write (*,'(i4,f8.1,f8.1,f8.1,f8.1)'),                       &
!                   it, max_u, min_u, source(it), dt
        end if

        if (px == ix .and. pz == iz) then
            !print *, "image ", me, " getting source input for U"
            u(xsource, zsource) = u(xsource, zsource) + source(it)
        end if

#ifndef INNER
        call cg_fwd_2d(                                                 &
                        lx,lz,                                          &
                        xmin,xmax,zmin,zmax,                            &
                        hdx_2,hdz_2,                                    &
                        coefx,coefz,                                    &
                        u,v,roc2,phi,eta,                               &
                        x1,x2,x3,x4,x5,x6,z1,z2,z3,z4,z5                &
                      )
#else
        call cg_fwd_inner_2d(                                           &
                            im,ip,km,kp,                                &
                            lx,lz,                                      &
                            xmin,xmax,zmin,zmax,                        &
                            coefx,coefz,                                &
                            u,v,roc2                                    &
                            )
#endif

        sync all

        ! get data from top neighbor
        if( px>1) then
            u(xmin-lx:xmin-1,zmin:zmax) =                               &
                      u(xmax-lx+1:xmax,zmin:zmax)[px-1,1,pz]
#ifndef INNER
            eta(xmin-1,zmin:zmax) = eta(xmax,zmin:zmax)[px-1,1,pz]
#endif
        end if

        ! get data from bottom neighbor
        if (px<npx) then
            u(xmax+1:xmax+lx,zmin:zmax) =                               &
                      u(xmin:xmin+lx-1,zmin:zmax)[px+1,1,pz]
#ifndef INNER
            eta(xmax+1,zmin:zmax) = eta(xmin,zmin:zmax)[px+1,1,pz]
#endif
        endif

        ! get data from left neighbor
        if (pz > 1) then
            u(xmin:xmax,zmin-lz:zmin-1) =                               &
                      u(xmin:xmax,zmax-lz+1:zmax)[px,1,pz-1]
#ifndef INNER
            eta(xmin:xmax,zmin-1) = eta(xmin:xmax,zmax)[px,1,pz-1]
#endif
        end if

        ! get data from right neighbor
        ub = ucobound(u, 3)
        if (pz< ub) then
            u(xmin:xmax,zmax+1:zmax+lz) =                               &
                      u(xmin:xmax,zmin:zmin+lz-1)[px,1,pz+1]
#ifndef INNER
            eta(xmin:xmax,zmax+1) = eta(xmin:xmax,zmin)[px,1,pz+1]
#endif
        end if

        sync all

        if (px == ix .and. pz == iz) then
            !print *, "image ", me, " getting source input for V"
            v(xsource, zsource) = v(xsource, zsource) + source(it+1)
        end if

#ifndef INNER
        call cg_fwd_2d(                                                 &
                       lx,lz,                                           &
                       xmin,xmax,zmin,zmax,                             &
                       hdx_2,hdz_2,                                     &
                       coefx,coefz,                                     &
                       v,u,roc2,phi,eta,                                &
                       x1,x2,x3,x4,x5,x6,z1,z2,z3,z4,z5                 &
                      )
#else
        call cg_fwd_inner_2d(                                           &
                            im,ip,km,kp,                                &
                            lx,lz,                                      &
                            xmin,xmax,zmin,zmax,                        &
                            coefx,coefz,                                &
                            v,u,roc2                                    &
                            )
#endif

        sync all

        ! get data from top neighbor
        if( px>1) then
            v(xmin-lx:xmin-1,zmin:zmax) =                               &
                      v(xmax-lx+1:xmax,zmin:zmax)[px-1,1,pz]
#ifndef INNER
            eta(xmin-1,zmin:zmax) = eta(xmax,zmin:zmax)[px-1,1,pz]
#endif
        end if

        ! get data from bottom neighbor
        if (px<npx) then
            v(xmax+1:xmax+lx,zmin:zmax) =                               &
                      v(xmin:xmin+lx-1,zmin:zmax)[px+1,1,pz]
#ifndef INNER
            eta(xmax+1,zmin:zmax) = eta(xmin,zmin:zmax)[px+1,1,pz]
#endif
        endif

        ! get data from left neighbor
        if (pz > 1) then
            v(xmin:xmax,zmin-lz:zmin-1) =                               &
                      v(xmin:xmax,zmax-lz+1:zmax)[px,1,pz-1]
#ifndef INNER
            eta(xmin:xmax,zmin-1) = eta(xmin:xmax,zmax)[px,1,pz-1]
#endif
        end if

        ! get data from right neighbor
        ub = ucobound(v, 3)
        if (pz< ub) then
            v(xmin:xmax,zmax+1:zmax+lz) =                               &
                      v(xmin:xmax,zmin:zmin+lz-1)[px,1,pz+1]
#ifndef INNER
            eta(xmin:xmax,zmax+1) = eta(xmin:xmax,zmin)[px,1,pz+1]
#endif
        end if

      enddo
      
      me = this_image()

	sync all

     !  using CAF Parallel I/O
	     x_size = (xmax-xmin+2*lx+1)
	     z_size = (zmax-zmin+2*lz+1)
             x_size_total = npx*x_size
	     z_size_total = npz*z_size

	     rec_lb(1)=1+((px-1)*x_size)
	     rec_lb(2)=1+((pz-1)*z_size)

	     rec_ub(1)=px*x_size
	     rec_ub(2)=pz*z_size


	     call get_rtc(srtc)
	     sync all

             call caf_file_open(1, 'out.ver1', &
	            MPI_MODE_WRONLY + MPI_MODE_CREATE, 2, &
	     	    (/x_size_total, z_size_total/), &
	     	     4, 1);

	     call caf_file_write(1, rec_lb, &
	     		    rec_ub, u, &
	     		    4*x_size*z_size)

	     call caf_file_close(1)

	     if (me == 1 ) then
	       call get_rtc(ertc)
	       call get_rtc_res(res)
	       rtmp = res
	       io_rtc=(ertc-srtc)/rtmp
	       full_rtc=(ertc-crtc)/rtmp
	       print *, num_images(), io_rtc*1000000.0 , full_rtc*1000000.0 , &
	       		(io_rtc/full_rtc)*100,"%" 
	     end if



! 'stop' in the next stmt has been commented since G95 does not exit images cleanly.
      !stop
      
      contains
      !===================================================================
      subroutine second_derivative_coef(coef,l)
      !
      ! Given the half-order l of desired stencil,this routine returns 
      ! coef which contains the standard associated FD stencil.
      !
      implicit none
      integer,intent(in) :: l
      real,intent(out)   :: coef(0:l)
      select case(l)
         case(0)
            coef=(/             0./)
         case(1)
            coef=(/            -2.,    1./)
         case(2)
            coef=(/         -5./2., 4./3., -1./12./) 
         case(3)
            coef=(/       -49./18., 3./2., -3./20.,  1./90./)
         case(4)
            coef=(/      -205./72., 8./5.,  -1./5., 8./315., &
                 -1./560./)
         case(5)
            coef=(/   -5269./1800., 5./3., -5./21., 5./126., &
                 -5./1008.,  1./3150./)
         case(6)
            coef=(/   -5369./1800.,12./7.,-15./56.,10./189., &
                 -1./112.,  2./1925.,  1./16632./)
         case(7)
            coef=(/-266681./88200., 7./4., -7./24., 7./108., &
                 -7./528.,  7./3300., -7./30888.,  1./84084./)
    
         case default
            write(6,*) 'Error ! Standard FD stencil : invalid order.'
            write(6,*) 'Notice that 2 <= order <= 14.'
            call flush(6)
            error stop
      end select
      return
      end subroutine second_derivative_coef
      ! ======================================
      subroutine csource(nt,fpeak,dt,source)
       !--
       implicit none
       integer   :: it,nt
       real      :: fpeak,dt,t
       real      :: pi,tpeak,lam
       real      :: source(nt)
       !--
       tpeak=0
       pi=3.1415927
       lam=pi*pi*fpeak*fpeak
    
       do it=1,nt
          t=dt*real(it-1)
          source (it)=2.*lam*(2.*lam*(t-tpeak)*(t-tpeak)-1)*exp(-lam*&
          (t-tpeak)**2)

       enddo
       return
       end subroutine csource
      end program cg_main
