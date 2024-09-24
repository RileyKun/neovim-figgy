-- make all indentations 2 spaces incase we have no formatter on
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- lazy install doesn't exist, fetch it
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- get the latest stable release
    lazypath,
  })
end

-- set path
vim.opt.rtp:prepend(lazypath)

-- enumerate plugins
local plugins = {
  {"catppuccin/nvim", name = "catppuccin", priority = 1000},
  {"nvim-telescope/telescope.nvim", tag = "0.1.5", dependencies = {"nvim-lua/plenary.nvim"}},
  {"nvim-tree/nvim-tree.lua", version = '*', lazy = false, dependencies = {"nvim-tree/nvim-web-devicons"}},
  {"IogaMaster/neocord", event = "VeryLazy"},
  {"williamboman/mason.nvim"}, {"williamboman/mason-lspconfig.nvim"}, {"neovim/nvim-lspconfig"},
  {"nvim-lualine/lualine.nvim", dependencies = {"nvim-tree/nvim-web-devicons"}}
}

-- set options if needed for these plugins
local opts = {}

-- initialize lazy
require("lazy").setup(plugins, opts)

-- setup our colorschema
require("catppuccin").setup()
vim.cmd.colorscheme "catppuccin"

-- setup neocord with our settings
require("neocord").setup({
    -- General options
    logo                = "auto",                     -- "auto" or url
    logo_tooltip        = nil,                        -- nil or string
    main_image          = "language",                 -- "language" or "logo"
    client_id           = "1157438221865717891",      -- Use your own Discord application client id (not recommended)
    log_level           = nil,                        -- Log messages at or above this level (one of the following: "debug", "info", "warn", "error")
    debounce_timeout    = 10,                         -- Number of seconds to debounce events (or calls to `:lua package.loaded.presence:update(<filename>, true)`)
    blacklist           = {},                         -- A list of strings or Lua patterns that disable Rich Presence if the current file name, path, or workspace matches
    file_assets         = {},                         -- Custom file asset definitions keyed by file names and extensions (see default config at `lua/presence/file_assets.lua` for reference)
    show_time           = true,                       -- Show the timer
    global_timer        = true,                       -- if set true, timer won't update when any event are triggered

    -- Rich Presence text options
    editing_text        = "Editing %s",               -- Format string rendered when an editable file is loaded in the buffer (either string or function(filename: string): string)
    file_explorer_text  = "Browsing %s",              -- Format string rendered when browsing a file explorer (either string or function(file_explorer_name: string): string)
    git_commit_text     = "Committing changes",       -- Format string rendered when committing changes in git (either string or function(filename: string): string)
    plugin_manager_text = "Managing plugins",         -- Format string rendered when managing plugins (either string or function(plugin_manager_name: string): string)
    reading_text        = "Reading %s",               -- Format string rendered when a read-only or unmodifiable file is loaded in the buffer (either string or function(filename: string): string)
    workspace_text      = "Working on %s",            -- Format string rendered when in a git repository (either string or function(project_name: string|nil, filename: string): string)
    line_number_text    = "Line %s out of %s",        -- Format string rendered when `enable_line_number` is set to true (either string or function(line_number: number, line_count: number): string)
    terminal_text       = "Using Terminal",           -- Format string rendered when in terminal mode.
})

-- setup neoline
require("lualine").setup()

-- setup nvim-tree
require("nvim-tree").setup()

-- setup mason
require("mason").setup()

-- setup mason's config
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "clangd" }
})

-- create singletons for configuration
local builtin = require("telescope.builtin")
local lsp_config = require("lspconfig")

-- setup our language servers to interact with nvim
lsp_config.lua_ls.setup({})
lsp_config.clangd.setup({})

-- setup keybinds
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', "<C-f>", ":NvimTreeOpen<CR>")
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
