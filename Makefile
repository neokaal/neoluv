.PHONY: winluaenv docs

# see https://gist.github.com/sighingnow/deee806603ec9274fd47
# for details on the following snippet to get the OS
# (removed the flags about arch as it is not needed for now)
OSFLAG :=
ifeq ($(OS),Windows_NT)
        OSFLAG = WIN32
else
        UNAME_S := $(shell uname -s)
        ifeq ($(UNAME_S),Linux)
                OSFLAG = LINUX
        endif
        ifeq ($(UNAME_S),Darwin)
                OSFLAG = OSX
        endif
endif

# run this target only on windows in a Visual Studio Developer Powershell
winluaenv:
	hererocks .luaenv -l5.4 -rlatest --target vs
	.luaenv/luarocks/luarocks.bat install ldoc

docs:
ifeq ($(OSFLAG),WIN32)
	pwsh -Command ". .luaenv/bin/activate.ps1; ldoc ."
else
	source .luaenv/bin/activate; ldoc .
endif