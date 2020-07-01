include_guard()
include(cmakepp_core/cmakepp_core)

#[[[ Models the source of a dependency of the main CMake Project.
#
# Handles the retrieval and storage of a dependencies source.
#
#]]
cpp_class(DependencySource)

    ###########################################################################
    #[[ ---------------------------- Attributes ---------------------------- ]]
    ###########################################################################

    ## Name of the dependency
    cpp_attr(DependencySource name)

    ## Directory where the dependency is to be stored
    cpp_attr(DependencySource directory)

    ##########################################################################
    #[[ ---------------------------- Functions ---------------------------- ]]
    ##########################################################################





cpp_end_class()
