vimrc for neovim
===

![vim terminal screenshot](/screenshots/vimrc.png)

Opinionated vimrc files with three goals:

* Be pragmatic than "right"
* Keep it maintainable
* Make it easy to troubleshoot

Prerequisite
---

I minimized code that checks compatibility to keep it clean.

* Neovim >= 0.6.0

Features
---

* Modularized vimrc files
* Blocked sections
* Plugin code locality
* Utility functions and unit tests written in [Vader](https://github.com/junegunn/vader.vim)

Installation
---

Caveat: the code keeps evolving and is highly customized to my workflow.

```sh
# After cloning the project to $PROJECT_HOME
cd ~
ln -s $PROJECT_HOME/vimrc .vimrc
ln -s $PROJECT_HOME/vim .vim
ln -s $PROJECT_HOME/ideavimrc .ideavimrc
```

Development Environment
---

### Tools

* macOS
* Linux (only for server management)
* iTerm2 (no MacVim)
* IntelliJ
* Git

### Languages

Languages that I mainly write with vim:

* Scala
* Python
* Clojure
* Lua
* vimscript
* bash script
* fish script
* Markdown

Project Structure
---

```vim
.
├── vimrc                   " RC root file that soures vimrc files in the 'vim/rc' directory
├── ideavimrc               " IntelliJ IdeaVim RC file
└── vim
   ├── rc                   " Modularized vimrc files
   │  ├── setoptions.vimrc  " Setting vim options
   │  ├── statusline.vimrc  " Setting statuline
   │  ├── autocmd.vimrc     " General autocommands
   │  ├── mappings.vimrc    " General mappings
   │  ├── colorscheme.vimrc " Colorscheme and highlights
   │  ├── functions.vimrc   " Functions and commands that can be used while using vim
   │  ├── utility.vimrc     " Utility functions that can be used writing vimscript
   │  ├── test.vader        " Test code that tests functions of utility.vimrc
   │  ├── plug.vimrc        " Plug root that sources plugins.vim and devplugins.vimrc conditionally
   │  ├── plugins.vimrc     " Plugins and related mappings and configuration
   │  └── devplugins.vimrc  " Plugins and related mappings and configuration for writing code
   ├── colors               " Directory with colorscheme files
   ├── backup               " Directory with a README file. Backup files are git ignored.
   ├── swap                 " Directory with a README file. Swap files are git ignored.
   ├── after
   │  └── syntax
   │     └── markdown.vim   " Customized markdown syntax
   └── syntax               " Customized git syntax to make it work better for my workflow
      ├── git.vim
      └── gitcommit.vim
```

Plugin Code Locality
---

Each section in `plugins.vimrc` and `devplugins.vimrc` has one or more [Plug](https://github.com/junegunn/vim-plug) commands and related mappings and configuration. Helper callback functions are used for code that has to be run after `plug#end()`, e.g., the Lua `require()` function has to run after `plug#end()` since Lua modules can be loaded after `runtimepath` are set which is done by the `end()` function.

[VOoM](https://github.com/vim-scripts/VOoM) is used to show outlines.

![plugin code locality](/screenshots/plugin-code-locality.png)

Mapping tree
---

This is the structure of normal mode mappings. This is used to structurally manage mappings and easily find empty slots for new mappings. This is not an exhaustive list.

The `:map` or the [Fzf :Maps command](https://github.com/junegunn/fzf.vim#commands) can be used to search the current mappings as well.

### Ctrl

* `<C-q>`: go to the previous window (the same as `<c-w>p`)
* `<C-k/j>`: move a line up/down
* `<C-h/l>`: indent left/right

### Numbers

* `(numbers)<leader>`: select windows
* `(numbers)<BS>`: close windows
* `(numbers),`: select tabs

### `<Leader>`

* (numbers): select windows
* a: yank all
* b: open URL in a browser (it works for a `Plug` line as well)
* c
* d
  * d: delete all
  * o, h, l: diff
* e: etc
  * numbers: copy file paths
  * u: undotree
  * s: spell!
* f: Fzf related mappings
* g: Git related mappings
* h
* i: `set nolist!` (show invisible characters)
* j: Easymotion
* k: Easymotion
* l: `tabnew`
* m: Toggle Voom
* n: `noh`
* o: Octo (in `device_local.vimrc`)
* p
* q: close window
* r
  * re: rename
  * rl, ro, rr: ReplaceWithRegister related mappings
* s: coc related mappings
* t: nvim terminal related mappings
* u: `update`
* v
  * vimrc related mapping
  * vader related mapping
* w: maping for windows
* x
* y
* z: Conjure

### Etc.

* `UP/DOWN`: move to previous/next tab

License
---

MIT
