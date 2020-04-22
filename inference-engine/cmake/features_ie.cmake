# Copyright (C) 2018-2020 Intel Corporation
# SPDX-License-Identifier: Apache-2.0
#

include (target_flags)
include (options)

#these options are aimed to optimize build time on development system

ie_dependent_option (ENABLE_GNA "GNA support for inference engine" OFF "NOT APPLE;NOT ANDROID;X86 OR X86_64" OFF)

ie_dependent_option (ENABLE_CLDNN_TESTS "Enable clDNN unit tests" OFF "ENABLE_CLDNN" OFF)

ie_dependent_option (ENABLE_PROFILING_ITT "ITT tracing of IE and plugins internals" OFF "NOT CMAKE_CROSSCOMPILING" OFF)

# "MKL-DNN library might use MKL-ML or OpenBLAS for gemm tasks: MKL|OPENBLAS|JIT"
if (ENABLE_MKL_DNN)
    if(AARCH64)
        set(GEMM_DEFAULT "OPENBLAS")
    else()
        set(GEMM_DEFAULT "JIT")
    endif()
    set(GEMM "${GEMM_DEFAULT}" CACHE STRING "GEMM implementation")
    set_property(CACHE GEMM PROPERTY STRINGS "MKL" "OPENBLAS" "JIT")
    list (APPEND IE_OPTIONS GEMM)
    if (NOT GEMM STREQUAL "MKL" AND
        NOT GEMM STREQUAL "OPENBLAS" AND
        NOT GEMM STREQUAL "JIT")
        message(FATAL_ERROR "GEMM should be set to MKL, OPENBLAS or JIT. Default option is ${GEMM_DEFAULT}")
    endif()
endif()

# "MKL-DNN library based on OMP or TBB or Sequential implementation: TBB|OMP|SEQ"
if(ARM)
    set(THREADING_DEFAULT "SEQ")
else()
    set(THREADING_DEFAULT "TBB")
endif()
set(THREADING "${THREADING_DEFAULT}" CACHE STRING "Threading")
set_property(CACHE THREADING PROPERTY STRINGS "TBB" "TBB_AUTO" "OMP" "SEQ")
list (APPEND IE_OPTIONS THREADING)
if (NOT THREADING STREQUAL "TBB" AND
    NOT THREADING STREQUAL "TBB_AUTO" AND
    NOT THREADING STREQUAL "OMP" AND
    NOT THREADING STREQUAL "SEQ")
    message(FATAL_ERROR "THREADING should be set to TBB, TBB_AUTO, OMP or SEQ. Default option is ${THREADING_DEFAULT}")
endif()

if (ENABLE_GNA)
    if (UNIX AND NOT APPLE AND CMAKE_COMPILER_IS_GNUCC AND CMAKE_CXX_COMPILER_VERSION VERSION_LESS 5.4)
        set (DEFAULT_GNA_LIB GNA1)
    else()
        set (DEFAULT_GNA_LIB GNA1_1401)
    endif()
    set(GNA_LIBRARY_VERSION "${DEFAULT_GNA_LIB}" CACHE STRING "GNAVersion")
    set_property(CACHE GNA_LIBRARY_VERSION PROPERTY STRINGS "GNA1" "GNA1_1401" "GNA2")
    list (APPEND IE_OPTIONS GNA_LIBRARY_VERSION)
    if (NOT GNA_LIBRARY_VERSION STREQUAL "GNA1" AND
        NOT GNA_LIBRARY_VERSION STREQUAL "GNA1_1401" AND
        NOT GNA_LIBRARY_VERSION STREQUAL "GNA2")
        message(FATAL_ERROR "GNA_LIBRARY_VERSION should be set to GNA1, GNA1_1401 or GNA2. Default option is ${DEFAULT_GNA_LIB}")
    endif()
endif()

ie_option (ENABLE_IR_READER "Compile with IR readers / parsers" ON)

ie_option (ENABLE_VPU "vpu targeted plugins for inference engine" ON)

ie_dependent_option (ENABLE_MYRIAD "myriad targeted plugin for inference engine" ON "ENABLE_VPU" OFF)

ie_dependent_option (ENABLE_MYRIAD_NO_BOOT "myriad plugin will skip device boot" OFF "ENABLE_MYRIAD" OFF)

ie_option (ENABLE_TESTS "unit, behavior and functional tests" OFF)

ie_dependent_option (ENABLE_GAPI_TESTS "tests for GAPI kernels" OFF "ENABLE_TESTS" OFF)

ie_dependent_option (GAPI_TEST_PERF "if GAPI unit tests should examine performance" OFF "ENABLE_GAPI_TESTS" OFF)

ie_dependent_option (ENABLE_MYRIAD_MVNC_TESTS "functional and behavior tests for mvnc api" OFF "ENABLE_TESTS;ENABLE_MYRIAD" OFF)

ie_dependent_option (ENABLE_SAMPLES "console samples are part of inference engine package" ON "NOT MINGW" OFF)

ie_dependent_option (ENABLE_BEH_TESTS "tests oriented to check inference engine API corecteness" ON "ENABLE_TESTS" OFF)

ie_dependent_option (ENABLE_FUNCTIONAL_TESTS "functional tests" ON "ENABLE_TESTS;ENABLE_IR_READER" OFF)

ie_dependent_option (ENABLE_SAMPLES "console samples are part of inference engine package" ON "NOT MINGW" OFF)

ie_option (ENABLE_FUZZING "instrument build for fuzzing" OFF)

ie_option (VERBOSE_BUILD "shows extra information about build" OFF)

ie_option (ENABLE_UNSAFE_LOCATIONS "skip check for MD5 for dependency" OFF)

ie_option (ENABLE_ALTERNATIVE_TEMP "in case of dependency conflict, to avoid modification in master, use local copy of dependency" ON)

ie_option (ENABLE_OPENCV "enables OpenCV" ON)

ie_option (ENABLE_DEBUG_SYMBOLS "generates symbols for debugging" OFF)

ie_option (ENABLE_PYTHON "enables ie python bridge build" OFF)

ie_option (ENABLE_CPP_CCT "enables C++ version of Cross Check Tool" OFF)

ie_option (ENABLE_C "enables ie c bridge build" ON)

ie_dependent_option(ENABLE_CPPLINT "Enable cpplint checks during the build" OFF "OFF;UNIX;NOT APPLE;NOT ANDROID" OFF)
ie_dependent_option(ENABLE_CPPLINT_REPORT "Build cpplint report instead of failing the build" OFF "ENABLE_CPPLINT" OFF)

ie_option(ENABLE_CLANG_FORMAT "Enable clang-format checks during the build" OFF)

set(IE_EXTRA_PLUGINS "" CACHE STRING "Extra paths for plugins to include into DLDT build tree")

ie_dependent_option(ENABLE_TBB_RELEASE_ONLY "Only Release TBB libraries are linked to the Inference Engine binaries" ON "THREADING MATCHES TBB;LINUX" OFF)
