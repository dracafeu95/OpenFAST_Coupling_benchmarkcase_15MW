!-----------------------------------------------------------------------------------
! wind_farm program
!-----------------------------------------------------------------------------------

!=================================================================
program main

      use yales2_m

      implicit none

      ! ------------------------
      character(len=LEN_MAX) :: inputfile
      ! ------------------------

      inputfile = "inputfile_main.in"

      ! ------------------------
      ! run
      call run_yales2(inputfile)

end program main
!=================================================================

!=================================================================
subroutine initialize_data()

      use yales2_m

      implicit none

      ! ------------------------
      ! ------------------------
      type(grid_t), pointer :: grid
      type(el_grp_t), pointer :: el_grp
      type(data_t), pointer :: u_ptr, x_ptr
      type(boundary_t), pointer :: bndptr
      type(bnd_data_t), pointer :: u_ref,x_bnd
      type (r2_t), pointer :: u
      integer :: n,i, bndnb
      real(WP) :: x(3)
      logical :: found
      ! ------------------------

      grid => solver%first_grid
      call find_data(grid%first_data,"U",u_ptr)
      call find_data(grid%first_data,"X_NODE",x_ptr)

      call find_boundary(grid%first_boundary,"z0",res_ptr=bndptr,rank=bndnb,resfound=found)
      if (.not.found) call error_and_exit("Boundary z0 not found")
      x_bnd => x_ptr%bnd_data_ptrs(bndnb)%ptr
      u_ref => u_ptr%bnd_ref_ptrs(bndnb)%ptr
      do i=1,bndptr%nnode
         u_ref%r2%val(1:grid%ndim,i) = 0.0_WP
         u_ref%r2%val(1,i)=8.0_WP
         !u_ref%r2%val(3,i)=12.0_WP*((x_bnd%r2%val(2,i)+90.0_WP)/90.0_WP)**(0.13_WP)
      end do

      ! ------------------------
      ! u initialization
      if (.not.solver%restarted_with_solution) then
         do n=1,grid%nel_grps
            el_grp => grid%el_grps(n)%ptr
            u => u_ptr%r2_ptrs(n)%ptr
            !z => z_ptr%r1_ptrs(n)%ptr
            do i=1,el_grp%nnode
               x(1:grid%ndim) = el_grp%x_node%val(1:grid%ndim,i)
               u%val(1:grid%ndim,i) = 0.0_WP
               u%val(1,i) = 8.0_WP
            end do
         end do
      end if

end subroutine initialize_data
!=================================================================

!=================================================================
subroutine temporal_loop_preproc()

      use yales2_m

      implicit none

      ! ------------------------
      type(grid_t), pointer :: grid
      type(actuator_set_t), pointer :: actuator_set
      type(el_grp_t), pointer :: el_grp
      type(data_t), pointer :: u_ptr, vel_def_ptr
      type (r1_t), pointer :: vel_def
      type (r2_t), pointer :: u
      integer :: n,i
      real(WP) :: x(3)
      logical :: found
      ! ------------------------

      ! pointers
      grid => solver%first_grid
      actuator_set => grid%first_actuator_set

      call find_data(grid%first_data,"U",u_ptr)
      call find_data(grid%first_data,"VELOCITY_DEFICIT",vel_def_ptr,resfound=found)
      if (found) then
         !if (myworker==master) then
         !   call print_message("computing velocity deficit")
         !end if 
         do n=1,grid%nel_grps
            el_grp => grid%el_grps(n)%ptr
            u => u_ptr%r2_ptrs(n)%ptr
            vel_def => vel_def_ptr%r1_ptrs(n)%ptr
            do i=1,el_grp%nnode
               x(1:grid%ndim) = el_grp%x_node%val(1:grid%ndim,i)
               vel_def%val(i) = 8.0_WP - u%val(1,i)
            end do
         end do
      end if

end subroutine temporal_loop_preproc
!=================================================================

!=================================================================
subroutine temporal_loop_postproc()

      use yales2_m

      implicit none

      ! ------------------------
      type(grid_t), pointer :: grid
      type(actuator_set_t), pointer :: rotor
      integer :: i
      ! ------------------------

      ! pointers
      grid => solver%first_grid

      rotor => grid%first_actuator_set
      do i=1,count_actuator_set(rotor)

         call show_rotor_force_and_power(solver,rotor)
         rotor => rotor%next
      end do

end subroutine temporal_loop_postproc
!=================================================================
