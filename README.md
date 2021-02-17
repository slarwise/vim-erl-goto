# vim-erlang-goto-definition

A (n)vim plugin for going to, and echoing, definitions and declarations in
Erlang source code.

## Features

- Go to definition under cursor, either using the same window or in a new split
- Echo the definition under the cursor without going to it

## Supported definitions and declarations

These are the definitions are declarations that are supported, and where they
can exist:

- Functions (local, external module)
- Records (local, included header)
- Macros (local, included header)
- Types (local, included header, external module)
- Opaques (local, included header, external module)
- Variables (local)

Local functions and local or included types/opaques look the same, same goes for
external functions and external types/opaques. Therefore, it is not always clear
where to look. To solve this, the functions that finds the definition can take
an argument saying whether functions or types/opaques should be prioritized.
