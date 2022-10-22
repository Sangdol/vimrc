vimrc for neovim
===

Opinionated vimrc files with three goals:

* Be pragmatic than "right".
* Keep it maintainable.
* Make it easy to troubleshoot.

Please check out my blog post [Learnings after 500 commits to my vimrc](https://iamsang.com/en/2022/04/13/vimrc/) if you want to know more about my vimrc.

![vimrc cartoon](/images/cartoon-vimrc.png)

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
* Git / GitHub

### Languages

Languages that I mainly write with vim:

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
   │  ├── setoptions.vim    " Setting vim options
   │  ├── statusline.vim    " Setting statuline
   │  ├── autocmd.vim       " General autocommands
   │  ├── mappings.vim      " General mappings
   │  ├── colorscheme.vim   " Colorscheme and highlights
   │  ├── functions.vim     " Functions and commands that can be used while using vim
   │  ├── utility.vim       " Utility functions that can be used writing vimscript
   │  ├── test.vader        " Test code that tests functions of utility.vim
   │  ├── plug.vim          " Plug root that sources plugins.vim and devplugins.vim conditionally
   │  ├── plugins.vim       " Plugins and related mappings and configuration
   │  └── devplugins.vim    " Plugins and related mappings and configuration for coding (only loaded on macOS)
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

Plugin Code Locality with Plug
---

### Lua `require`

Each section in `plugins.vim` and `devplugins.vim` has one or more [Plug](https://github.com/junegunn/vim-plug) commands and related mappings and configuration. A helper callback function is used for code that has to be run after `plug#end()`, e.g., the Lua `require()` function has to run after `plug#end()` since Lua modules can be loaded after `runtimepath` are set which is done by the `end()` function.

[VOoM](https://github.com/vim-scripts/VOoM) is used to show outlines.

![plugin code locality](/images/plugin-code-locality.png)

### Highlights

`highlight` commands have to be executed after a colorscheme command and they should be executed again when the colorscheme is changed. To achieve this, `highlight` commands are in an autocommands following [this advice](https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f).

For example,

```vim
Plug 'dstein64/nvim-scrollview'

function! s:scrollview_highlights()
  highlight ScrollView ctermbg=159 guibg=LightCyan
endfunction

augroup ScrollViewColors
  autocmd!
  autocmd ColorScheme * call s:scrollview_highlights()
augroup END
```

Mapping tree
---

The lists below are the structure of normal mode mappings. I use them to structurally manage mappings and easily find empty slots for new mappings. They are not exhaustive.

[The Fzf :Maps command](https://github.com/junegunn/fzf.vim#commands) and [the which-key plugin](https://github.com/folke/which-key.nvim) can be used to search the details of the current mappings.

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
* m
  * Toggle Voom / Tagbar
  * Markdown
* n: `noh`
* o
* p: Plug
* q: close window
* r
  * re: rename
* s: coc
* t: nvim terminal related mappings
* u: `update`
* v
  * vimrc related mapping
  * vader related mapping
* w: maping for windows
* x: python
  * pytest
  * docstring
* y
* z: Conjure

### Etc.

* `UP/DOWN`: move to previous/next tab

License
---

MIT
