#!/bin/sh

set -e

case "$1" in
    "clean")
        rm -f main

        rm -f main2 simple_print_hello_world.o

        rm -f libphw.a print_hello_world.o
        rm -f main3

        rm -f libphw-shared.so
        rm -fr shared-objs-print_hello_world.o
        rm -f main4
        
    ;;
    *)
        # Single file program
        gcc main.c -o main

        # Multiple files program
        gcc -Iinclude main2.c simple_print_hello_world.c -o main2

        # Static library + program
        gcc -Iinclude -c print_hello_world.c -o print_hello_world.o
        ar qc libphw.a print_hello_world.o
        gcc -Iinclude main3.c -L. -lphw -o main3

        # Shared library + program
        gcc -Iinclude -c print_hello_world.c -fPIC -o shared-objs-print_hello_world.o
        gcc -shared shared-objs-print_hello_world.o -o libphw-shared.so
        gcc -Iinclude main3.c -L. -lphw-shared -o main4
    ;;
esac
