#!/bin/bash

WORKDIR="$PWD"
SPACK_ROOT="$WORKDIR/spack"

if [ -d $SPACK_ROOT ]; then
	echo "Using previously downloaded spack at $SPACK_ROOT."
else
	# Download spack
	git clone https://github.com/spack/spack $SPACK_ROOT
fi

# Activate spack
source $SPACK_ROOT/share/spack/setup-env.sh

if spack env list | grep -q aspect; then
	echo "Found aspect environment in Spack."
else
	# Copy environment file
	mkdir -p $SPACK_ROOT/var/spack/environments/aspect && cp $WORKDIR/spack-env/spack.yaml $SPACK_ROOT/var/spack/environments/aspect
fi

# List environments. Should show "aspect"
spack env list

# Patch aspect package in Spack. Version 2.5.0 is not defined in Spack.
cd $SPACK_ROOT && git apply $WORKDIR/patches/dealii-package.patch && git apply $WORKDIR/patches/aspect-package.patch

# Now concretize the environment
spack env activate aspect
spack concretize --force && spack install -j128

# At this point everything except Aspect should be installed. If not debug the install failures and install all the dependencies with Spack.

# To install aspect look at the error message printed by Spack. It should be ".... cannot find -lhdf5-shared..."
# We will fix this option in Spack's temporary build directory and install aspect.

# Go to the temporary build directory printed by Spack. "/tmp/.../spack-stage-aspectxxxx".
# Go inside "spack-build-xxxxxxxx"
# Now get a new shell: "bash"
# source ../spack-build-env.txt
# make #this will give the same error message
# We will need to edit the file CMakeFiles/aspect.dir/link.txt
#	Replace "-lhdf5-shared" with "-lhdf5"
# Run "make" again. This time make will finish successfully.
# Run "make install". This will install aspect with other Spack packages. Note the directory name where aspect is being installed, we will need this to update the modulefile.
#
#
# To use aspect in your jobs we will need to edit the module file for aspect provided in this directory.
#              vi modulefiles/aspect/2.5.0.lua
#
# More specifically we need to update the lines "local modroot=...." and "local viewroot=...." with correct paths.
# Set "modroot=$SPACK_ROOT/opt/spack/linux-rocky8-zen3/gcc-11.2.0/aspect-vvvv-xxxxxx". Note that this is the same directory you noted above during "make install."
# Set "viewroot=$SPACK_ROOT/var/spack/environments/aspect/.spack-env/view". This is the directory where Spack copied all the dependencies for aspect.
#
# Once the module file has been edited, now it is time to use the module.
# Run the following commands to load and test the module.
#              module use $WORKDIR/modulefiles
#              module load gcc/11.2.0
#              module load openmpi/4.0.6
#              module load aspect
#
# If you are unable to load the module or unable to find the aspect executable, then the paths in the module file are not correct. Fix the paths and reload the module.
#
#
# At this point you can test aspect with the following command.
#              mpirun -n 1 aspect --help
# You can also try runnig aspect with an input file.
#              mpirun -n 2 aspect xxx.prm
#
# Note that you must always include the above 4 commands in your job script.
#              module use ....
#              ....
#              module load aspect
#
