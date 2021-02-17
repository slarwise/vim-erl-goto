# vim-erlang-goto-definition

A (n)vim plugin for going to, and echoing, definitions and declarations in
Erlang source code.

## Features

- Go to definition under cursor, either using the same window or in a new split
  (horizontal or vertical)
- Echo the definition under the cursor without going to it

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

- `gd` Go to definition
- `<C-W>d` Go to definition in horizontal split
- `<C-W><C-D>` Go to definition in vertical split
- `[d` Echo definition

To define your own mappings, do

```vimscript
nmap {yourmapping} <Plug>ErlangGotoDefinitionEdit
nmap {yourmapping} <Plug>ErlangGotoDefinitionSplit
nmap {yourmapping} <Plug>ErlangGotoDefinitionVsplit
nmap {yourmapping} <Plug>ErlangGotoDefinitionEcho
```

where `{yourmapping}` is the mapping you want to use. Set
`g:erlang_goto_definition_no_mappings` to 1 to not define any default mappings.
(If you define your own mappings, you don't need to set
`g:erlang_goto_definition_no_mappings` to 1, the plugin won't overwrite your
mappings).

## Issues

Please open an issue if you something is not working, you need help or you have
an idea for additional features :)
