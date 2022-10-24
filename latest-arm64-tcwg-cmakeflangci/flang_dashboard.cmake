# Client maintainer: linaro-toolchain@lists.linaro.org

set(CTEST_SITE "linaro")
set(CTEST_BUILD_NAME "cmake_ubuntu_arm64_flang")
set(CTEST_BUILD_CONFIGURATION Debug)
set(CTEST_CMAKE_GENERATOR "Ninja")

set(ENV{CC} "clang")
set(ENV{CXX} "clang++")
set(ENV{FC} "flang-new")
set(ENV{FFLAGS} "-flang-experimental-exec")

# Exclude some tests (because they need a compiler built with
# ENABLE_LINKER_BUILD_ID set to ON, and the releases default to OFF).
set(exclude
  "RunCMake.CPack_DEB.DEBUGINFO"
  )
string(REPLACE ";" "|" exclude "${exclude}")

# Enable parallelism.
set(CTEST_TEST_ARGS  PARALLEL_LEVEL 8  EXCLUDE "^(${exclude})$"  )
set(dashboard_cache "
  CMAKE_Fortran_COMPILER:FILEPATH=flang-new
  CMAKE_Fortran_FLAGS:STRING=-flang-experimental-exec
  CMAKE_Fortran_COMPILER_SUPPORTS_F90:BOOL=1
  ")
include(${CTEST_SCRIPT_DIRECTORY}/cmake_common.cmake)
