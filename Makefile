CXX = g++-8
CXXFLAGS = -O3 -Wall -std=c++17 -I. -c -g
LDFLAGS = -c -lSDL2 -lSDL2_ttf -Wl,-rpath,'$$ORIGIN'

BUILDDIR = build
SDL_BINARIES = /usr/lib/gcc/x86_64-linux-gnu/8/
SDL_HEADERS = /usr/include/SDL2/

OUT_FILE = libSDL2_fontcache.a
OBJ = SDL_fontcache.cpp.o
OBJECTS = $(patsubst %, $(BUILDDIR)/%, $(OBJ))

all: $(OUT_FILE)

install: $(OUT_FILE)
	cp $(OUT_FILE) $(SDL_BINARIES)
	cp SDL_fontcache.h $(SDL_HEADERS)

$(BUILDDIR)/%.cpp.o: %.cpp 
	mkdir -p $(BUILDDIR)
	$(CXX) $(CXXFLAGS) -o $@ $^

$(OUT_FILE): $(OBJECTS)
	ar rcs $(OUT_FILE) $(OBJECTS)

clean:
	rm -f $(BUILDDIR)/*.cpp.o
	rm -f $(OUT_FILE)
