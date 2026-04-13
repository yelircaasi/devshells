# devshells

Development environments available through `nix`.

Run `nix develop .#$OUTPUT_NAME` to activate this environment or `direnv allow` if you have direnv installed.


## Nix Formatter

This applies the formatter that follows [RFC 166](https://github.com/NixOS/rfcs/pull/166),
which defines a standard format.

To format all Nix files:

```sh
git ls-files -z '*.nix' | xargs -0 -r nix fmt
```

To check formatting:

```sh
git ls-files -z '*.nix' | xargs -0 -r nix develop --command nixfmt --check
```

## TODO

### Homebrew packages

aom
autoconf
- [x] azd
azure-cli
bash
bat
bison
bob
brotli
c-ares
ca-certificates
cairo
certifi
cffi
cmake
corrosion
cryptography
d2
dav1d
direnv
eza
fontconfig
freetype
fribidi
fzf-make
gettext
giflib
glib
go
go-task
graphite2
harfbuzz
helm
highway
icu4c@77
icu4c@78
imath
jira-cli
jiratui
jpeg-turbo
jpeg-xl
k9s
kanata
kubernetes-cli
libavif
libdeflate
libgit2
libimagequant
libmagic
libnghttp2
libnghttp3
libngtcp2
libpng
libraqm
libsodium
libssh2
libtiff
libunistring
libuv
libvmaf
libx11
libxau
libxcb
libxdmcp
libxext
libxrender
libyaml
little-cms2
llvm
lpeg
lua
lua-language-server
lua@5.4
luajit
luarocks
luv
lz4
lzo
m4
meson
mpdecimal
mypy
ncurses
neovim
ninja
node
oh-my-posh
oniguruma
openexr
openjpeg
openjph
openssl@3
pcre2
pillow
pipx
pixman
pkgconf
poetry
pulumi
pycparser
pydantic
pyenv
pyright
python-setuptools
python@3.12
python@3.13
python@3.14
readline
ripgrep
ruff
ruff-lsp
rust
simdjson
sqlite
stylua
task
tinymist
tre-command
tree-sitter
tree-sitter-cli
tree-sitter@0.25
typst
unibilium
utf8proc
util-macros
uv
uvwasi
webp
xorgproto
xtrans
xz
yamlfmt
yazi
z3
zstd

==> Casks
font-juliamono
gcloud-cli
karabiner-elements
sioyek
wezterm
