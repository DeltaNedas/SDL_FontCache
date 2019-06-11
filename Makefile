MAJOR = 0
MINOR = 10
PATCH = 2
VERSION = $(MAJOR).$(MINOR).$(PATCH)
VERSION_REPLACE = @@VERSION@@

BUILDDIR = build
OBJECTDIR = objects
SOURCEDIR = src

CXX = g++
CXXFLAGS = -O3 -Wall -Weffc++ -ansi -pedantic -std=c++17 -I$(SOURCEDIR) -c -fPIC -g
LDFLAGS = -shared -L$(SOURCEDIR) -lSDL2 -lSDL2_ttf

SDL_BINARIES = /usr/lib/x86_64-linux-gnu/
SDL_HEADERS = /usr/include/SDL2/

LIBRARY = SDL2_fontcache
OBJ = SDL_fontcache
OBJECTS = $(patsubst %, $(OBJECTDIR)/%.o, $(OBJ))

SHARED = lib$(LIBRARY).so
SHARED_MAJOR = $(SHARED).$(MAJOR)
SHARED_MINOR = $(SHARED).$(MAJOR).$(MINOR)
SHARED_PATCH = $(SHARED).$(VERSION)
STATIC = lib$(LIBRARY).a

all: $(LIBRARY)

install: $(all)
	cp -f $(BUILDDIR)/* $(SDL_BINARIES)
	ln -sf $(SDL_BINARIES)$(SHARED_MAJOR) $(SDL_BINARIES)$(SHARED_PATCH)
	ln -sf $(SDL_BINARIES)$(SHARED_MINOR) $(SDL_BINARIES)$(SHARED_PATCH)
	ln -sf $(SDL_BINARIES)$(SHARED) $(SDL_BINARIES)$(SHARED_PATCH)
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
	$(CXX) -o $(BUILDDIR)/$(SHARED_PATCH) $^ $(LDFLAGS)
	ar rcs $(BUILDDIR)/$(STATIC) $^

clean:
	rm -rf $(OBJECTDIR)
	rm -rf $(BUILDDIR)

remake: clean $(LIBRARY)
