Description
===========

In this repository you will find material used to introduce CMake and building tools.
In its present form it is not intended as a complete tutorial, but it contains useful material to showcase CMake and building tools in a seminar.

For a tutorial that you can easily follow step by step, without additional information, refer to [cmake-tutorial](https://cmake.org/cmake-tutorial/).

Build
=====

Build using scripts
-------------------

In order to build a software with [scripts](build.sh), you just have to add build
instructions to a script. Writing a script is easy and you can do almost
any kind of processing. However it is not easy to make a good, portable,
customizable build processing. It is also difficult to properly implement
incremental building, that avoid rebuilding everything if not needed.
It is also difficult to exploit multiple processors, if available.

### Compile ###

```
./build.sh
```

### Clean ###

```
./build.sh clean
```

### Pros ###

* Easy to write
* Can do almost everything

### Cons ###

* Non standard
* No incremental build
* No build-time customization
* No parallel building
* Files are usually created in the source directory

Build using Makefile
--------------------

`make` is a build tool that tries to automate software building.
Its main goals are reliability, incremental building and parallel
building. `make` achieves most of its goals by expressing each
build step (rule, in `make` terminology) in terms of preconditions
and expected results (targets, in `make` terminology).
Rules are written in files called [Makefile](Makefile).
Each rule is defined by a result target name, a list of prerequisite
target names, a sequence of commands that, given the prerequisites
allows to build the result. Each target is implicitly associated to
a file and each rule is assumed to contain instructions to create
a file whose name is the result target name. When `make` is instructed
to build a target, it will check if the file associated to the target
is already present. If it is not present it will then check if prerequisites
are satisfied (i.e., if, for each prerequisite target, a file exist whose name
is the same of the target one) and then proceed to run the commands in the rule.
If the result file is present it will check if prerequisites files are older.
If they are older, no action will be performed. If they are newer, `make`
will proceed to run the commands in the rule.

The typical rule is written as follow:

```
result: prerequisite1 prerequisite2
  command1 prerequisite1 prerequisite2 result
  command2 prerequisite1 prerequisite2 result
  ...
```
and a real-life example could be:

```
main: main.c
  cc main.c -o main
```
which defines the rule to build `main` executable, given
`main.c` source file.

It is possible to build a specific target by issuing `make $target`
command. If no target is specified, `make` will either try to
build the first defined target or a target named `all`, if present.

Rules in `Makefile` are very convenient to grant incremental and parallel
builds. Unfortunately the syntax of `Makefile` is sometime confusing and
limited: it is very hard (or impossible) to write a proper `Makefile`
when file names contain spaces, tabs are part of the syntax, the
rule order matters, and so on. It is possible to write `Makefile` for
almost any kind of build, as soon as input and output are separated
(i.e., if the build steps are not supposed to update their own input).
It is also possible to use environment variables to customize the build process at
build time.

### Compile ###

```
make -j
```

### Cross-compile with Mingw ###

```
make -j CC=i686-w64-mingw32-gcc AR=i686-w64-mingw32-ar
```

### Clean ###

```
make -j clean
```

### Pros ###

* Mostly standard
* Can do almost everything
* Incremental build
* Partial build-time customization
* Parallel building
* Good and clear documentation ([GNU Make manual](https://www.gnu.org/software/make/manual/))

### Cons ###

* Little integration with most IDE
* Confusing/limited/error-prone syntax
* Hard to reliably reproduce builds due to large use of environment variables
* Files are usually created in the source directory

Build using CMake
-----------------

`cmake` goal is to overcome the issues of `make` while still take advantage of its benefits.
In particular `cmake` introduces a configuration step, just before the build step.
The configuration step is responsible to configure the build step, by taking into account
user input and environment variables. The results of the configuration step is stored
into files so that user input and environment variabled will not be used at build time,
thus granting reliable, reproducible builds.
`cmake` is commonly used to produce build files for other build systems (e.g., `make`, `ninja`,
`Visual Studio`, `Xcode`, ...); as these files are automatically created they are
generally much more reliable and consistent than manually created ones. They also
tend to provide many more functionalities.
`cmake` input consists of [CMakeLists.txt](CMakeLists.txt) files, which describes the project
to be built, `*.cmake` files, which contains collections of cmake macro that can
be used in `CMakeLists.txt` for specific tasks, `*.in` files that are used
as templates for automatically generated files.

### Configure ###

```
mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=install  -DCMAKE_VERBOSE_MAKEFILE=ON
```

### Configure for cross-compilation with Mingw ###

```
mkdir -p build-mingw32
cd build-mingw32
cmake .. -DCMAKE_INSTALL_PREFIX=install  -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_TOOLCHAIN_FILE=../toolchains/Toolchain-mingw32.cmake
```

### Compile ###

```
make -j
```

### Install ###

```
make -j install
```

### Clean ###

```
make -j clean
```
### Configure for ninja ###

```
mkdir -p build-ninja
cd build-ninja
cmake .. -GNinja -DCMAKE_INSTALL_PREFIX=install
```

### Compile with ninja ###

```
ninja
```

### Install with ninja ###

```
ninja install
```

### Clean with ninja ###

```
ninja clean
```

### Configure for Debug ###

```
mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=install  -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_BUILD_TYPE=Debug
```

### Test ###

```
make -j test
```

### Coverage ###

```
make -j coverage
```

### Pros ###

* Mostly standard
* Good integration with most IDE
* Incremental build
* Good prebuild-time customization
* Parallel building
* Reproducible builds
* Output files created outside of the source directory
* Highly modular
* Extensive documentation ([CMake 3.10 documentation](https://cmake.org/cmake/help/v3.10/))

### Cons ###

* Powerful for C/C++ builds, but not very much for other tasks
* Many features depend on a specific version of `cmake`
* Syntax is not uniform and confusing
* Scarce introductory documentation, very limited use case descriptions, very limited examples

Run
===

Run native programs
-------------------

```
./main
./main2
./main3
LD_LIBRARY_PATH=. ./main4
```

Run Windows programs on Linux
-----------------------------

```
wine ./main
wine ./main2
wine ./main3
wine ./main4
```
