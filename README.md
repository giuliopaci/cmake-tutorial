Build
=====

Build using scripts
-------------------

In order to build a software with scripts, you just have to add build
instructions to a script. Writing a script is easy and you can do almost
any kind of processing. However it is not easy to make a good, portable,
customizable build processing. It is also difficult to properly implement
incremental building, that avoid rebuilding everything if not needed.

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

Build using Makefile
--------------------

### Compile ###

```
make -j
```

### Clean ###

```
make -j clean
```

Cross-build using Makefile
--------------------------

### Compile ###

```
make -j CC=i686-w64-mingw32-gcc AR=i686-w64-mingw32-ar
```

### Clean ###

```
make -j clean
```

Build using CMake + Makefile
----------------------------

### Configure ###

```
mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=install  -DCMAKE_VERBOSE_MAKEFILE=ON
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

Build using CMake + Ninja
----------------------------

### Configure ###

```
mkdir -p build-ninja
cd build-ninja
cmake .. -GNinja -DCMAKE_INSTALL_PREFIX=install
```


### Compile ###

```
ninja
```

### Install ###

```
ninja install
```

### Clean ###

```
ninja clean
```

Cross-build using CMake + Makefile
----------------------------------

### Configure ###

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

Build + Coverage test using CMake + Makefile
--------------------------------------------

### Configure ###

```
mkdir -p build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=install  -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_BUILD_TYPE=Debug
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

### Test ###

```
make -j test
```

### Coverage ###

```
make -j coverage
```

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
