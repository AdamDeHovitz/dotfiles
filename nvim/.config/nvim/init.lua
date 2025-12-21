-- Source: https://rdrn.me/neovim-2025/
-- Basic settings
vim.opt.hlsearch = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.spelllang = "en_gb"

-- Leader (this is here so plugins etc pick it up)
vim.g.mapleader = ","  -- anywhere you see <leader> means hit ,

-- use nvim-tree instead
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Use system clipboard
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })

-- Display settings
vim.opt.termguicolors = true
vim.o.background = "dark" -- set to "dark" for dark theme

-- Scrolling and UI settings
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.signcolumn = 'yes'
vim.opt.wrap = false
vim.opt.sidescrolloff = 8
vim.opt.scrolloff = 8

-- Title
vim.opt.title = true
vim.opt.titlestring = "nvim"

-- Persist undo (persists your undo history between sessions)
vim.opt.undodir = vim.fn.stdpath("cache") .. "/undo"
vim.opt.undofile = true

-- Tab stuff
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Search configuration
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true

-- open new split panes to right and below (as you probably expect)
vim.opt.splitright = true
vim.opt.splitbelow = true

-- LSP
vim.lsp.inlay_hint.enable(true)

-- ============================================================================
-- Plugin Manager Setup (lazy.nvim)
-- ============================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- Plugin Definitions
-- ============================================================================

local plugins = {
  { "nvim-lua/plenary.nvim" },       -- used by other plugins
  { "nvim-tree/nvim-web-devicons" }, -- used by other plugins

  -- Catppuccin theme
  { "catppuccin/nvim", name = "catppuccin" },
  
  { "nvim-lualine/lualine.nvim" },  -- status line
  { "nvim-tree/nvim-tree.lua" },    -- file browser

  -- Telescope command menu
  { "nvim-telescope/telescope.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },

  -- TreeSitter
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "nvim-treesitter/nvim-treesitter-textobjects" }, -- text objects for functions, classes, etc.

  -- LSP stuff
  { 'williamboman/mason.nvim' },          -- installs LSP servers
  { 'neovim/nvim-lspconfig' },            -- configures LSPs
  { 'williamboman/mason-lspconfig.nvim' },-- links the two above

  -- Some LSPs don't support formatting, this fills the gaps
  { 'stevearc/conform.nvim' },

  -- Autocomplete engine (LSP, snippets etc)
  -- see keymap:
  -- https://cmp.saghen.dev/configuration/keymap.html#default
  {
    'saghen/blink.cmp',
    version = '1.*',
    build = 'cargo build --release',
    opts_extend = { "sources.default" },
    opts = {
      keymap = {
        preset = 'enter',
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" }
          }
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = true,
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
  },

  -- Git integration
  { "lewis6991/gitsigns.nvim" },
}

require("lazy").setup(plugins)

-- ============================================================================
-- Plugin Configuration
-- ============================================================================

-- Set Catppuccin theme
vim.cmd.colorscheme("catppuccin")

-- Setup plugins
require("lualine").setup()      -- the status line
require("nvim-tree").setup({
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true,
  },
})
require("telescope").setup()    -- command menu

-- TreeSitter configuration
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "typescript",
    "python",
    "rust",
    "go",
    "lua",
    "javascript",
    "html",
    "css",
    -- add more languages as needed!
  },
  sync_install = false,
  auto_install = true,
  highlight = { enable = true, },
  textobjects = {
    move = {
      enable = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
})

-- Code folding using treesitter instead of older methods
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99  -- start with everything unfolded

-- Mason (LSP installer) configuration
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "gopls",
    "basedpyright",
    "eslint",
    "ruff",
    "rust_analyzer",
    -- more available at https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
  },
  automatic_enable = true,  -- automatically enable installed servers
})

-- LSP keybindings - attach these to every LSP client
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)           -- Go to definition
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)          -- Go to declaration
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)           -- Find references
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)       -- Go to implementation
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)                 -- Show documentation
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)       -- Rename symbol
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)  -- Code actions
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)         -- Previous diagnostic
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)         -- Next diagnostic
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts) -- Show diagnostic
  end,
})

-- Conform (code formatter) configuration
require("conform").setup({
  default_format_opts = { lsp_format = "fallback" },
  formatters_by_ft = {
    -- Go
    go = { "gofmt", "goimports" },
    
    -- Terraform
    terraform = { "terraform_fmt" },
    tf = { "terraform_fmt" },
    
    -- JavaScript/TypeScript
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    
    -- Web
    json = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    
    -- Python
    python = { "ruff_format" },
    
    -- Lua (for your Neovim config!)
    lua = { "stylua" },
  },
  -- Format on save (disabled - use ,fo to format manually)
  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_format = "fallback",
  -- },
})

-- Gitsigns configuration (git diff indicators in gutter)
require('gitsigns').setup({
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
  },
})

-- Auto-save on focus loss (like IntelliJ)
vim.api.nvim_create_autocmd("FocusLost", {
  pattern = "*",
  command = "silent! wa"
})

-- ============================================================================
-- Keymaps
-- ============================================================================

-- Moving between splits
vim.keymap.set("n", "<C-j>", "<C-W><C-J>")
vim.keymap.set("n", "<C-k>", "<C-W><C-K>")
vim.keymap.set("n", "<C-l>", "<C-W><C-L>")
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")

-- NvimTree keybindings
vim.keymap.set("n", "<C-t>", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<C-f>", ":NvimTreeFindFile<CR>")
vim.keymap.set("n", "<C-c>", ":NvimTreeClose<CR>")

-- Format current buffer with Conform
vim.keymap.set("n", "<leader>fo", require('conform').format)

-- Toggle between relative and absolute line numbers
vim.keymap.set("n", "<leader>n", ":set relativenumber!<CR>")

-- Show full path of current file
vim.keymap.set("n", "<leader>p", ":echo expand('%:p')<CR>")

-- Telescope keybindings
local tele_builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", tele_builtin.git_files, {})
vim.keymap.set("n", "<leader>fa", tele_builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", tele_builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", tele_builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", tele_builtin.help_tags, {})

-- ============================================================================
-- Keybindings
-- ============================================================================

-- Map space to : in normal mode for quick command entry
vim.keymap.set("n", "<space>", ":")
