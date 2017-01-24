
source ${DOTFILES_PATH}/lib/bash/error.sh


function find_parallel_tool {
    local XJOBS_EXECUTABLE_FOUND=1

    GL_PARALLEL_TOOL_FUNC="run_non_parallel"

    which xjobs > /dev/null 2>/dev/null || XJOBS_EXECUTABLE_FOUND=0

    if [ ${XJOBS_EXECUTABLE_FOUND} -eq 1 ]; then
        GL_PARALLEL_TOOL_FUNC="parallel_xjobs"
    fi
}

function run_non_parallel {
    while read CMD; do
        echo "${CMD}"
    done
}

function parallel_xjobs {
   cat | xjobs -v 2 -j ${GL_CPU_CORE_COUNT} -- sh -c
}

function parallel_gnu_parallel {
    not_implemented_error
}

function parallel_init {
    GL_CPU_CORE_COUNT=$(cat /proc/cpuinfo |grep processor |wc -l)
    find_parallel_tool
}

function set_parallel_jobs {
    local GL_CPU_CORE_COUNT=${1}
    GL_CPU_CORE_COUNT=GL_CPU_CORE_COUNT
}

function parallel_exec {
    cat | ${GL_PARALLEL_TOOL_FUNC}
}

parallel_init
