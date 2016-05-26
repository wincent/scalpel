# Intro

Scalpel provides a streamlined shortcut for replacing all instances of the word currently under the cursor throughout a file.

In normal mode pressing `<Leader>e` (mnemonic: "edit") will display a prompt pre-populated with the current word and with the cursor placed so that you can start typing the desired replacement:

```
:Scalpel/\v<foo>//
```

Press `<Enter>` and Scalpel will prompt to confirm each substitution, starting at the current word (unlike a normal `:%s` command, which starts at the top of the file).

Scalpel works similarly in visual mode, except that it scopes itself to the current visual selection rather than operation over the entire file.

Note that `:Scalpel` just calls through to an underlying `scalpel#substitute` function that does the real work, ultimately calling Vim's own `:substitute`. As such, be aware that whatever changes you make to the command-line prior to pressing `<Enter>` must keep it a valid pattern, or bad things will happen.

The mapping can be suppressed by setting:

```
let g:ScalpelMap=0
```

Or overridden:

```
" Use <Leader>s instead of default <Leader>e:
nmap <Leader>s <Plug>(Scalpel)
```

In any case, Scalpel won't overwrite any pre-existing mapping that you might have defined for `<Leader>e`, nor will it create an unnecessary redundant mapping if you've already mapped something to `<Plug>(Scalpel)`.

The `:Scalpel` command name can be overridden if desired. For example, you could shorten it to `:S` with:

```
let g:ScalpelCommand='S'
```

Then your Scalpel prompt would look like:

```
:S/\v<foo>//
```

The command can be entirely suppressed by setting `g:ScalpelCommand` to an empty string:

```
let g:ScalpelCommand=''
```

Finally, all plug-in functionality can be deactivated by setting:

```
let g:ScalpelLoaded=1
```

in your `~/.vimrc`.

# Installation

To install Scalpel, use your plug-in management system of choice.

If you don't have a "plug-in management system of choice" and your version of Vim has `packages` support (ie. `+packages` appears in the output of `:version`) then you can simply place the plugin at a location under your `'packpath'` (eg. `~/.vim/pack/bundle/start/scalpel` or similar).

For older versions of Vim, I recommend [Pathogen](https://github.com/tpope/vim-pathogen) due to its simplicity and robustness. Assuming that you have Pathogen installed and configured, and that you want to install Scalpel into `~/.vim/bundle`, you can do so with:

```
git clone https://github.com/wincent/scalpel.git ~/.vim/bundle/scalpel
```

Alternatively, if you use a Git submodule for each Vim plug-in, you could do the following after `cd`-ing into the top-level of your Git superproject:

```
git submodule add https://github.com/wincent/scalpel.git ~/vim/bundle/scalpel
git submodule init
```

To generate help tags under Pathogen, you can do so from inside Vim with:

```
:call pathogen#helptags()
```

# Website

The official Scalpel source code repo is at:

http://git.wincent.com/scalpel.git

Mirrors exist at:

- https://github.com/wincent/scalpel
- https://gitlab.com/wincent/scalpel
- https://bitbucket.org/ghurrell/scalpel

Official releases are listed at:

http://www.vim.org/scripts/script.php?script_id=5381

# License

Copyright (c) 2016-present Greg Hurrell

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Development

## Contributing patches

Patches can be sent via mail to greg@hurrell.net, or as GitHub pull requests at: https://github.com/wincent/scalpel/pulls

## Cutting a new release

At the moment the release process is manual:

- Perform final sanity checks and manual testing.
- Update the [scalpel-history](#user-content-scalpel-history) section of the documentation.
- Verify clean work tree:

```
git status
```

- Tag the release:

```
git tag -s -m "$VERSION release" $VERSION
```

- Publish the code:

```
git push origin master --follow-tags
git push github master --follow-tags
```

- Produce the release archive:

```
git archive -o scalpel-$VERSION.zip HEAD -- .
```

- Upload to http://www.vim.org/scripts/script.php?script_id=5381

# Authors

Scalpel is written and maintained by Greg Hurrell <greg@hurrell.net>.

# History

## 0.2 (not yet released)

- Support visual mode.

## 0.1 (29 April 2016)

- Initial release.
