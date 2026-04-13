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
