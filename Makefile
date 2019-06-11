VERSION = 0.10.2
VERSION_REPLACE = @@VERSION@@

BUILDDIR = build
OBJECTDIR = objects
SOURCEDIR = src

CXX = g++
CXXFLAGS = -O3 -Wall -Weffc++ -ansi -pedantic -std=c++17 -I$(SOURCEDIR) -c -fPIC -g
LDFLAGS = -shared -L$(SOURCEDIR) -lSDL2 -lSDL2_ttf

SDL_BINARIES = /usr/lib/gcc/x86_64-linux-gnu/
SDL_HEADERS = /usr/include/SDL2/

LIBRARY = SDL2_fontcache
OBJ = SDL_fontcache
OBJECTS = $(patsubst %, $(OBJECTDIR)/%.o, $(OBJ))

PREFIX = lib
SHARED = .so.$(VERSION)
STATIC = .a

all: $(LIBRARY)

install: $(all)
	cp -f $(BUILDDIR)/* $(SDL_BINARIES)
	cp -f $(SOURCEDIR)/SDL_fontcache.h $(SDL_HEADERS)

uninstall:
	rm -f $(SDL_BINARIES)$(PREFIX)$(LIBRARY)*
	rm -f $(SDL_HEADERS)/SDL_fontcache.h

$(OBJECTDIR)/%.o: $(SOURCEDIR)/%.cpp
	mkdir -p $(OBJECTDIR)
	sed -i 's/$(VERSION_REPLACE)/$(VERSION)/g' $^ # Replace @@VERSION@@ with the version.
	$(CXX) $(CXXFLAGS) -o $@ $^
	sed -i 's/$(VERSION)/$(VERSION_REPLACE)/g' $^ # Replace the version with @@VERSION@@ to not break it.

$(LIBRARY): $(OBJECTS)
	mkdir -p $(BUILDDIR)
	$(CXX) -o $(BUILDDIR)/$(PREFIX)$@$(SHARED) $^ $(LDFLAGS)
	ar rcs $(BUILDDIR)/$(PREFIX)$@$(STATIC) $^

clean:
	rm -rf $(OBJECTDIR)
	rm -rf $(BUILDDIR)

remake: clean $(LIBRARY)
