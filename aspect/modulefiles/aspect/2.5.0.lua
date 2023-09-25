-- -*- lua -*---

whatis([[Name : aspect]])
whatis([[Version : 2.5.0]])

prereq("gcc/11.2.0")
prereq("openmpi/4.0.6")

local modroot="$SPACK_ROOT/opt/spack/linux-rocky8-zen3/gcc-11.2.0/aspect-2.5.0-u7ss3tuuo5j4nqtjjtvoylexr5k4yf7y"
local viewroot="$SPACK_ROOT/var/spack/environments/aspect/.spack-env/view"

prepend_path("PATH", viewroot.."/bin", ":")
prepend_path("PATH", viewroot.."/sbin", ":")
prepend_path("PATH", modroot.."/bin", ":")
prepend_path("LIBRARY_PATH", viewroot.."/lib", ":")
prepend_path("LIBRARY_PATH", viewroot.."/lib64", ":")
prepend_path("LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", viewroot.."/lib", ":")
prepend_path("LD_LIBRARY_PATH", viewroot.."/lib64", ":")
prepend_path("LD_LIBRARY_PATH", modroot.."/lib", ":")
prepend_path("CPATH", viewroot.."/include", ":")
prepend_path("CPATH", modroot.."/include", ":")
prepend_path("MANPATH", viewroot.."/share/man", ":")
prepend_path("MANPATH", modroot.."/share/man", ":")
prepend_path("PKG_CONFIG_PATH", viewroot.."/lib/pkgconfig", ":")
prepend_path("PKG_CONFIG_PATH", modroot.."/lib/pkgconfig", ":")
prepend_path("CMAKE_PREFIX_PATH", viewroot.."/", ":")
prepend_path("CMAKE_PREFIX_PATH", modroot.."/", ":")
setenv("ASPECT_DIR", modroot.."/bin")
setenv("RCAC_ASPECT_ROOT", modroot)
setenv("RCAC_ASPECT_VERSION", "2.5.0")

