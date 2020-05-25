# vcpkg `Dockerfile`s

These are the container images for developing and building projects
that rely on [vcpkg](https://vcpkg.readthedocs.io/en/latest/) package
manager.

# Flavours

Both Linux (Ubuntu was chosen) and Windows derive from the latest
supported base images. The following flavours are supported:

- Linux/Ubuntu:
  - GCC:
    - `gcc7` - for building against GCC7
    - `gcc8` - for building against GCC8
    - `gcc9` - for building against GCC9
  - Clang:
    - `clang7` - for building against Clang 7
    - `clang8` - for building against Clang 8
    - `clang9` - for building against Clang 9
- Windows:
  - Visual Studio:
    - `vs19` - for building with Visual Studio 2019 toolchain

# What's in the box?

Each image has been bootstrapped with the appropriate C++ toolchain
and has `vcpkg` installed (using said toolchain):

- `VCPKG_PATH` environment variable specifies the installation path
- Binary is included in `PATH`

# Usage

This is essentially a two-step process:

- Install your dependencies using `vcpkg install ...`
- Invoke [your build system](https://vcpkg.readthedocs.io/en/latest/users/integration/)
  using `VCPKG_PATH` environment variable

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
