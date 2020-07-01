include_guard()
include(cpp/dependency_source/class)

#[[[ Models the source of a dependency of the main CMake Project that is stored
#    locally.
#
# Handles copying and storing the dependency's source.
#
#]]
cpp_class(LocalDependencySource DependencySource)

    ###########################################################################
    #[[ ---------------------------- Attributes ---------------------------- ]]
    ###########################################################################

    ## The directory where the local source is located
    cpp_attr(LocalDependencySource src_directory FALSE)

    ###########################################################################
    #[[ ---------------------------- Functions ----------------------------- ]]
    ###########################################################################

    cpp_member(get_source LocalDependencySource)
    function("${get_source}" _gs_this)
        # Grab local variables that are needed
        LocalDependencySource(GET "${_gs_this}" _gs name directory src_directory)

        # Check that the given local source directory exists
        if (NOT EXISTS "${_gs_src_directory}")
            message(
                FATAL_ERROR
                "The provided source directory ${_gs_src_directory} does not exist."
            )
        endif()

        # Get all the files to copy
        # (list of file names and relative file paths)
        file(
            GLOB_RECURSE _gs_files_to_copy
            RELATIVE "${_gs_src_directory}"
            "${_gs_src_directory}/*"
        )

        if(NOT _gs_files_to_copy)
            message(
                FATAL_ERROR
                "The provided source directory ${_gs_src_directory} contains no files."
            )
        endif()

        # Handle each file name and relative file path
        foreach(_gs_file_to_copy ${_gs_files_to_copy})
            if(_gs_file_to_copy MATCHES ".*\/.*")
                # Handle file within subdirectory
                # Get the subdirectory path
                string(REGEX MATCH ".*\/" _gs_dir_path "${_gs_file_to_copy}")

                # Get the file name by itself
                string(LENGTH "${_gs_dir_path}" _gs_dir_path_length)
                string(SUBSTRING "${_gs_file_to_copy}" "${_gs_dir_path_length}" -1 _gs_file_name)

                # Copy the subdirectory structure and file over
                file(
                    COPY "${_gs_src_directory}/${_gs_file_to_copy}"
                    DESTINATION "${_gs_directory}/${_gs_dir_path}"
                )
            else()
                # Handle file at root of directory
                file(
                    COPY "${_gs_src_directory}/${_gs_file_to_copy}"
                    DESTINATION "${_gs_directory}/"
                )
            endif()
        endforeach()
    endfunction()

cpp_end_class()
