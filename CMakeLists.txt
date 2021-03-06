cmake_minimum_required(VERSION 3.10.0)

# Ensure the default configs are defined and select one if none are
# chosen by user
set ( CMAKE_CONFIGURATION_TYPES "Debug" "RuntimeDebug" "Release" "MinSizeRel" "RelWithDebInfo" )
set ( CMAKE_BUILD_TYPE "Release"
  CACHE STRING "Select which configuration to build." )

# Name project and specify source languages
project(zgoubi
  LANGUAGES Fortran C)

# Print an error message on an attempt to build inside
# the top level of the source tree:
if ("${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
 message(FATAL_ERROR "ERROR! "
   "CMAKE_CURRENT_SOURCE_DIR=${CMAKE_CURRENT_SOURCE_DIR}"
   " == CMAKE_CURRENT_BINARY_DIR=${CMAKE_CURRENT_BINARY_DIR}"
   "\nThis archive does not support in-source builds:\n"
   "To facilitate a correct configuration, please delete the "
   "CMakeCache.txt file and the CMakeFiles/ directory under the "
   "source directory and run something like \n"
   "  $ rm -r CMakeCache.txt CMakeFiles/"
   "\n"
   "Please create a new directory and build in a manner such as"
   "  $ mkdir build\n"
   "  $ cd build\n"
   "  $ FC=gfortran CC=gcc cmake .. -DCMAKE_INSTALL_PREFIX=<install-path>\n"
 )
endif()

set(issues_URL "https://github.com/radiasoft/zgoubi/issues")
if (NOT "${CMAKE_Fortran_COMPILER_ID}" MATCHES "GNU")
  message(WARNING "Untested compiler detected: ${CMAKE_Fortran_COMPILER_ID}. Report any issues at ${issues_URL}")
endif()

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/maybe_fetch_file.cmake")
find_package(UnixCommands)

# Get map file needed for test
macro(update_verify_warmSnake)
  maybe_fetch_file( tests/warmSnake.map.gz
    "https://sourceforge.net/p/zgoubi/code/HEAD/tree/trunk/exemples/usersGuide/FIT-and-REBELOTE/warmSnake.map.gz?format=raw"
    06fac3c92404100ffcbbaf281136c2e3d565c6091aa24d3a216aae816b012878 # 8 # Real last digit is 8 not 7 use 7 for testing
    have_warm_snake
    )
  execute_process(COMMAND ${GZIP} -dkf ${CMAKE_BINARY_DIR}/tests/warmSnake.map.gz)
endmacro()

update_verify_warmSnake()
message( STATUS "have_warm_snake? ${have_warm_snake}")

if(CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
  set(common_fflags -g -static-libgfortran -Wall -fbacktrace -fno-automatic -pedantic -cpp)
elseif(CMAKE_Fortran_COMPILER_ID STREQUAL "Intel")
  set(common_fflags -g -standard-semantics -fp-model precise -xHOST -traceback -staticlib -save -cpp)
endif()

add_library(coupl
zgoubi/coupling/libraries/libeis/rg.f
zgoubi/coupling/tunesc/propag.f
zgoubi/coupling/tunesc/hamilt.f
zgoubi/coupling/libraries/libdet/getdet.f
zgoubi/coupling/libraries/libinv/dgetrf.f
zgoubi/coupling/libraries/libinv/dgetri.f
zgoubi/coupling/libraries/libinv/zhemm.f
zgoubi/coupling/libraries/libinv/zgeru.f
zgoubi/coupling/libraries/libinv/chemm.f
zgoubi/coupling/libraries/libinv/caxpy.f
zgoubi/coupling/libraries/libinv/drotm.f
zgoubi/coupling/libraries/libinv/saxpy.f
zgoubi/coupling/libraries/libinv/dtrsv.f
zgoubi/coupling/libraries/libinv/cgeru.f
zgoubi/coupling/libraries/libinv/srotmg.f
zgoubi/coupling/libraries/libinv/dsymv.f
zgoubi/coupling/libraries/libinv/zhemv.f
zgoubi/coupling/libraries/libinv/chpr.f
zgoubi/coupling/libraries/libinv/zgemm.f
zgoubi/coupling/libraries/libinv/dger.f
zgoubi/coupling/libraries/libinv/crotg.f
zgoubi/coupling/libraries/libinv/csscal.f
zgoubi/coupling/libraries/libinv/sgemv.f
zgoubi/coupling/libraries/libinv/ctpmv.f
zgoubi/coupling/libraries/libinv/dtbsv.f
zgoubi/coupling/libraries/libinv/sscal.f
zgoubi/coupling/libraries/libinv/zcopy.f
zgoubi/coupling/libraries/libinv/zher2.f
zgoubi/coupling/libraries/libinv/dsbmv.f
zgoubi/coupling/libraries/libinv/dsdot.f
zgoubi/coupling/libraries/libinv/dtrsm.f
zgoubi/coupling/libraries/libinv/dcopy.f
zgoubi/coupling/libraries/libinv/sspr.f
zgoubi/coupling/libraries/libinv/strmv.f
zgoubi/coupling/libraries/libinv/cherk.f
zgoubi/coupling/libraries/libinv/ssyr2.f
zgoubi/coupling/libraries/libinv/ssyr.f
zgoubi/coupling/libraries/libinv/dswap.f
zgoubi/coupling/libraries/libinv/dtrmm.f
zgoubi/coupling/libraries/libinv/zgbmv.f
zgoubi/coupling/libraries/libinv/ssyr2k.f
zgoubi/coupling/libraries/libinv/dgemm.f
zgoubi/coupling/libraries/libinv/stbsv.f
zgoubi/coupling/libraries/libinv/ddot.f
zgoubi/coupling/libraries/libinv/cscal.f
zgoubi/coupling/libraries/libinv/ctbmv.f
zgoubi/coupling/libraries/libinv/lsame.f
zgoubi/coupling/libraries/libinv/strmm.f
zgoubi/coupling/libraries/libinv/sger.f
zgoubi/coupling/libraries/libinv/sspr2.f
zgoubi/coupling/libraries/libinv/zscal.f
zgoubi/coupling/libraries/libinv/scabs1.f
zgoubi/coupling/libraries/libinv/ctpsv.f
zgoubi/coupling/libraries/libinv/srotm.f
zgoubi/coupling/libraries/libinv/sasum.f
zgoubi/coupling/libraries/libinv/dlamch.f
zgoubi/coupling/libraries/libinv/scasum.f
zgoubi/coupling/libraries/libinv/dscal.f
zgoubi/coupling/libraries/libinv/zher.f
zgoubi/coupling/libraries/libinv/dsyrk.f
zgoubi/coupling/libraries/libinv/zgemv.f
zgoubi/coupling/libraries/libinv/zdotu.f
zgoubi/coupling/libraries/libinv/csymm.f
zgoubi/coupling/libraries/libinv/dgemv.f
zgoubi/coupling/libraries/libinv/ztpsv.f
zgoubi/coupling/libraries/libinv/zswap.f
zgoubi/coupling/libraries/libinv/dzasum.f
zgoubi/coupling/libraries/libinv/zsyr2k.f
zgoubi/coupling/libraries/libinv/ztrmv.f
zgoubi/coupling/libraries/libinv/ztrsm.f
zgoubi/coupling/libraries/libinv/zsymm.f
zgoubi/coupling/libraries/libinv/ssyrk.f
zgoubi/coupling/libraries/libinv/scopy.f
zgoubi/coupling/libraries/libinv/csyrk.f
zgoubi/coupling/libraries/libinv/chbmv.f
zgoubi/coupling/libraries/libinv/srotg.f
zgoubi/coupling/libraries/libinv/cdotc.f
zgoubi/coupling/libraries/libinv/ieeeck.f
zgoubi/coupling/libraries/libinv/cdotu.f
zgoubi/coupling/libraries/libinv/stbmv.f
zgoubi/coupling/libraries/libinv/ctrsm.f
zgoubi/coupling/libraries/libinv/zrotg.f
zgoubi/coupling/libraries/libinv/dtrmv.f
zgoubi/coupling/libraries/libinv/zher2k.f
zgoubi/coupling/libraries/libinv/cgemm.f
zgoubi/coupling/libraries/libinv/drot.f
zgoubi/coupling/libraries/libinv/ilaenv.f
zgoubi/coupling/libraries/libinv/csrot.f
zgoubi/coupling/libraries/libinv/dgetrf.f
zgoubi/coupling/libraries/libinv/dtpmv.f
zgoubi/coupling/libraries/libinv/csyr2k.f
zgoubi/coupling/libraries/libinv/cher.f
zgoubi/coupling/libraries/libinv/snrm2.f
zgoubi/coupling/libraries/libinv/dlaswp.f
zgoubi/coupling/libraries/libinv/inverse-matrix-bis/lapack_routine/lsame.f
zgoubi/coupling/libraries/libinv/inverse-matrix-bis/lapack_routine/dlamch.f
zgoubi/coupling/libraries/libinv/inverse-matrix-bis/lapack_routine/ieeeck.f
zgoubi/coupling/libraries/libinv/inverse-matrix-bis/lapack_routine/ilaenv.f
zgoubi/coupling/libraries/libinv/inverse-matrix-bis/lapack_routine/iparmq.f
zgoubi/coupling/libraries/libinv/inverse-matrix-bis/lapack_routine/xerbla.f
zgoubi/coupling/libraries/libinv/inverse-matrix-bis/double/dgetrf.f
zgoubi/coupling/libraries/libinv/inverse-matrix-bis/double/dlaswp.f
zgoubi/coupling/libraries/libinv/inverse-matrix-bis/double/dgetf2.f
zgoubi/coupling/libraries/libinv/ssymv.f
zgoubi/coupling/libraries/libinv/zsyrk.f
zgoubi/coupling/libraries/libinv/ctrsv.f
zgoubi/coupling/libraries/libinv/zhpr2.f
zgoubi/coupling/libraries/libinv/ctbsv.f
zgoubi/coupling/libraries/libinv/dgbmv.f
zgoubi/coupling/libraries/libinv/ctrmm.f
zgoubi/coupling/libraries/libinv/dcabs1.f
zgoubi/coupling/libraries/libinv/srot.f
zgoubi/coupling/libraries/libinv/daxpy.f
zgoubi/coupling/libraries/libinv/dtrti2.f
zgoubi/coupling/libraries/libinv/dsyr.f
zgoubi/coupling/libraries/libinv/zdrot.f
zgoubi/coupling/libraries/libinv/ccopy.f
zgoubi/coupling/libraries/libinv/dgetf2.f
zgoubi/coupling/libraries/libinv/zdscal.f
zgoubi/coupling/libraries/libinv/determinant-2/cgefa.f
zgoubi/coupling/libraries/libinv/dspr.f
zgoubi/coupling/libraries/libinv/icamax.f
zgoubi/coupling/libraries/libinv/iparmq.f
zgoubi/coupling/libraries/libinv/dsyr2.f
zgoubi/coupling/libraries/libinv/inverse-matrix/lapack_routine/lsame.f
zgoubi/coupling/libraries/libinv/inverse-matrix/lapack_routine/ieeeck.f
zgoubi/coupling/libraries/libinv/inverse-matrix/lapack_routine/ilaenv.f
zgoubi/coupling/libraries/libinv/inverse-matrix/lapack_routine/iparmq.f
zgoubi/coupling/libraries/libinv/inverse-matrix/lapack_routine/xerbla.f
zgoubi/coupling/libraries/libinv/inverse-matrix/double/dtrti2.f
zgoubi/coupling/libraries/libinv/inverse-matrix/double/dtrtri.f
zgoubi/coupling/libraries/libinv/inverse-matrix/double/dgetri.f
zgoubi/coupling/libraries/libinv/cgbmv.f
zgoubi/coupling/libraries/libinv/cher2k.f
zgoubi/coupling/libraries/libinv/isamax.f
zgoubi/coupling/libraries/libinv/ztbsv.f
zgoubi/coupling/libraries/libinv/chemv.f
zgoubi/coupling/libraries/libinv/dtpsv.f
zgoubi/coupling/libraries/libinv/cher2.f
zgoubi/coupling/libraries/libinv/zhpmv.f
zgoubi/coupling/libraries/libinv/zherk.f
zgoubi/coupling/libraries/libinv/idamax.f
zgoubi/coupling/libraries/libinv/ssymm.f
zgoubi/coupling/libraries/libinv/sswap.f
zgoubi/coupling/libraries/libinv/dtrtri.f
zgoubi/coupling/libraries/libinv/izamax.f
zgoubi/coupling/libraries/libinv/sgbmv.f
zgoubi/coupling/libraries/libinv/dsymm.f
zgoubi/coupling/libraries/libinv/zhbmv.f
zgoubi/coupling/libraries/libinv/strsv.f
zgoubi/coupling/libraries/libinv/chpr2.f
zgoubi/coupling/libraries/libinv/sdsdot.f
zgoubi/coupling/libraries/libinv/dspr2.f
zgoubi/coupling/libraries/libinv/ztrsv.f
zgoubi/coupling/libraries/libinv/drotmg.f
zgoubi/coupling/libraries/libinv/sgemm.f
zgoubi/coupling/libraries/libinv/ssbmv.f
zgoubi/coupling/libraries/libinv/determinant-3/cgefa.f
zgoubi/coupling/libraries/libinv/determinant-3/cgeco.f
zgoubi/coupling/libraries/libinv/cgerc.f
zgoubi/coupling/libraries/libinv/dnrm2.f
zgoubi/coupling/libraries/libinv/determinant-1/lin/caxpy.f
zgoubi/coupling/libraries/libinv/determinant-1/lin/cgedi.f
zgoubi/coupling/libraries/libinv/determinant-1/lin/cscal.f
zgoubi/coupling/libraries/libinv/determinant-1/lin/cswap.f
zgoubi/coupling/libraries/libinv/dznrm2.f
zgoubi/coupling/libraries/libinv/chpmv.f
zgoubi/coupling/libraries/libinv/dtbmv.f
zgoubi/coupling/libraries/libinv/ztpmv.f
zgoubi/coupling/libraries/libinv/ctrmv.f
zgoubi/coupling/libraries/libinv/dgetri.f
zgoubi/coupling/libraries/libinv/xerbla.f
zgoubi/coupling/libraries/libinv/zhpr.f
zgoubi/coupling/libraries/libinv/sdot.f
zgoubi/coupling/libraries/libinv/dspmv.f
zgoubi/coupling/libraries/libinv/dasum.f
zgoubi/coupling/libraries/libinv/ztbmv.f
zgoubi/coupling/libraries/libinv/stpsv.f
zgoubi/coupling/libraries/libinv/strsm.f
zgoubi/coupling/libraries/libinv/drotg.f
zgoubi/coupling/libraries/libinv/zdotc.f
zgoubi/coupling/libraries/libinv/scnrm2.f
zgoubi/coupling/libraries/libinv/cgemv.f
zgoubi/coupling/libraries/libinv/stpmv.f
zgoubi/coupling/libraries/libinv/zgerc.f
zgoubi/coupling/libraries/libinv/dsyr2k.f
zgoubi/coupling/libraries/libinv/sspmv.f
zgoubi/coupling/libraries/libinv/ztrmm.f
zgoubi/coupling/libraries/libinv/zaxpy.f
zgoubi/coupling/libraries/libinv/cswap.f
zgoubi/coupling/libraries/libeis/cdiv.f
zgoubi/coupling/libraries/libeis/hqr.f
zgoubi/coupling/libraries/libeis/hqr2.f
zgoubi/coupling/libraries/libeis/balanc.f
zgoubi/coupling/libraries/libeis/eltran.f
zgoubi/coupling/libraries/libeis/balbak.f
zgoubi/coupling/libraries/libeis/elmhes.f
zgoubi/coupling/libraries/libeis/rg.f
zgoubi/coupling/libraries/libdet/caxpy.f
zgoubi/coupling/libraries/libdet/getdet/getdet.f
zgoubi/coupling/libraries/libdet/cgedi.f
zgoubi/coupling/libraries/libdet/cgefa.f
zgoubi/coupling/libraries/libdet/cscal.f
zgoubi/coupling/libraries/libdet/cgeco.f
zgoubi/coupling/libraries/libdet/getdet.f
zgoubi/coupling/libraries/libdet/cswap.f
zgoubi/coupling/tunesc/propag.f
zgoubi/coupling/tunesc/hamilt.f
zgoubi/coupling/tunesc/positi.f
zgoubi/coupling/tunesc/extrac.f
)
target_compile_options(coupl PUBLIC ${common_fflags})

add_library(zgoubi_blas
zgoubi/coupling/libraries/libinv/BLAS/zhemm.f
zgoubi/coupling/libraries/libinv/BLAS/zgeru.f
zgoubi/coupling/libraries/libinv/BLAS/chemm.f
zgoubi/coupling/libraries/libinv/BLAS/caxpy.f
zgoubi/coupling/libraries/libinv/BLAS/drotm.f
zgoubi/coupling/libraries/libinv/BLAS/saxpy.f
zgoubi/coupling/libraries/libinv/BLAS/dtrsv.f
zgoubi/coupling/libraries/libinv/BLAS/cgeru.f
zgoubi/coupling/libraries/libinv/BLAS/srotmg.f
zgoubi/coupling/libraries/libinv/BLAS/dsymv.f
zgoubi/coupling/libraries/libinv/BLAS/zhemv.f
zgoubi/coupling/libraries/libinv/BLAS/chpr.f
zgoubi/coupling/libraries/libinv/BLAS/zgemm.f
zgoubi/coupling/libraries/libinv/BLAS/dger.f
zgoubi/coupling/libraries/libinv/BLAS/crotg.f
zgoubi/coupling/libraries/libinv/BLAS/csscal.f
zgoubi/coupling/libraries/libinv/BLAS/sgemv.f
zgoubi/coupling/libraries/libinv/BLAS/ctpmv.f
zgoubi/coupling/libraries/libinv/BLAS/dtbsv.f
zgoubi/coupling/libraries/libinv/BLAS/sscal.f
zgoubi/coupling/libraries/libinv/BLAS/zcopy.f
zgoubi/coupling/libraries/libinv/BLAS/zher2.f
zgoubi/coupling/libraries/libinv/BLAS/dsbmv.f
zgoubi/coupling/libraries/libinv/BLAS/dsdot.f
zgoubi/coupling/libraries/libinv/BLAS/dtrsm.f
zgoubi/coupling/libraries/libinv/BLAS/dcopy.f
zgoubi/coupling/libraries/libinv/BLAS/sspr.f
zgoubi/coupling/libraries/libinv/BLAS/strmv.f
zgoubi/coupling/libraries/libinv/BLAS/cherk.f
zgoubi/coupling/libraries/libinv/BLAS/ssyr2.f
zgoubi/coupling/libraries/libinv/BLAS/ssyr.f
zgoubi/coupling/libraries/libinv/BLAS/dswap.f
zgoubi/coupling/libraries/libinv/BLAS/dtrmm.f
zgoubi/coupling/libraries/libinv/BLAS/zgbmv.f
zgoubi/coupling/libraries/libinv/BLAS/ssyr2k.f
zgoubi/coupling/libraries/libinv/BLAS/dgemm.f
zgoubi/coupling/libraries/libinv/BLAS/stbsv.f
zgoubi/coupling/libraries/libinv/BLAS/ddot.f
zgoubi/coupling/libraries/libinv/BLAS/cscal.f
zgoubi/coupling/libraries/libinv/BLAS/ctbmv.f
zgoubi/coupling/libraries/libinv/BLAS/lsame.f
zgoubi/coupling/libraries/libinv/BLAS/strmm.f
zgoubi/coupling/libraries/libinv/BLAS/sger.f
zgoubi/coupling/libraries/libinv/BLAS/sspr2.f
zgoubi/coupling/libraries/libinv/BLAS/zscal.f
zgoubi/coupling/libraries/libinv/BLAS/scabs1.f
zgoubi/coupling/libraries/libinv/BLAS/ctpsv.f
zgoubi/coupling/libraries/libinv/BLAS/srotm.f
zgoubi/coupling/libraries/libinv/BLAS/sasum.f
zgoubi/coupling/libraries/libinv/BLAS/scasum.f
zgoubi/coupling/libraries/libinv/BLAS/dscal.f
zgoubi/coupling/libraries/libinv/BLAS/zher.f
zgoubi/coupling/libraries/libinv/BLAS/dsyrk.f
zgoubi/coupling/libraries/libinv/BLAS/zgemv.f
zgoubi/coupling/libraries/libinv/BLAS/zdotu.f
zgoubi/coupling/libraries/libinv/BLAS/csymm.f
zgoubi/coupling/libraries/libinv/BLAS/dgemv.f
zgoubi/coupling/libraries/libinv/BLAS/ztpsv.f
zgoubi/coupling/libraries/libinv/BLAS/zswap.f
zgoubi/coupling/libraries/libinv/BLAS/dzasum.f
zgoubi/coupling/libraries/libinv/BLAS/zsyr2k.f
zgoubi/coupling/libraries/libinv/BLAS/ztrmv.f
zgoubi/coupling/libraries/libinv/BLAS/ztrsm.f
zgoubi/coupling/libraries/libinv/BLAS/zsymm.f
zgoubi/coupling/libraries/libinv/BLAS/ssyrk.f
zgoubi/coupling/libraries/libinv/BLAS/scopy.f
zgoubi/coupling/libraries/libinv/BLAS/csyrk.f
zgoubi/coupling/libraries/libinv/BLAS/chbmv.f
zgoubi/coupling/libraries/libinv/BLAS/srotg.f
zgoubi/coupling/libraries/libinv/BLAS/cdotc.f
zgoubi/coupling/libraries/libinv/BLAS/cdotu.f
zgoubi/coupling/libraries/libinv/BLAS/stbmv.f
zgoubi/coupling/libraries/libinv/BLAS/ctrsm.f
zgoubi/coupling/libraries/libinv/BLAS/zrotg.f
zgoubi/coupling/libraries/libinv/BLAS/dtrmv.f
zgoubi/coupling/libraries/libinv/BLAS/zher2k.f
zgoubi/coupling/libraries/libinv/BLAS/cgemm.f
zgoubi/coupling/libraries/libinv/BLAS/drot.f
zgoubi/coupling/libraries/libinv/BLAS/csrot.f
zgoubi/coupling/libraries/libinv/BLAS/dtpmv.f
zgoubi/coupling/libraries/libinv/BLAS/csyr2k.f
zgoubi/coupling/libraries/libinv/BLAS/cher.f
zgoubi/coupling/libraries/libinv/BLAS/snrm2.f
zgoubi/coupling/libraries/libinv/BLAS/ssymv.f
zgoubi/coupling/libraries/libinv/BLAS/zsyrk.f
zgoubi/coupling/libraries/libinv/BLAS/ctrsv.f
zgoubi/coupling/libraries/libinv/BLAS/zhpr2.f
zgoubi/coupling/libraries/libinv/BLAS/ctbsv.f
zgoubi/coupling/libraries/libinv/BLAS/dgbmv.f
zgoubi/coupling/libraries/libinv/BLAS/ctrmm.f
zgoubi/coupling/libraries/libinv/BLAS/dcabs1.f
zgoubi/coupling/libraries/libinv/BLAS/srot.f
zgoubi/coupling/libraries/libinv/BLAS/daxpy.f
zgoubi/coupling/libraries/libinv/BLAS/dsyr.f
zgoubi/coupling/libraries/libinv/BLAS/zdrot.f
zgoubi/coupling/libraries/libinv/BLAS/ccopy.f
zgoubi/coupling/libraries/libinv/BLAS/zdscal.f
zgoubi/coupling/libraries/libinv/BLAS/dspr.f
zgoubi/coupling/libraries/libinv/BLAS/icamax.f
zgoubi/coupling/libraries/libinv/BLAS/dsyr2.f
zgoubi/coupling/libraries/libinv/BLAS/cgbmv.f
zgoubi/coupling/libraries/libinv/BLAS/cher2k.f
zgoubi/coupling/libraries/libinv/BLAS/isamax.f
zgoubi/coupling/libraries/libinv/BLAS/ztbsv.f
zgoubi/coupling/libraries/libinv/BLAS/chemv.f
zgoubi/coupling/libraries/libinv/BLAS/dtpsv.f
zgoubi/coupling/libraries/libinv/BLAS/cher2.f
zgoubi/coupling/libraries/libinv/BLAS/zhpmv.f
zgoubi/coupling/libraries/libinv/BLAS/zherk.f
zgoubi/coupling/libraries/libinv/BLAS/idamax.f
zgoubi/coupling/libraries/libinv/BLAS/ssymm.f
zgoubi/coupling/libraries/libinv/BLAS/sswap.f
zgoubi/coupling/libraries/libinv/BLAS/izamax.f
zgoubi/coupling/libraries/libinv/BLAS/sgbmv.f
zgoubi/coupling/libraries/libinv/BLAS/dsymm.f
zgoubi/coupling/libraries/libinv/BLAS/zhbmv.f
zgoubi/coupling/libraries/libinv/BLAS/strsv.f
zgoubi/coupling/libraries/libinv/BLAS/chpr2.f
zgoubi/coupling/libraries/libinv/BLAS/sdsdot.f
zgoubi/coupling/libraries/libinv/BLAS/dspr2.f
zgoubi/coupling/libraries/libinv/BLAS/ztrsv.f
zgoubi/coupling/libraries/libinv/BLAS/drotmg.f
zgoubi/coupling/libraries/libinv/BLAS/sgemm.f
zgoubi/coupling/libraries/libinv/BLAS/ssbmv.f
zgoubi/coupling/libraries/libinv/BLAS/cgerc.f
zgoubi/coupling/libraries/libinv/BLAS/dnrm2.f
zgoubi/coupling/libraries/libinv/BLAS/dznrm2.f
zgoubi/coupling/libraries/libinv/BLAS/chpmv.f
zgoubi/coupling/libraries/libinv/BLAS/dtbmv.f
zgoubi/coupling/libraries/libinv/BLAS/ztpmv.f
zgoubi/coupling/libraries/libinv/BLAS/ctrmv.f
zgoubi/coupling/libraries/libinv/BLAS/xerbla.f
zgoubi/coupling/libraries/libinv/BLAS/zhpr.f
zgoubi/coupling/libraries/libinv/BLAS/sdot.f
zgoubi/coupling/libraries/libinv/BLAS/dspmv.f
zgoubi/coupling/libraries/libinv/BLAS/dasum.f
zgoubi/coupling/libraries/libinv/BLAS/ztbmv.f
zgoubi/coupling/libraries/libinv/BLAS/stpsv.f
zgoubi/coupling/libraries/libinv/BLAS/strsm.f
zgoubi/coupling/libraries/libinv/BLAS/drotg.f
zgoubi/coupling/libraries/libinv/BLAS/zdotc.f
zgoubi/coupling/libraries/libinv/BLAS/scnrm2.f
zgoubi/coupling/libraries/libinv/BLAS/cgemv.f
zgoubi/coupling/libraries/libinv/BLAS/stpmv.f
zgoubi/coupling/libraries/libinv/BLAS/zgerc.f
zgoubi/coupling/libraries/libinv/BLAS/dsyr2k.f
zgoubi/coupling/libraries/libinv/BLAS/sspmv.f
zgoubi/coupling/libraries/libinv/BLAS/ztrmm.f
zgoubi/coupling/libraries/libinv/BLAS/zaxpy.f
zgoubi/coupling/libraries/libinv/BLAS/cswap.f
)
target_compile_options(zgoubi_blas PUBLIC ${common_fflags})

add_library(zg
common/gttext.f
common/rhist.f
common/rndm.f
common/vscal.f
common/time2.f
common/vvect.f
common/empty.f
common/strcon.f
common/strget.f
common/raz.f
common/rffag.f
common/endjob.f
common/date2.f
common/iraz.f
)
target_compile_options(zg PUBLIC ${common_fflags})

add_executable( zgoubi
zgoubi/et2res.f
zgoubi/rtrans.f
zgoubi/rbinar.f
zgoubi/toserr.f
zgoubi/matric.f
zgoubi/accen.f
zgoubi/rcavit.f
zgoubi/ellipt.f
zgoubi/rundul.f
zgoubi/rspinr.f
zgoubi/gaussq.f
zgoubi/gang.f
zgoubi/option.f
zgoubi/ksmap.f
zgoubi/gg.f
zgoubi/rspnst.f
zgoubi/scalin.f
zgoubi/agsblw.f
zgoubi/solbax.f
zgoubi/nmfonc.f
zgoubi/zgoubi.f
zgoubi/rgoto.f
zgoubi/block.f
zgoubi/cntinl.f
zgoubi/vrble.f
zgoubi/multip.f
zgoubi/svdcos.f
zgoubi/objets.f
zgoubi/initra.f
zgoubi/coilsf.f
zgoubi/obj102.f
zgoubi/polmes.f
zgoubi/wienfi.f
zgoubi/cinema.f
zgoubi/opticc.f
zgoubi/funcd.f
zgoubi/mcobj3.f
zgoubi/jcentr.f
zgoubi/robjta.f
zgoubi/fitest.f
zgoubi/bi1.f
zgoubi/rfaist.f
zgoubi/matimc.f
zgoubi/ray102.f
zgoubi/agsqua.f
zgoubi/esl.f
zgoubi/rms.f
zgoubi/inidat.f
zgoubi/mat3tr.f
zgoubi/erexyz.f
zgoubi/agsmma.f
zgoubi/rqsod.f
zgoubi/rsolen.f
zgoubi/bb.f
zgoubi/errors.f
zgoubi/iter.f
zgoubi/interm.f
zgoubi/lpsfit.f
zgoubi/ctrlc.f
zgoubi/imptra.f
zgoubi/spnrot.f
zgoubi/svdpus.f
zgoubi/el2tu.f
zgoubi/elcmii.f
zgoubi/flush2.f
zgoubi/getllb.f
zgoubi/event.f
zgoubi/rmcdes.f
zgoubi/impvar.f
zgoubi/impctr.f
zgoubi/bbklm.f
zgoubi/rpckup.f
zgoubi/charef.f
zgoubi/stpsiz.f
zgoubi/rspn.f
zgoubi/bonul.f
zgoubi/razs.f
zgoubi/gasini.f
zgoubi/unipot.f
zgoubi/razdrv.f
zgoubi/vequal.f
zgoubi/eplate.f
zgoubi/serv5.f
zgoubi/mcdesi.f
zgoubi/ffspd.f
zgoubi/beaimp.f
zgoubi/mapshf.f
zgoubi/intpl3.f
zgoubi/slalain.f
zgoubi/nmmin1.f
zgoubi/bndth.f
zgoubi/agsmmf.f
zgoubi/svdinv.f
zgoubi/boost.f
zgoubi/okkt3.f
zgoubi/chamc.f
zgoubi/getnol.f
zgoubi/okprlb.f
zgoubi/map2d.f
zgoubi/fitnu.f
zgoubi/desbin.f
zgoubi/bblmap.f
zgoubi/cofin.f
zgoubi/ffspd2.f
zgoubi/fitgtv.f
zgoubi/drvg.f
zgoubi/impcsr.f
zgoubi/spach.f
zgoubi/mat3ca.f
zgoubi/end.f
zgoubi/ellip.f
zgoubi/mcdes.f
zgoubi/baxbxr.f
zgoubi/replat.f
zgoubi/kstop.f
zgoubi/histab.f
zgoubi/rparti.f
zgoubi/getdst.f
zgoubi/rotx.f
zgoubi/ererz.f
zgoubi/matimp.f
zgoubi/idluni.f
zgoubi/brevol.f
zgoubi/intplf.f
zgoubi/rcoils.f
zgoubi/elcylf.f
zgoubi/trobj.f
zgoubi/rtnewt2.f
zgoubi/gascat.f
zgoubi/interv.f
zgoubi/svd/DORGLQ.f
zgoubi/svd/DORMBR.f
zgoubi/svd/DLASQ4.f
zgoubi/svd/DORMLQ.f
zgoubi/svd/XERBLA.f
zgoubi/svd/DLASQ1.f
zgoubi/svd/DGEMV.f
zgoubi/svd/DSWAP.f
zgoubi/svd/IEEECK.f
zgoubi/svd/LSAME.f
zgoubi/svd/DGELQ2.f
zgoubi/svd/DORML2.f
zgoubi/svd/DORM2R.f
zgoubi/svd/DLAMC3.f
zgoubi/svd/DLAS2.f
zgoubi/svd/DGEBRD.f
zgoubi/svd/SVD.f
zgoubi/svd/DORGQR.f
zgoubi/svd/DLASSQ.f
zgoubi/svd/ILAENV.f
zgoubi/svd/DTRMM.f
zgoubi/svd/DGEQR2.f
zgoubi/svd/DLASET.f
zgoubi/svd/DORMQR.f
zgoubi/svd/DLASQ6.f
zgoubi/svd/DISNAN.f
zgoubi/svd/IPARMQ.f
zgoubi/svd/DLASR.f
zgoubi/svd/DLABRD.f
zgoubi/svd/DLAISNAN.f
zgoubi/svd/DTRMV.f
zgoubi/svd/DORGBR.f
zgoubi/svd/DLASRT.f
zgoubi/svd/DLANGE.f
zgoubi/svd/DLAMCH.f
zgoubi/svd/ILADLR.f
zgoubi/svd/DORG2R.f
zgoubi/svd/DGER.f
zgoubi/svd/DNRM2.f
# zgoubi/svd/extract.f # another main program
zgoubi/svd/DLARFG.f
zgoubi/svd/DLASV2.f
zgoubi/svd/DSCAL.f
zgoubi/svd/DGELQF.f
zgoubi/svd/DLACPY.f
zgoubi/svd/DGESVD.f
zgoubi/svd/DROT.f
zgoubi/svd/DLASQ2.f
zgoubi/svd/DGEBD2.f
zgoubi/svd/DLARFT.f
zgoubi/svd/DCOPY.f
zgoubi/svd/ILADLC.f
zgoubi/svd/DGEQRF.f
zgoubi/svd/DLARFB.f
zgoubi/svd/DLASQ5.f
zgoubi/svd/DBDSQR.f
zgoubi/svd/DGEMM.f
#zgoubi/svd/LAPACK.f
zgoubi/svd/DLARF.f
zgoubi/svd/DLAPY2.f
zgoubi/svd/DLASQ3.f
zgoubi/svd/DORGL2.f
zgoubi/svd/DLASCL.f
zgoubi/svd/DLARTG.f
zgoubi/rebmul.f
zgoubi/scumul.f
zgoubi/objerr.f
zgoubi/rwienf.f
zgoubi/itail.f
zgoubi/rnorma.f
zgoubi/drtent.f
zgoubi/spnprt.f
zgoubi/rcyclo.f
zgoubi/ctrlb.f
zgoubi/emmap.f
zgoubi/ff.f
zgoubi/solv.f
zgoubi/relcyl.f
zgoubi/agsquf.f
zgoubi/svdpck.f
zgoubi/traobj.f
zgoubi/apdpo.f
zgoubi/geneta.f
zgoubi/apdpo1.f
zgoubi/transm.f
zgoubi/twifnl.f
zgoubi/focal1.f
zgoubi/bendf.f
zgoubi/rndm.F
zgoubi/spinro.f
zgoubi/rsrlos.f
zgoubi/coeffs.f
zgoubi/dist2.f
zgoubi/sbendi.f
zgoubi/pvect.f
zgoubi/majtra.f
zgoubi/cible.f
zgoubi/svdoc.f
zgoubi/strwld.f
zgoubi/chxp.f
zgoubi/rdipc.f
zgoubi/trarot.f
zgoubi/elmirf.f
zgoubi/relcmi.f
zgoubi/mcobj.f
zgoubi/lnul.f
zgoubi/carshi.f
zgoubi/ffspd3.f
zgoubi/spnmat.f
zgoubi/rebel.f
zgoubi/separa.f
zgoubi/mat3rd.f
zgoubi/hist.f
zgoubi/normb.f
zgoubi/mat1.f
zgoubi/dstefb.f
zgoubi/go2end.f
zgoubi/obj8.f
zgoubi/rsolve.f
zgoubi/aimant.f
zgoubi/straco.f
zgoubi/agsk12.f
zgoubi/dist3.f
zgoubi/tunes.f
zgoubi/helix.f
zgoubi/modord.f
zgoubi/minonm.f
zgoubi/track.f
zgoubi/rautor.f
zgoubi/impaju.f
zgoubi/rchang.f
zgoubi/inicin.f
zgoubi/chamb.f
zgoubi/tworbt.f
zgoubi/poidev.f
zgoubi/transf.f
zgoubi/adpol.f
zgoubi/splint.f
zgoubi/fborne.f
zgoubi/agsks.f
zgoubi/rdips.f
zgoubi/rotz.f
zgoubi/toroid.f
zgoubi/itavan.f
zgoubi/dispu.f
zgoubi/trace.f
zgoubi/sref.f
zgoubi/partic.f
zgoubi/rmcobj.f
zgoubi/dstefb2.f
zgoubi/tunesc.f
zgoubi/impplt.f
zgoubi/obj6.f
zgoubi/delta.f
zgoubi/rbend.f
zgoubi/pltdat.f
zgoubi/go2key.f
zgoubi/dejaca.f
zgoubi/vzero.f
zgoubi/pmat.f
zgoubi/itsens.f
zgoubi/bndthi.f
zgoubi/lstset.f
zgoubi/reset.f
zgoubi/zerof.f
zgoubi/scal0.f
zgoubi/impdev.f
zgoubi/solenf.f
zgoubi/srloss.f
zgoubi/coils.f
zgoubi/srprn.f
zgoubi/rcible.f
zgoubi/chamk.f
zgoubi/arrier.f
zgoubi/raiman.f
zgoubi/refer.f
zgoubi/bendi.f
zgoubi/peu.f
zgoubi/dipolm.f
zgoubi/rdampe.f
zgoubi/rel2tu.f
zgoubi/spnprn.f
zgoubi/devtra.f
zgoubi/prdata.f
zgoubi/rspach.f
zgoubi/sympl.f
zgoubi/rscal.f
zgoubi/wedgki.f
zgoubi/rcsr.f
zgoubi/fitsta.f
zgoubi/fgf.f
zgoubi/okkp3.f
zgoubi/mat2.f
zgoubi/checks.f
zgoubi/focale.f
zgoubi/soleno.f
zgoubi/isnum.f
zgoubi/elcylm.f
zgoubi/toscap.f
zgoubi/gasesl.f
zgoubi/normal.f
zgoubi/multpo.f
zgoubi/gotol.f
zgoubi/binari.f
zgoubi/agsmm.f
zgoubi/lingua.f
zgoubi/toscac.f
zgoubi/rmulti.f
zgoubi/serv2.f
zgoubi/debstr.f
zgoubi/undulf.f
zgoubi/krtax.f
zgoubi/bxrxyz.f
zgoubi/fitarr.f
zgoubi/chmbr.f
zgoubi/rbb.f
zgoubi/ragsmm.f
zgoubi/dbdxyz.f
zgoubi/ffgspi.f
zgoubi/rffag.f
zgoubi/pickup.f
zgoubi/csri.f
zgoubi/agsqks.f
zgoubi/unipo.f
zgoubi/ident.f
zgoubi/syntrk.f
zgoubi/roptio.f
zgoubi/fitlav.f
zgoubi/spntrk.f
zgoubi/collim.f
zgoubi/cntpar.f
zgoubi/butee.f
zgoubi/el2tub.f
zgoubi/zgoubi_main.f
zgoubi/rbndth.f
zgoubi/rmatrx.f
zgoubi/beamat.f
zgoubi/fmapw.f
zgoubi/prsr.f
zgoubi/bbrsp.f
zgoubi/pckup.f
zgoubi/funcd2.f
zgoubi/maplim.f
zgoubi/objeta.f
zgoubi/cyclo.f
zgoubi/open2.f
zgoubi/csrint.f
zgoubi/dipi.f
zgoubi/chrefe.f
zgoubi/twssfc.f
zgoubi/fitmm.f
zgoubi/mino1.f
zgoubi/elcyld.f
zgoubi/integr.f
zgoubi/chamk1.f
zgoubi/obj3.f
zgoubi/apherf.f
zgoubi/chxc.f
zgoubi/rsepar.f
zgoubi/cavite.f
zgoubi/pavel.f
zgoubi/mix.f
zgoubi/carla.f
zgoubi/serv34.f
zgoubi/rdip.f
zgoubi/raysyn.f
zgoubi/rsvdoc.f
zgoubi/eslvir.f
zgoubi/cubspl.f
zgoubi/appen.f
zgoubi/rfit.f
zgoubi/eaxial.f
zgoubi/valqv.f
zgoubi/quasex.f
zgoubi/tridi.f
zgoubi/xrotb.f
zgoubi/funct.f
zgoubi/fitlma.f
zgoubi/elcmid.f
zgoubi/endjob.f
zgoubi/spn.f
zgoubi/relmir.f
zgoubi/cptfct.f
zgoubi/fitexp.f
zgoubi/ffagi.f
zgoubi/svdpr.f
zgoubi/binary.f
zgoubi/rtnewt.f
zgoubi/icentr.f
zgoubi/runipo.f
zgoubi/getnam.f
zgoubi/unduli.f
zgoubi/rellip.f
zgoubi/rhelix.f
zgoubi/scaler.f
zgoubi/mulerr.f
zgoubi/eax3tu.f
zgoubi/avorpr.f
zgoubi/gammln.f
zgoubi/revers.f
zgoubi/fitset.f
zgoubi/serv32.f
zgoubi/eplatf.f
zgoubi/rempli.f
zgoubi/rerror.f
zgoubi/header.f
zgoubi/damper.f
zgoubi/bb4g.f
zgoubi/bi1p.f
zgoubi/lstins.f
zgoubi/mcdesl.f
zgoubi/xnorm.f
zgoubi/rcarte.f
zgoubi/autorf.f
zgoubi/chmbre.f
zgoubi/inidrt.f
zgoubi/rgasca.f
zgoubi/synpar.f
zgoubi/chanrf.f
zgoubi/trrote.f
zgoubi/spinr.f
zgoubi/twiss.f
zgoubi/fitwda.f
zgoubi/path.f
zgoubi/lign.f
zgoubi/mcobj1.f
zgoubi/rdpois.f
zgoubi/robjet.f
zgoubi/dpkick.f
zgoubi/mksa.f
zgoubi/emmac.f
zgoubi/obj61.f
zgoubi/mat3av.f
zgoubi/rsimb.f
zgoubi/accep.f
zgoubi/serv4.f
zgoubi/elcmif.f
zgoubi/rrebel.f
zgoubi/symmed.f
zgoubi/obj9.f
zgoubi/dipsi.f
zgoubi/remma.f
zgoubi/lpsfi4.f
zgoubi/ragsqu.f
zgoubi/rtosca.f
zgoubi/finstr.f
zgoubi/rcolli.f
zgoubi/dipci.f
zgoubi/impfai.f
zgoubi/ymoiny.f
zgoubi/endfit.f
zgoubi/nmmin.f
zgoubi/dlgau.f
zgoubi/bbkck.f
zgoubi/reblt.f
zgoubi/elmiri.f
zgoubi/besknu.f
zgoubi/obj5.f
zgoubi/rfitgt.f
zgoubi/optimp.f
zgoubi/chreg.f
zgoubi/depla.f
modules/dynhc.f
)
target_compile_options(zgoubi PRIVATE ${common_fflags})
target_link_libraries(zgoubi zgoubi_blas zg coupl)

include_directories(zpop include)

if ( "${CMAKE_SYSTEM_NAME}" MATCHES "Linux" )
  add_definitions(-DLINUX)
elseif ( "${CMAKE_SYSTEM_NAME}" MATCHES "Darwin" )
  add_definitions(-DDARWIN)
else()
  message(WARNING "Untested operating system: ${CMAKE_SYSTEM_NAME}. Report any issues at ${issues_URL}")
  add_definitions(-DLINUX)
endif()

add_library(fminigraf
  zpop/liblns/fminigraf.c
  )
target_compile_options(fminigraf PUBLIC -g)

add_executable(zpop
zpop/rtrans.f
zpop/rbinar.f
zpop/speana.f
zpop/binarf.f
zpop/spctra.f
zpop/rcavit.f
zpop/rundul.f
zpop/clorbi.f
zpop/speimp.f
zpop/inpech.f
zpop/fmtcgr.f
zpop/dsherm.f
zpop/tracsy.f
zpop/pltlps.f
zpop/hmtcgr.f
zpop/diagq.f
zpop/lpsdrw.f
zpop/menvcf.f
zpop/block.f
zpop/mnzgra.f
zpop/fmatch.f
zpop/minmax.f
zpop/srdwc.f
zpop/robjta.f
zpop/okkp.f
zpop/synaxe.f
zpop/prtime.f
zpop/rqsod.f
zpop/rsolen.f
zpop/trtxt.f
zpop/srdwsc.f
zpop/lpsfit.f
zpop/homclr.f
zpop/zgoubi_plot.f
zpop/plthis.f
zpop/hmatch.f
zpop/flush2.f
zpop/idlg.f
zpop/rmcdes.f
zpop/srdwm.f
zpop/erf.f
zpop/endvcf.f
zpop/inrang.f
zpop/srinm.f
zpop/rspn.f
zpop/ppar.f
zpop/rfmtch.f
zpop/ploter.f
zpop/caltra.f
zpop/idluni.f
zpop/superp.f
zpop/dfring.f
zpop/rcoils.f
zpop/rscale.f
zpop/rebmul.f
zpop/agsddq.f
zpop/rwienf.f
zpop/rnorma.f
zpop/spedrw.f
zpop/relcyl.f
zpop/okkl.f
zpop/prdip.f
zpop/square.f
zpop/synbox.f
zpop/opnwrn.f
zpop/rsrlos.f
zpop/opnmnl.f
zpop/caltri.f
zpop/srmodl.f
zpop/relcmi.f
zpop/unitr.f
zpop/typtra.f
zpop/graph8.f
zpop/rautor.f
zpop/opngnu.f
zpop/spegr.f
zpop/help.f
zpop/rdips.f
zpop/drawspi.f
zpop/pltemi.f
zpop/class.f
zpop/savplt.f
zpop/fringe.f
zpop/sref.f
zpop/rmcobj.f
zpop/fmag.f
zpop/razi.f
zpop/srplt.f
zpop/inigr.f
zpop/rbend.f
zpop/isofld.f
zpop/srmdl1.f
zpop/rcible.f
zpop/raiman.f
zpop/lips.f
zpop/rel2tu.f
zpop/prdata.f
zpop/rcsr.f
zpop/lintyp.f
zpop/agsmdl.f
zpop/funk.f
zpop/readco.f
zpop/srpli.f
zpop/match.f
zpop/rmulti.f
zpop/debstr.f
zpop/ragsmm.f
zpop/rffag.f
zpop/srdnu.f
zpop/doree.f
zpop/spepr.f
zpop/rffags.f
zpop/srplv.f
zpop/srinc.f
zpop/opndef.f
zpop/prffag.f
zpop/rmatrx.f
zpop/srdwpl.f
zpop/srefm.f
zpop/filcoo.f
zpop/tylab.f
zpop/traxes.f
zpop/graph7.f
zpop/inpvar.f
zpop/rsepar.f
zpop/rewin2.f
zpop/storig.f
zpop/hermit.f
zpop/pltopt.f
zpop/rfit.f
zpop/okkt.f
zpop/begvcf.f
zpop/relmir.f
zpop/plhist.f
zpop/amini.f
zpop/srdw.f
zpop/pllips.f
zpop/runipo.f
zpop/bin.f
zpop/rhelix.f
zpop/opnmn.f
zpop/diagnu.f
zpop/storco.f
zpop/shermi.f
zpop/gk1.f
zpop/lpscnt.f
zpop/header.f
zpop/drctry.f
zpop/rcarte.f
zpop/rgasca.f
zpop/clscr.f
zpop/trkvar.f
zpop/robjet.f
zpop/rhmtch.f
zpop/ravorb.f
zpop/srmen.f
zpop/vectpl.f
zpop/rsimb.f
zpop/xyzbr.f
zpop/insy.f
zpop/srax.f
zpop/ragsqu.f
zpop/asinh.f
zpop/srdwst.f
zpop/finstr.f
zpop/rcolli.f
zpop/plinit.f
zpop/impv.f
zpop/rfitgt.f
zpop/prarc.f
zpop/grad.f
zpop/lastp.f
)
target_compile_options(zpop PRIVATE ${common_fflags})
target_link_libraries(zpop zg fminigraf)

# Set installation subdirectory for executable files
install(
  TARGETS zgoubi zpop
  DESTINATION bin
  PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
)

# Set installation subdirectory for libraries
if(BUILD_SHARED_LIBS)
  install(
    TARGETS zg fminigraf coupl zgoubi_blas
    DESTINATION lib
    PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ
    )
endif()

enable_testing()

set(ZGOUBI_SOURCE_DIR ${CMAKE_SOURCE_DIR} )
set(ZGOUBI_TEST_SRC_DIR ${CMAKE_SOURCE_DIR}/tests )
set(ZGOUBI_EXAMPLE_SRC_DIR ${CMAKE_SOURCE_DIR}/exemples/KEYWORDS/FIT/FIT_embedded_in_REBELOTE )
set(ZGOUBI_TEST_BIN_DIR ${CMAKE_BINARY_DIR}/tests )

set( example_input_files
  centeredHelix_FIT_save_nofinal_150226.res
)

foreach(input_file ${example_input_files})
  configure_file(
    ${ZGOUBI_TEST_SRC_DIR}/${input_file}
    ${ZGOUBI_TEST_BIN_DIR}/${input_file}
    COPYONLY
  )
endforeach()
configure_file(
  "${ZGOUBI_TEST_SRC_DIR}/zgoubi-integration-test.sh.template"
  "${ZGOUBI_TEST_BIN_DIR}/zgoubi-integration-test.sh"
@ONLY
)
configure_file(
  "${ZGOUBI_TEST_SRC_DIR}/zgoubi.res.expected"
  "${ZGOUBI_TEST_BIN_DIR}/zgoubi.res.expected"
@ONLY
)
set(ZGOUBI_TEST_IZ 29)
set(ZGOUBI_TEST_ID  3)
set(ZGOUBI_TEST_MMAP 1)
configure_file(
  "${ZGOUBI_TEST_SRC_DIR}/PARIZ_cmake_configurable.H"
  "${ZGOUBI_TEST_BIN_DIR}/PARIZ.H"
@ONLY
)
include_directories(BEFORE ${ZGOUBI_TEST_BIN_DIR} zgoubi include)

add_test(NAME zgoubi-integration COMMAND "${ZGOUBI_TEST_BIN_DIR}/zgoubi-integration-test.sh")
set_tests_properties(zgoubi-integration PROPERTIES PASS_REGULAR_EXPRESSION "Test passed.")
