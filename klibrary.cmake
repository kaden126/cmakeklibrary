enable_testing()
include(FetchContent)
macro(new_executable name primary public_modules private_modules public_sources private_sources)
    add_executable(${name} ${primary})
    list(APPEND executables ${name})
    list(APPEND targets ${name})

    target_sources(${name} PRIVATE ${private_sources})
    target_sources(${name} PUBLIC ${public_sources})

    target_sources(${name} PRIVATE FILE_SET private_mods TYPE CXX_MODULES FILES ${private_modules})
    target_sources(${name} PUBLIC FILE_SET public_mods TYPE CXX_MODULES FILES ${public_modules})
endmacro()

macro(new_library name public_modules private_modules public_sources private_sources)
    add_library(${name} SHARED)
    list(APPEND libraries ${name})
    list(APPEND targets ${name})

    target_sources(${name} PRIVATE ${private_sources})
    target_sources(${name} PUBLIC ${public_sources})

    target_sources(${name} PRIVATE FILE_SET private_mods TYPE CXX_MODULES FILES ${private_modules})
    target_sources(${name} PUBLIC FILE_SET public_mods TYPE CXX_MODULES FILES ${public_modules})
endmacro()

macro(new_test name primary public_modules private_modules public_sources private_sources)
    add_executable(${name} ${primary})
    list(APPEND targets ${name})
    list(APPEND tests ${name})

    target_sources(${name} PRIVATE ${private_sources})
    target_sources(${name} PUBLIC ${public_sources})

    target_sources(${name} PRIVATE FILE_SET private_mods TYPE CXX_MODULES FILES ${private_modules})
    target_sources(${name} PUBLIC FILE_SET public_mods TYPE CXX_MODULES FILES ${public_modules})

    add_test(NAME ${name} COMMAND ${name})
endmacro()

macro(compiler_flags affected_targets flags)
    foreach(target ${affected_targets})
    target_compile_options(${target} PRIVATE ${flags})
    endforeach()
endmacro()
macro(linker_flags affected_targets flags)
    foreach(target ${affected_targets})
        target_link_options(${target} PRIVATE ${flags})
    endforeach()
endmacro()

macro(link importing_targets imported_libraries)
    foreach(target ${importing_targets})
    target_link_libraries(${target} PRIVATE ${imported_libraries})
    endforeach()
endmacro()

macro(import name path)
    FetchContent_Declare(
            ${name}
            SOURCE_DIR ${path}
    )
    FetchContent_MakeAvailable(${name})
endmacro()