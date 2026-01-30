#YALES2 Makefile
include $(YALES2_HOME)/src/Makefile.in




# Compilers
F90 = gfortran
CC = gcc

# Safe Debug Flags without Sanitizer
FFLAGS = -g -O0 -fcheck=all -fbacktrace -Wall -Wuninitialized -finit-real=nan -finit-integer=-9999
CFLAGS = -g -O0 -Wall -Wextra
#FLD =




# parameters
CONTROLLER_PATH='./Controller/ROSCO/'
#CONTROLLER_PATH='./Controller/NREL5MW_BASELINE/'

PROG2MAKE=case

# defaults
defaults: $(PROG2MAKE)

# Libraries
LINKS = -L$(YALES2_LIB) -lyales2main $(ADD_LIBS)



# Program rule
$(PROG2MAKE): %: %.o
	$(F90) $(FLD) -I. -I$(YALES2_LIB) -o $@ $@.o $(LINKS)
	#make -C $(CONTROLLER_PATH)

# Generic rules
%.o: %.f90
	$(F90) $(FFLAGS) -I. -I$(YALES2_LIB) -c $*.f90

%.o: %.c
	$(CC) $(CFLAGS) -c $*.c

# clean
veryclean: clean
	rm -rf dump* *.txt ALM_output* probes* temporals* CSV* reference* log* Log* reference* fort* Output* postproc openfast_dump* openfast_turbine_1/*.T1* Sanity* openfast_turbine_2/*.T2* openfast_turbine_3/*.T3* openfast_turbine_4/*.T4*
	#make -C $(CONTROLLER_PATH) veryclean

clean:
	rm -f $(PROG2MAKE) *.o *.mod *.log .gdb_history
	#make -C $(CONTROLLER_PATH) clean
