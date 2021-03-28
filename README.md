# vim-erlang-goto-definition

A (n)vim plugin for going to, and echoing, definitions and declarations in
Erlang source code.

## What does it do?

- Go to definition under cursor, either using the same window or in a new split
  (horizontal or vertical)
- Echo the definition under the cursor without going to it
- Open the definition under the cursor in a floating window (requires a recent
  version of neovim)
- List all definitions under cursor and select the one you want to go to/echo
  (useful for going to a function with a certain arity, or if for example a type
  and a function have the same name)

## Supported definitions and declarations

These are the definitions are declarations that are supported, and where they
can exist:

- Functions (current module, external modules)
- Records (current module, included headers)
- Macros (current module, included headers)
- Types (current module, included headers, external modules)
- Opaques (current module, included headers, external modules)
- Variables (current module)

## Configuration

These mappings are defined by default

- `gd` Go to first found definition
- `<C-W>d` Go to first found definition in horizontal split
- `<C-W><C-D>` Go to first found definition in vertical split
- `[d` Echo first found definition
- `[D` List all found definitions

To define your own mappings, do

```vimscript
nmap {yourmapping} <Plug>ErlangGotoDefinitionEdit
nmap {yourmapping} <Plug>ErlangGotoDefinitionSplit
nmap {yourmapping} <Plug>ErlangGotoDefinitionVsplit
nmap {yourmapping} <Plug>ErlangGotoDefinitionEcho
nmap {yourmapping} <Plug>ErlangGotoDefinitionFloat
nmap {yourmapping} <Plug>ErlangGotoDefinitionList
```

where `{yourmapping}` is the mapping you want to use. Set
`g:ErlangGotoDefinitionNoMappings` to 1 to not define any default mappings.
(If you define your own mappings, you don't need to set
`g:ErlangGotoDefinitionNoMappings` to 1, the plugin won't overwrite your
mappings).

To find external modules, the vim `findfile` function is used by default. You
can optionally add your own function to find the module if findfile is
unsuccessful. Do this by providing a Funcref to
`g:ErlangGotoDefinitionFindFile`. For example, if your function is called
`MyFindFile`, you would do

```vim
let g:ErlangGotoDefinitionFindFile = function('MyFindFile')
```

Your function must take exactly one argument, the module name with the `.erl`
extension and return the path to this module. The path can be absolute or
relative to the current working directory. If no path is found, return an empty
string.

## Support

Please open an issue if something is not working, you need help or have an
idea for additional features :)
