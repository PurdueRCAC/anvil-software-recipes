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
# We will need to edit the file CMakeLists/aspect.dir/links.txt
#	Replace "-lhdf5-shared" with "-lhdf5"
# Run "make" again. This time make will finish successfully.
# Run "make install". This will install aspect with other Spack packages.
#
