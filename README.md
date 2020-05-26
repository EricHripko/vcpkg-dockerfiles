# vcpkg `Dockerfile`s

These are the container images for developing and building projects
that rely on [vcpkg](https://vcpkg.readthedocs.io/en/latest/) package
manager.

# Flavours

Both Linux (Ubuntu was chosen) and Windows derive from the latest
supported base images. The following flavours are supported:

- Linux/Ubuntu:
  - GCC:
    - `gcc7`, `onbuild-gcc7` - for building against GCC7
    - `gcc8`, `onbuild-gcc8` - for building against GCC8
    - `gcc9`, `onbuild-gcc9` - for building against GCC9
  - Clang:
    - `clang7`, `onbuild-clang7` - for building against Clang 7
    - `clang8`, `onbuild-clang8` - for building against Clang 8
    - `clang9`, `onbuild-clang9` - for building against Clang 9
- Windows:
  - Visual Studio:
    - `vs19` - for building with Visual Studio 2019 toolchain

# What's in the box?

Each image has been bootstrapped with the appropriate C++ toolchain
and has `vcpkg` installed (using said toolchain):

- `VCPKG_PATH` environment variable specifies the installation path
- Binary is included in `PATH`
- For `onbuild-` flavours, dependencies are automatically installed from
  `.vcpkg` file in the root of build context

# Usage

This is essentially a two-step process:

- Install your dependencies using `vcpkg install ...`
- Invoke [your build system](https://vcpkg.readthedocs.io/en/latest/users/integration/)
  using `VCPKG_PATH` environment variable

In case of `onbuild-` flavour, place all of your dependencies in `.vcpkg` file
in the root of your project.

# Recipes

## Interactive CMake with GCC7

This is an example of interactive usage of Linux container with CMake
build system.

```
$ docker run --rm -it hripko/vcpkg:gcc7
@8629011d2960:/# mkdir build && cd build
root@8629011d2960:/build# vcpkg install <packages>
Computing installation plan...
The following packages will be built and installed:
...
Total elapsed time: 5.636 min

root@8629011d2960:/build# cmake /src -DCMAKE_TOOLCHAIN_FILE=$VCPKG_PATH/scripts/buildsystems/vcpkg.cmake
-- The C compiler identification is GNU 7.5.0
-- The CXX compiler identification is GNU 7.5.0
-- Check for working C compiler: /usr/bin/gcc-7
-- Check for working C compiler: /usr/bin/gcc-7 -- works
...
-- Configuring done
-- Generating done
-- Build files have been written to: /build

root@8629011d2960:/build# make
...
[100%] Built target test
```

## onbuild CMake with Clang

This is an example of an automatic Linux build with CMake build system.

Firstly, create a `.vcpkg` file in the root of your project listing your
dependencies. For example:

```
boost-filesystem
boost-log
...
```

Then, create a `Dockerfile` using below as an example. Since we're looking at
CMake build system again, we're borrowing the commands from the section above.

```dockerfile
FROM hripko/vcpkg:onbuild-clang7
COPY . /src
RUN cmake /src \
    -DCMAKE_TOOLCHAIN_FILE=$VCPKG_PATH/scripts/buildsystems/vcpkg.cmake && \
    make

```

Finally, build the image:

```
$ docker build .
Sending build context to Docker daemon  72.1kB
Step 1/3 : FROM hripko/vcpkg:onbuild-clang7
# Executing 2 build triggers
 ---> Running in 37daa03408d2
Computing installation plan...
The following packages will be built and installed:
...
Total elapsed time: 7.659 min

Removing intermediate container 37daa03408d2
 ---> e84acd07fbfe
Step 2/3 : COPY . /src
 ---> 0e7fed5e3409
 Step 3/3 : RUN cmake /src     -DCMAKE_TOOLCHAIN_FILE=$VCPKG_PATH/scripts/buildsystems/vcpkg.cmake &&     make
 ---> Running in 2e16f1c6878d
-- The C compiler identification is Clang 7.0.1
-- The CXX compiler identification is Clang 7.0.1
-- Check for working C compiler: /usr/bin/clang-7
-- Check for working C compiler: /usr/bin/clang-7 -- works
...
-- Configuring done
-- Generating done
[100%] Built target test
Removing intermediate container 2e16f1c6878d
 ---> aa51b1e01487
Successfully built aa51b1e01487
```
