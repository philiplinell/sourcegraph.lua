# Neovim Sourcegraph Integration

This repository contains a Lua script (`sourcegraph.lua`) that integrates
[Sourcegraph](https://sourcegraph.com/) search into Neovim. This tool helps
developers search for code snippets directly from their Neovim environment.

## Features

- Fetch selected code within Neovim
- URL encode the fetched code for search
- Construct a Sourcegraph URL including the selected code
- Open the URL in the default browser to show search results on Sourcegraph
- Contextual search based on the file type of the current buffer

## Usage

After you've installed the script (see Installation section below), you can use
it by simply selecting text in visual mode in Neovim and pressing `<leader>S`.
This will construct a Sourcegraph search URL with the selected text and open it
in your default web browser.

## Installation

To install the script, follow these steps:

1. Clone the repository or download the `sourcegraph.lua` file.
2. Move the `sourcegraph.lua` file to your Neovim configuration directory (usually `~/.config/nvim/lua`).
3. Add the following line to your Neovim configuration file (`init.vim` or `init.lua`): `require'sourcegraph'`.
4. Change the mapping to the location of your path

E.g.

```sh
  vnoremap <leader>S :lua require'philiplinell.sourcegraph'.search_sourcegraph()<CR>

```

My path is `config/nvim/lua/philiplinell/sourcegraph.lua`.

## Contributing

Contributions are welcome! Please submit a pull request or open an issue if you have any improvements or suggestions.

## Disclaimer

I am not used to the neovim API, lua or sourcegraph!

The majority of `sourcegraph.lua` was written with the help of ChatGPT, as well
as the majority of this README.

These are some of the prompts that I used

```
I would like to create a neovim plugin, in lua, that takes the text I have selected in visual mode and open that in a browser.

The text selected should be used instead of QUERY in the following string:

https://sourcegraph.com/search?q=context:global+QUERY&patternType=standard&sm=1
```

```
I'll create a repository that has the sourcegraph.lua file. Can you suggest a readme for the repository?
```
