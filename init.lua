-- NOTE: OPTIONS

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.wrap = false
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.signcolumn = "no"
vim.opt.isfname:append("@-@")

vim.opt.title = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.updatetime = 50
vim.opt.errorbells = false

vim.g.netrw_banner = 1
vim.g.netrw_mouse = 2

vim.g.ayucolor = "dark"

vim.cmd("colorscheme ayu")


-- NOTE: PLUGINS

require "paq" {
    'savq/paq-nvim',

    'neovim/nvim-lspconfig',

    {
        'lervag/vimtex',
        opt = true
    },

    {
        'nvim-treesitter/nvim-treesitter',
        build = function()
            vim.cmd(':TSUpdate')
        end
    },

    'neovim/nvim-lspconfig';
    'williamboman/mason.nvim';
    'williamboman/mason-lspconfig.nvim';
    'hrsh7th/cmp-nvim-lsp';
    'hrsh7th/cmp-buffer';
    'hrsh7th/cmp-path';
    'hrsh7th/cmp-cmdline';
    'hrsh7th/nvim-cmp';
    'L3MON4D3/LuaSnip';
    'saadparwaiz1/cmp_luasnip';
    'j-hui/fidget.nvim';
    'onsails/lspkind.nvim';

    'onsails/lspkind.nvim';

    'L3MON4D3/LuaSnip';

    'rafamadriz/friendly-snippets';

    'stevearc/conform.nvim';

    'nvim-telescope/telescope.nvim';

    'nvim-lua/plenary.nvim';

    "tpope/vim-fugitive";

    'nvim-lualine/lualine.nvim',

    'nvim-tree/nvim-web-devicons',

    'christoomey/vim-tmux-navigator';

    'windwp/nvim-autopairs';

    'lukas-reineke/indent-blankline.nvim';

    'folke/trouble.nvim';

    'folke/todo-comments.nvim';

    'mbbill/undotree';

    'norcalli/nvim-colorizer.lua';

    'nvim-lua/plenary.nvim';

    {
        'iamcco/markdown-preview.nvim',
        opt = true
    };

    'ayu-theme/ayu-vim';
}

-- TREESITTER
require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "vimdoc", "javascript", "typescript", "c", "lua", "rust",
        "jsdoc", "bash", "python", "cpp", "go"
    },
    sync_install = false,
    auto_install = true,
    indent = {
        enable = true
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
    },
})

local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
treesitter_parser_config.templ = {
    install_info = {
        url = "https://github.com/vrischmann/tree-sitter-templ.git",
        files = { "src/parser.c", "src/scanner.c" },
        branch = "master",
    },
}

vim.treesitter.language.register("templ", "templ")

-- LSP
require('fidget').setup({})
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {
        "bashls", "cssls", "eslint", "graphql", "clangd", "gopls", "jdtls",
        "lua_ls", "markdown_oxide", "pyright", "jsonls", "prismals", "tailwindcss",
    },
    handlers = {
        function(server_name)
            require("lspconfig")[server_name].setup {
                capabilities = vim.tbl_deep_extend(
                    "force",
                    {},
                    vim.lsp.protocol.make_client_capabilities(),
                    require("cmp_nvim_lsp").default_capabilities()
                )
            }
        end,

        zls = function()
            local lspconfig = require("lspconfig")
            lspconfig.zls.setup({
                root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
                settings = {
                    zls = {
                        enable_inlay_hints = true,
                        enable_snippets = true,
                        warn_style = true,
                    },
                },
            })
            vim.g.zig_fmt_parse_errors = 0
            vim.g.zig_fmt_autosave = 0
        end,

        ["lua_ls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup {
                capabilities = vim.tbl_deep_extend(
                    "force",
                    {},
                    vim.lsp.protocol.make_client_capabilities(),
                    require("cmp_nvim_lsp").default_capabilities()
                ),
                settings = {
                    Lua = {
                        runtime = { version = "Lua 5.1" },
                        diagnostics = {
                            globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                        }
                    }
                }
            }
        end,
    }
})

local cmp = require('cmp')
cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    }),
    formatting = {
        expandable_indicator = false,
        fields = { "abbr", "kind", "menu" },
        format = require("lspkind").cmp_format {
            mode = "symbol_text",
            maxwidth = function()
                return math.floor(0.45 * vim.o.columns)
            end,
            ellipsis_char = "...",
            show_labelDetails = false,
            menu = {
                nvim_lsp = "[LSP]",
                path = "[PATH]",
                luasnip = "[SNIP]",
                buffer = "[buff]",
            },
        },
    },
})

vim.diagnostic.config({
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})

-- CONFORM
require("conform").setup({
    notify_on_error = false,
    formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        python = { "autopep8" },
        cpp = { "clang-format" },
        c = { "clang-format" },
        go = { "goimports", "gofmt" },
    },
})

vim.api.nvim_create_user_command("Format", function(args)
    local range = nil
    if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
        }
    end
    require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })

-- TELESCOPE
require('telescope').setup({})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>pws', function()
    local word = vim.fn.expand("<cword>")
    builtin.grep_string({ search = word })
end)
vim.keymap.set('n', '<leader>pWs', function()
    local word = vim.fn.expand("<cWORD>")
    builtin.grep_string({ search = word })
end)
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

-- LUALINE
require('lualine').setup({
    options = {
        theme = 'ayu',
    },
})

-- VIM TMUX NAVIGATOR
vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>TmuxNavigateLeft<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-j>', '<cmd>TmuxNavigateDown<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<cmd>TmuxNavigateUp<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<cmd>TmuxNavigateRight<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-\\>', '<cmd>TmuxNavigatePrevious<CR>', { noremap = true, silent = true })

-- NVIM AUTOPAIRS
require('nvim-autopairs').setup()

require('ibl').setup({
    indent = { char = "┊" },
})

-- TROUBLE
require('trouble').setup({
    icons = false,
})

vim.keymap.set("n", "<leader>tt", function()
    require("trouble").toggle()
end)

vim.keymap.set("n", "[t", function()
    require("trouble").next({ skip_groups = true, jump = true })
end)

vim.keymap.set("n", "]t", function()
    require("trouble").previous({ skip_groups = true, jump = true })
end)

-- TODO COMMENTS
local todo_comments = require("todo-comments")

vim.keymap.set("n", "]t", function()
    todo_comments.jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
    todo_comments.jump_prev()
end, { desc = "Previous todo comment" })

todo_comments.setup()

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- NVIM COLORIZER
require('colorizer').setup()
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    command = "ColorizerAttachToBuffer"
})

-- LUASNIP
local ls = require("luasnip")

ls.filetype_extend("javascript", { "jsdoc" })

vim.keymap.set({ "i" }, "<C-s>e", function() ls.expand() end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-s>;", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-s>,", function() ls.jump(-1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-E>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, { silent = true })

-- MARKDOWN
vim.g.mkdp_filetypes = { "markdown" }

vim.cmd([[
  augroup markdown_preview_build
    autocmd!
    autocmd User PaqInstallPost, PaqUpdatePost ++once call system('cd ' .. fn.stdpath('data') .. '/site/pack/paqs/start/markdown-preview.nvim/app && yarn install')
  augroup END
]])

vim.cmd([[
  command! MarkdownPreviewToggle execute 'MarkdownPreviewToggle'
  command! MarkdownPreview execute 'MarkdownPreview'
  command! MarkdownPreviewStop execute 'MarkdownPreviewStop'
]])


-- NOTE: KEYMAPS

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("i", "jk", "<ESC>")
vim.keymap.set("i", "kj", "<ESC>")

vim.keymap.set("n", "<leader>nj", ":bp<CR>")
vim.keymap.set("n", "<leader>nk", ":bn<CR>")

vim.keymap.set("n", "<leader>nh", ":nohl<CR>")

vim.keymap.set("n", "<leader>fm", ":Format<CR>")
vim.keymap.set("n", "-", ":Ex<CR>")
