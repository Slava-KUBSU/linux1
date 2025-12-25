CXX = g++
CC = gcc
# Ключевые флаги для совместимости с GLIBC 2.35:
CXXFLAGS = -std=c++17 -Wall -Wextra -O2 -D_FILE_OFFSET_BITS=64 -D_GLIBCXX_USE_CXX11_ABI=0 -fno-builtin
CFLAGS = -Wall -Wextra -O2 -D_FILE_OFFSET_BITS=64
LDFLAGS = -lreadline -lfuse3 -lstdc++ -lpthread -Wl,--as-needed

TARGET = kubsh
VFS_TARGET = kubsh_vfs

all: $(TARGET) $(VFS_TARGET)

$(TARGET): kubsh.o vfs.o
	$(CXX) kubsh.o vfs.o -o $@ $(LDFLAGS)

$(VFS_TARGET): vfs.o
	$(CC) vfs.o -o $@ -lfuse3

kubsh.o: kubsh.cpp
	$(CXX) $(CXXFLAGS) -c kubsh.cpp -o kubsh.o

vfs.o: vfs.c vfs.h
	$(CC) $(CFLAGS) -c vfs.c -o vfs.o

clean:
	rm -f *.o $(TARGET) $(VFS_TARGET)
	rm -rf debian
	rm -f *.deb

.PHONY: all clean
