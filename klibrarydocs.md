# Welcome to the klibrary CMake utility docs!

Below you will find the documentation for the functions defined in the klibrary.cmake file. As well as some important info.

---

## 1. Importing the file
Adding the library to your project is as simple as adding the following line to your CMakeLists.txt file:
```cmake
include(path/to/klibrary.cmake) # Can be relative or absolute
```
Now you can use the functions defined in the file. If the klibrary.cmake file is in the same directory as your CMakeLists.txt file, you can just use the name klibrary, otherwise you will need to specify the path.

---

## 2. Calling the functions
Most functions are designed to take a list of arguments. Lists are "double quote" enclosed, and their elements are separated by semicolons.
`""` is used to denote an empty string/list. All arguments should be separated by spaces and enclosed in quotes.

---

## 3. Variables
The following variables are defined by the klibrary.cmake file:

`targets` - A **list** of all targets in your project.

`executables` - A **list** of all executables in your project.

`libraries` - A **list** of all libraries in your project.

`tests` - A **list** of all tests in your project.

These variables can be used to iterate over the targets in your project but should not be modified to avoid unexpected behaviour.

---

## 4. Before you start
Before you start using the functions, cmake has requirements that need to be provided at the top level.

- A call to `cmake_minimum_required()` with the parameters `VERSION` and the minimum version of cmake required to configure your project.


- A call to `project()` with the name of your project.


- A call to `set()` with the parameters `CMAKE_CXX_STANDARD` and the version of c++ you are using.

```cmake
cmake_minimum_required(VERSION 3.26)
project(example_project)
set(CMAKE_CXX_STANDARD 20)
```

---

## 5. C++ 20 modules

In order to use the functions in this library reliably, and use the latest features of C++ modules, you will need to set the `CMAKE_CXX_STANDARD` variable to 20.

Additionally, you will need to use the `-fmodules` flag when compiling your project, which is made easy with a call to the 
`compiler_flags()` function.

```cmake 
compiler_flags("${targets}" "-fmodules")
```

You will also need a more recent toolchain with good module support.

Clang version 18 or greater is recommended. GCC module support is in progress and will be available in the future.

The `import std;` feature is not yet supported, as stable-ish support for the standard library module is only available in cutting edge llvm builds.
For now, you can import the standard library modules manually with `import <header>;`

---

## 6. Apple isysroot

For those developing on Apple platforms, you will need to specify the path to the Apple SDK.

Note: This is not required for Linux or Windows, or Apple with GCC.

You can get this path with this shell command:
```shell
  xcrun --show-sdk-path
```

You then need to set it as a compiler and linker flag for your project.

```cmake
compiler_flags("${targets}" "-isysroot;<sdk path>}")
linker_flags("${targets}" "-isysroot;<sdk path>")
```
Note that `-isysroot` and sdk path are separated by a semicolon.

---

## 7. Functions
The following functions are defined by the klibrary.cmake file:

---

##  *new_executable* 
Adds a new executable to your project. With the specified sources and modules.

### Parameters

`name` - The name of the executable.

`primary_file` - The primary (where `main()` is defined) file of the executable.

`public_modules` - A **list** of modules that are visible to targets linked to the executable.  

`private_modules` - A **list** of modules that are only visible to the executable.

`public_sources` - A **list** of source files that are visible to targets linked to the executable.

`private_sources` - A **list** of source files that are only visible to the executable.

### Example

```cmake
new_executable(example_exe 
        "main.cpp" # Primary (main) file
        "public_module.cppm" # Public module
        "private_module.cppm;other_module.cppm" # Private modules
        "public_source.cpp" # Public source
        "" # Private source - Empty string means no files
)
```

Also appends the executable to the `targets` and `executables` variables.

---

##  *new_library* 
Adds a new shared library to your project. With the specified sources and modules.

### Parameters

`name` - The name of the library.`

`public_modules` - A **list** of modules that are visible to targets linked to the library.  

`private_modules` - A **list** of modules that are only visible to the library.

`public_sources` - A **list** of source files that are visible to targets linked to the library.

`private_sources` - A **list** of source files that are only visible to the library.

### Example

```cmake 
new_library(example_lib
        "public_module.cppm" # Public module
        "private_module.cppm;other_module.cppm" # Private modules
        "public_source.cpp" # Public source
        "private_source.cpp" # Private source 
)
```

Also appends the library to the `targets` and `libraries` variables.

---

##  *new_test*
Adds a new test to your project. With the specified sources and modules.

### Parameters

`name` - The name of the test.

`primary_file` - The primary (where `main` is defined) file of the test.

`public_modules` - A **list** of modules that are visible to targets linked to the test.

`private_modules` - A **list** of modules that are only visible to the test.

`public_sources` - A **list** of source files that are visible to targets linked to the test.

`private_sources` - A **list** of source files that are only visible to the test.

### Example

```cmake
new_test(example_test 
        "main.cpp" # Primary (main) file
        "public_module.cppm" # Public module
        "private_module.cppm;other_module.cppm" # Private modules
        "public_source.cpp" # Public source
        "private_source.cpp" # Private source
)
```

Also appends the test to the `targets` and `tests` variables.

---

## *compiler_flags*
Sets compiler flags for a group of targets.

### Parameters

`affected_targets` - A **list** of targets to set the flags for.

`flags` - A **list** of flags to set.

### Example

```cmake
compiler_flags("${targets}" "-fmodules")
```

---

## *linker_flags*
Sets linker flags for a group of targets.

### Parameters

`affected_targets` - A **list** of targets to set the flags for.

`flags` - A **list** of flags to set.

### Example
```cmake
linker_flags("${targets}" "-lncurses")
```

---

## *link*
Links a group of targets to a group of libraries.

### Parameters
`importing_targets` - A **list** of targets to link.

`imported_libraries` - A **list** of libraries to link to.

### Example

```cmake
link("${executables}" "${libraries}")
```

---

## *import*
Imports a group of targets from another project. 
Making the libraries, tests, executables, etc. available in the current project.

### Parameters

`name` - The name of the imported project.

`path` - The path to the imported project.

### Example

```cmake
import("imported_project" "path/to/imported/project")
```

---