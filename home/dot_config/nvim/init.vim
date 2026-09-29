" ============================================================================
" Neovim configuration (init.vim)
" Structure : single-file Vimscript, plugins bootstrapped via lazy.nvim
" Defaults  : sensible core + dark colorscheme
" ============================================================================

" ---------------------------------------------------------------------------
" Leader key (must be set before any <leader> mappings are defined)
" ---------------------------------------------------------------------------
let mapleader = " "             " space as the global leader
let maplocalleader = " "        " ...and as the local leader

" ---------------------------------------------------------------------------
" Sensible core defaults
" ---------------------------------------------------------------------------
set number                      " show absolute line numbers
set relativenumber              " ...and relative numbers for easy motions
set mouse=a                     " enable the mouse in all modes
set clipboard=unnamedplus       " use the system clipboard for yank/paste

set expandtab                   " spaces instead of tabs
set shiftwidth=2                " indent width
set tabstop=2                   " a tab counts for 2 columns
set softtabstop=2               " a <Tab> in insert mode inserts 2 spaces
set smartindent                 " smart autoindent on new lines

set ignorecase                  " case-insensitive searching...
set smartcase                   " ...unless the query has uppercase
set incsearch                   " show matches as you type
set hlsearch                    " highlight all search matches

set scrolloff=8                 " keep 8 lines visible around the cursor
set signcolumn=yes              " always show the sign column (no text jump)
set splitright                  " vertical splits open to the right
set splitbelow                  " horizontal splits open below
set undofile                    " persist undo history across sessions
set updatetime=250              " faster CursorHold / diagnostics
set termguicolors               " enable 24-bit truecolor

" ---------------------------------------------------------------------------
" Bootstrap lazy.nvim (plugin manager) and load plugins
" ---------------------------------------------------------------------------
lua << EOF
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Colorscheme (dark)
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "tokyonight" } })
    end,
  },

  -- Syntax highlighting / parsing
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local treesitter = require("nvim-treesitter")

      treesitter.setup({})
      treesitter.install({
        "lua",
        "vim",
        "vimdoc",
        "bash",
        "python",
        "json",
        "markdown",
        "markdown_inline",
        "toml",
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "lua",
          "vim",
          "help",
          "sh",
          "bash",
          "zsh",
          "python",
          "json",
          "jsonc",
          "markdown",
          "toml",
        },
        callback = function()
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep,  { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers,    { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags,  { desc = "Help tags" })
    end,
  },

  -- LSP: installer + config
  { "williamboman/mason.nvim", config = true },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls" },
      })

      -- Buffer-local LSP keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K",  vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        end,
      })
    end,
  },
}, {
  ui = { border = "rounded" },
})
EOF
