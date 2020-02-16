#Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

# This is copied from:
#   https://github.com/vector-of-bool/CMakeCM/blob/master/modules/FindFilesystem.cmake

#[=======================================================================[.rst:

BoostFilesystem
####################

This module supports the C++17 standard library's filesystem utilities.

Options
*******

The ``COMPONENTS`` argument to this module supports the following values:

.. find-component:: Experimental
	 :name: fs.Experimental

	 Allows the module to find the "experimental" Filesystem TS version of the
	 Filesystem library. This is the library that should be used with the
	 ``std::experimental::filesystem`` namespace.

.. find-component:: Final
	 :name: fs.Final

	 Finds the final C++17 standard version of the filesystem library.

If no components are provided, behaves as if the
:find-component:`fs.Final` component was specified.

If both :find-component:`fs.Experimental` and :find-component:`fs.Final` are
provided, first looks for ``Final``, and falls back to ``Experimental`` in case
of failure. If ``Final`` is found, :imp-target:`std::filesystem` and all
:ref:`variables <fs.variables>` will refer to the ``Final`` version.


Imported Targets
****************

.. imp-target:: std::filesystem

	 The ``std::filesystem`` imported target is defined when any requested
	 version of the C++ filesystem library has been found, whether it is
	 *Experimental* or *Final*.

	 If no version of the filesystem library is available, this target will not
	 be defined.

	 .. note::
			 This target has ``cxx_std_17`` as an ``INTERFACE``
			 :ref:`compile language standard feature <req-lang-standards>`. Linking
			 to this target will automatically enable C++17 if no later standard
			 version is already required on the linking target.


.. _fs.variables:

Variables
*********

.. variable:: CXX_FILESYSTEM_IS_EXPERIMENTAL

	 Set to ``TRUE`` when the :find-component:`fs.Experimental` version of C++
	 filesystem library was found, otherwise ``FALSE``.

.. variable:: CXX_FILESYSTEM_HAVE_FS

	 Set to ``TRUE`` when a filesystem header was found.

.. variable:: CXX_FILESYSTEM_HEADER

	 Set to either ``filesystem`` or ``experimental/filesystem`` depending on
	 whether :find-component:`fs.Final` or :find-component:`fs.Experimental` was
	 found.

.. variable:: CXX_FILESYSTEM_NAMESPACE

	 Set to either ``std::filesystem`` or ``std::experimental::filesystem``
	 depending on whether :find-component:`fs.Final` or
	 :find-component:`fs.Experimental` was found.


Examples
********

Using `find_package(Filesystem)` with no component arguments:

.. code-block:: cmake

	 # required to hook our exported filesystem interface.
	 add_library(std::filesystem INTERFACE IMPORTED GLOBAL)
	 find_package(Filesystem REQUIRED)

	 add_executable(my-program main.cpp)
	 target_link_libraries(my-program PRIVATE std::filesystem)

Using `find_package(Filesystem)` with component argument(s):

.. code-block:: cmake

	 add_library(std::filesystem INTERFACE IMPORTED GLOBAL)
	 # either of the components flags may be omitted individually
	 find_package(Filesystem REQUIRED COMPONENTS Final Experimental)

	 add_executable(my-program main.cpp)
	 target_link_libraries(my-program PRIVATE std::filesystem)

#]=======================================================================]

# https://dl.bintray.com/boostorg/release/

# explicitly make if(item IN_LIST list) operation available
cmake_policy(SET CMP0057 NEW)

# TODO: check for pre-existing compiled blob.
if()
endif()

# Normalize and check the component list we were given
set(boost_version ${BoostFilesystem_FIND_COMPONENTS})
if(BoostFilesystem_FIND_COMPONENTS STREQUAL "")
		# Sets default values.
    set(boost_version Latest)
endif()


# fetch our version list from the sourceforge
execute_process(
	COMMAND curl https://dl.bintray.com/boostorg/release/
	RESULT VARIABLE curlres OUTPUT_VARIABLE curlout ERROR_VARIABLE curlerr
)
string(
	REGEX MATCHALL [0-9]+.[0-9]+.[0-9]+.rc[0-9]+|[0-9]+.[0-9]+.[0-9]+
	boost_fs_version_list
	"${curlout}"
)
# Was going to do semantic version parsing to get the latest version available
# or the selected version we wish to target on feature branches but realized
# string sorting is easier for now. Let's just get this working.
list(REMOVE_DUPLICATES boost_fs_version_list) #denote
list(SORT boost_fs_version_list) # make sure they're in order.
list(REVERSE boost_fs_version_list) # string sort puts the newest version @rear

set(boost_version "Final")

# Need to find the current target version
if(boost_version STREQUAL "Final")
	# target latest is at the front after previous sort
	list(GET boost_fs_version_list 0 boost_version)

elseif(NOT boost_version IN_LIST boost_fs_version_list)
	# TODO: throw error on broken.
endif()

#https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz
string(REPLACE . _ version_string "${boost_version}")
set(boost_folder "boost_${version_string}")
set(boost_archive "${boost_folder}.tar.gz")

# message(STATUS "Retrieving target library version from sourceforge:")
# file(DOWNLOAD "https://dl.bintray.com/boostorg/release/${boost_version}/source/${boost_archive}/"
# 	"../third-party/${boost_archive}"
# )

# NOTE: may be usefull for command echo stuffz
# set(CMAKE_EXECUTE_PROCESS_COMMAND_ECHO "STDOUT")


# message(STATUS "Unpacking")
# execute_process(
# 	COMMAND tar -x --checkpoint=.1000 -f "../third-party/${boost_archive}"
# 	WORKING_DIRECTORY "../third-party/"
# 	RESULT_VARIABLE extract_ok
# )

# message(STATUS "Removing archive:")
# file(REMOVE "../third-party/${boost_archive}")

# message(STATUS "Configuring build environment:")
# if(WIN32)
# 	execute_process(
# 		COMMAND ./bootstrap.bat
# 		WORKING_DIRECTORY "../third-party/${boost_folder}"
# 		RESULT_VARIABLE configure_ok
# 	)
# elseif(UNIX)
# 	execute_process(
# 		COMMAND ./bootstrap.sh
# 		WORKING_DIRECTORY "../third-party/${boost_folder}"
# 		RESULT_VARIABLE configure_ok
# 	)
# else()
# 	# TODO: throw error
# endif()

# PROCESS TOOLCHAIN RECOGNIZED BY CMAKE INTO A TOOLCHAIN
# RECOGNIZED BY THE BOOST BUILD SYSTEM.
set(toolchain_compiler CMAKE_CXX_COMPILER_ID)

message(STATUS "Building filesystem libarary with '${toolchain_compiler}'")

# execute_process(
# 	COMMAND ./b2 --with-filesystem --with-toolset=#
# 	WORKING_DIRECTORY "../third-party/${boost_folder}"
# 	RESULT_VARIABLE build_ok
# )


if()
endif()
