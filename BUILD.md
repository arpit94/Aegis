# Steps to build the project

The first thing you should do is set up a GCC Cross-Compiler for i686-elf.
https://wiki.osdev.org/GCC_Cross-Compiler

Things to install:
* Compiler gcc, gcc-c++, clang (MAC) etc
* Make
* Bison https://ftp.gnu.org/gnu/bison/ **
* Flex https://github.com/westes/flex/releases **
* GMP https://ftp.gnu.org/gnu/gmp/ **
* MPC https://ftp.gnu.org/gnu/mpc/ **
* MPFR https://ftp.gnu.org/gnu/mpfr/ **
* Texinfo https://ftp.gnu.org/gnu/texinfo/ ** 
* ISL http://isl.gforge.inria.fr/ **

 ** Marked packages were compiled from source using the following commands
```bash
configure
make
make install
```

Its recommended to **not** run the configure the command in the same repo as source. Make a separate build folder. You can remove it once you have the required binaries.

After all of the above is done, install Binutils and the GCC-cross-compiler

* Binutils https://ftp.gnu.org/gnu/binutils/
* GCC https://ftp.gnu.org/gnu/gcc/

* Exports to be done before installing GCC
```bash
export PREFIX="$HOME/opt/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"
```

* Binutils

```bash
cd $HOME/src
 
mkdir build-binutils
cd build-binutils
../binutils-x.y.z/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install
```

* GCC

```bash
cd $HOME/src
 
# The $PREFIX/bin dir _must_ be in the PATH. We did that above.
which -- $TARGET-as || echo $TARGET-as is not in the PATH
 
mkdir build-gcc
cd build-gcc
../gcc-x.y.z/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc
```

* Check installation by the following command
```bash
$HOME/opt/cross/bin/$TARGET-gcc --version
```

* Permanently add the following line to you .bash_profile or .bashrc to access the cross-compiler directly
```bash
export PATH="$HOME/opt/cross/bin:$PATH"
```
