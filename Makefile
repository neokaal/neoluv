.PHONY: winluaenv

# run this target only on windows in a Visual Studio Developer Powershell
winluaenv:
	hererocks .luaenv -l5.4 -rlatest --target vs
	.luaenv/luarocks/luarocks.bat install ldoc