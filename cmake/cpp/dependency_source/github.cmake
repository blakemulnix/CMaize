include_guard()
include(cpp/dependency_source/class)
include(cpp/download_project/DownloadProject)

#[[[ Models the source of a dependency that is stored on GitHub.
#
# Handles the retrieval and storage of the dependencies source from Github.
#]]
cpp_class(GithubDependencySource DependencySource)

    ###########################################################################
    #[[ ---------------------------- Attributes ---------------------------- ]]
    ###########################################################################

    ## Is this a private GitHub Repo?
    cpp_attr(GithubDependencySource private FALSE)

    ## What is the base URL?
    cpp_attr(GithubDependencySource url)

    ## What git tag/hash should we use?
    cpp_attr(GithubDependencySource version master)

    ###########################################################################
    #[[ ---------------------------- Functions ----------------------------- ]]
    ###########################################################################

    cpp_member(get_source GithubDependencySource)
    function("${get_source}" _gs_this)
        # Grab local variables that are needed
        GithubDependencySource(GET "${_gs_this}" _gs name directory url private version)

        # Check that URL starts with "github.com/""
        # TODO Potentially allow "https://github.com" and "http://github.com"
        string(FIND ${_gs_url} "github.com" _gs_github_url_index)
        if(NOT "${_gs_github_url_index}" EQUAL 0)
            message(
                FATAL_ERROR
                "The repository URL must start with \"github.com/\"."
            )
        endif()

        # If repo is private, check that CPP_GITHUB_TOKEN is set
        if("${_gs_private}")
            if("${CPP_GITHUB_TOKEN}" STREQUAL "")
                message(
                    FATAL_ERROR
                    "Private GitHub repos require CPP_GITHUB_TOKEN to be set."
                )
            endif()
            set(_gs_url "https://${CPP_GITHUB_TOKEN}@${_gs_url}")
        else()
            set(_gs_url "https://${_gs_url}")
        endif()

        # message(FATAL_ERROR "CPP_GITHUB_TOKEN: ${CPP_GITHUB_TOKEN}")

        # Download the source files
        download_project(
            PROJ "${_gs_name}"
            GIT_REPOSITORY "${_gs_url}"
            GIT_TAG "${_gs_version}"
            SOURCE_DIR "../${_gs_directory}"
            QUIET
        )

        # Remove uneccessary directories
        file(REMOVE_RECURSE "${CMAKE_CURRENT_BINARY_DIR}/${_gs_name}-build")
        file(REMOVE_RECURSE "${CMAKE_CURRENT_BINARY_DIR}/${_gs_name}-download")
    endfunction()
cpp_end_class()
