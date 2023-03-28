
call plug#begin('~/.config/nvim/plugged')
Plug 'preservim/nerdtree'
Plug 'tpope/vim-commentary'
Plug 'andymass/vim-visput'
Plug 'davidc360/candy.vim'
Plug 'junegunn/vim-easy-align'
Plug 'wesQ3/vim-windowswap'
Plug 'christoomey/vim-tmux-navigator'
Plug 'ojroques/nvim-osc52'
Plug 'chentoast/marks.nvim'
Plug 'nvim-lualine/lualine.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip', {'do': 'make install_jsregexp'}
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'karb94/neoscroll.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'marko-cerovac/material.nvim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'nvim-treesitter/playground'
Plug 'ggandor/leap.nvim'

call plug#end()

syntax on
let mapleader = " "

if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  let &t_Cs = "\e[4:3m"
  let &t_Ce = "\e[4:0m"

  set termguicolors
endif
colorscheme candy

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set number " show line number
set nowrap
set smartcase
set noswapfile
set nobackup
set undofile
set incsearch
set wrap
set ttimeoutlen=10
set cursorline
hi CursorLine cterm=NONE ctermbg=black guibg=black

" spell check
set spell spelllang=en
set spellfile="~/.config/nvim/spell/en.utf-8.spl"
hi SpellBad guifg=red gui=undercurl cterm=undercurl

let g:NERDTreeStatusline = '%#NonText#'
let NERDTreeQuitOnOpen=1
let g:tmux_navigator_no_wrap = 1


lua vim.keymap.set('n', '<leader>c', require('osc52').copy_operator, {expr = true})
lua vim.keymap.set('n', '<leader>cc', '<leader>c_', {remap = true})
lua vim.keymap.set('v', '<leader>c', require('osc52').copy_visual)
lua vim.keymap.set('v', '<C-c>', require('osc52').copy_visual)
lua vim.g.python3_host_prog="/opt/bb/bin/python3.8"

lua << END
require('leap').add_default_mappings()
vim.keymap.set('n', 's', function ()
  local current_window = vim.fn.win_getid()
  require('leap').leap { target_windows = { current_window } }
end)

require'colorizer'.setup()
require('neoscroll').setup{
    hide_curosr = false,
    performace_mode = true,
    easing_function = 'easeOutQuint'
}
local t = {}
-- Syntax: t[keys] = {function, {function arguments}}
-- Use the "sine" easing function
t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '80', [['sine']]}}
t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '80', [['sine']]}}
-- Pass "nil" to disable the easing animation (constant scrolling speed)
t['<C-y>'] = {'scroll', {'-0.10', 'false', '30', [['sine']]}}
t['<C-e>'] = {'scroll', { '0.10', 'false', '30', [['sine']]}}
-- When no easing function is provided the default easing function (in this case "quadratic") will be used
t['zt']    = {'zt', {'80'}}
t['zz']    = {'zz', {'80'}}
t['zb']    = {'zb', {'80'}}

require('neoscroll.config').set_mappings(t)
require('marks').setup { 
     default_mappings = true, 
     builtin_marks = { ".", "<", ">", "^", '"' },
     refresh_interval = 500, 
     bookmark_0 = { 
         sign = "⚑", 
         virt_text = "hello world", 
         annotate = true, 
     }, 
     mappings = {} 
}
status_blue = "#5093bf" 
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = {
         normal = {
            c = { fg = "black", bg = status_blue },
            a = { fg = "black", bg = status_blue },
            b = { fg = "black", bg = status_blue },
         },
     },
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {
        { 
            'branch', 
            icon="",
            fmt = function(branch) return branch == "" and "" or ("[" .. branch .. "]") end,
            padding = { left=0, right=1}
        },
        'diagnostics'
    },
    lualine_b = {
        {
            'buffers', 
            mode = 2,
            buffers_color = { 
                active   = { fg = "black", bg = "#64adde" },
                inactive = { fg = "black", bg = "#5093bf" },
            },
            symbols = {
                modified = ' [+]',      -- Text to show when the buffer is modified
                alternate_file = '', -- Text to show to identify the alternate file
                directory =  '',     -- Text to show when the buffer is a directory
          },
        }
    },
    lualine_c = {},

    lualine_x = {
        {
            'filetype', 
            padding = 0,
            fmt = function(text) return text == "" and "" or text .. " |" end
        }
    },
    lualine_y = {},
    lualine_z = { 
        {   
            "", 
            fmt = function() return "line %02l/%02L (%p%%)" end 
        } 
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "help", "query" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  -- ignore_install = { "javascript" },

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    -- disable = { "c", "rust" },
    disable = {},
    -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
-- vim.g.material_style = "palenight"
local colors = require 'material.colors'
require('material').setup({

    contrast = {
        terminal = false, -- Enable contrast for the built-in terminal
        sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
        floating_windows = false, -- Enable contrast for floating windows
        cursor_line = false, -- Enable darker background for the cursor line
        non_current_windows = false, -- Enable darker background for non-current windows
        filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
    },

    styles = { -- Give comments style such as bold, italic, underline etc.
        comments = { --[[ italic = true ]] },
        strings = { --[[ bold = true ]] },
        keywords = { --[[ underline = true ]] },
        functions = { --[[ bold = true, undercurl = true ]] },
        variables = {},
        operators = {},
        types = {},
    },

    plugins = { -- Uncomment the plugins that you use to highlight them
        -- Available plugins:
        -- "dap",
        -- "dashboard",
        -- "gitsigns",
        -- "hop",
        -- "indent-blankline",
        -- "lspsaga",
        -- "mini",
        -- "neogit",
        -- "neorg",
        "nvim-cmp",
        -- "nvim-navic",
        -- "nvim-tree",
        -- "nvim-web-devicons",
        -- "sneak",
        -- "telescope",
        -- "trouble",
        -- "which-key",
    },

    disable = {
        colored_cursor = false, -- Disable the colored cursor
        borders = false, -- Disable borders between verticaly split windows
        background = false, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
        term_colors = false, -- Prevent the theme from setting terminal colors
        eob_lines = false -- Hide the end-of-buffer lines
    },

    high_visibility = {
        lighter = false, -- Enable higher contrast text for lighter style
        darker = false -- Enable higher contrast text for darker style
    },

    lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )

    async_loading = true, -- Load parts of the theme asyncronously for faster startup (turned on by default)

    -- If you want to everride the default colors, set this to a function
    custom_colors = function(colors)
        colors.main.deepblack   = "#000000"
        colors.main.white       = "#efeeea"
        colors.main.white_dark  = "#919191"
        colors.main.red         = "#ff79c6"
        colors.main.darkred     = "#cc0e3d"
        colors.main.purple      = "#ce7af5"
        colors.main.yellow      = "#ffce5b"
        colors.main.orange      = "#ffce5b"
        colors.main.lightyellow = "#ebe5cc"
        colors.main.blue        = "#6c89f5" -- #82AAFF
        colors.main.cyan        = "#3a98d6" -- #4daedb 
        colors.main.green       = "#2cda9d"
        colors.main.darkgreen   = "#4c8273"
        colors.main.gray        = "#585858"
        colors.main.pink        = "#cf3c60"

        colors.editor.bg           = "#2a2e38"
        colors.editor.bg_alt       = "#1B1E2B"
        colors.editor.fg           = colors.main.white
        colors.editor.fg_dark      = colors.main.white_dark
        colors.editor.selection    = colors.main.cyan
        colors.editor.contrast     = "#202331"
        colors.editor.active       = colors.main.cyan
        colors.editor.border       = "#0a6ea8"
        colors.editor.line_numbers = colors.main.gray
        colors.editor.highlight    = "#444267"
        colors.editor.disabled     = "#515772"
        colors.editor.accent       = colors.main.deepblack

        colors.backgrounds.floating_windows    = colors.editor.bg
        colors.backgrounds.cursor_line         = colors.main.black
        colors.backgrounds.non_current_windows = colors.editor.bg

        colors.syntax.variable = colors.editor.fg
        colors.syntax.field    = colors.editor.lightyellow
        colors.syntax.keyword  = colors.main.pink
        colors.syntax.value    = colors.main.orange
        colors.syntax.operator = colors.main.cyan
        colors.syntax.fn       = colors.main.blue
        colors.syntax.string   = colors.main.green
        colors.syntax.type     = colors.main.cyan
        colors.syntax.comments = colors.main.darkgreen
    end,

    custom_highlights = {
        -- undercurl is not supported in windows terminal
        SpellBad         = { fg = "#cc0e3d", italic = trues, undercurl = true, strikethrough = true },
        MarkSignNumHL    = { bg = "" },
        CursorLineNr     = { fg = "#ffce5b", bg = "#000000" },
        CmpItemAbbrMatch = { fg = "#000000" },
        CmpItemKindText  = { fg = "#242424" },
        ["@keyword"]     = { fg = "#cf3c60" },
        ["@field"]       = { fg = "#bab8ad" }
    }
})

vim.cmd 'colorscheme material'
END

" set up autocomplete"
lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-i>'] = cmp.mapping.confirm({ select = true })
      -- ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' }, -- For luasnip users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  --[[
  require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
    capabilities = capabilities
  }
  ]]--
EOF

set mouse=a
let g:NERDTreeMouseMode=2
let g:NERDTreeWinSize=22

" set statusline=
set statusline+=\ %n
set statusline+=\ %<%t%m%r%h%w\                       " File path, modified, readonly, helpfile, preview
set statusline+=%=                                       " Right Side
set statusline+=\ line\ %02l/%L\ (%p%%)\              " Line number / total lines, percentage of document

hi statusline guibg=#5093bf guifg=black
" inactive status, guifg has to be before guibfj
hi statuslineNC guifg=#9e9e9e guibg=get(get(g:candid_color_store, "black"), "gui")
" remove vertical split lines
set laststatus=3
set fillchars=vert:\ 
hi VertSplit guibg=NONE guifg=NONE ctermbg=NONE ctermfg=NONE

" key maps 

nnoremap <C-f> :NERDTreeToggle<Cr>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
noremap <C-s> :w<CR>
noremap <C-q> :q<CR>
inoremap <C-s> <Esc>:w<CR>
nnoremap B 6b
nnoremap W 6w
nnoremap E 6e

vnoremap p pgvy

nnoremap j gj
nnoremap k gk

vnoremap J 5j
nnoremap J 5j
vnoremap K 5k
nnoremap K 5k

nnoremap + J
" exit terminal mode with esc
tnoremap <Esc> <C-\><C-n>

nnoremap <Leader>n :bnext<Cr>
nnoremap <Leader>pp :bprev<Cr>

inoremap { {}<left>
inoremap {} {}
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

nnoremap <C-a> ggVG
inoremap <C-a> <Esc>ggVG

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
"
" " Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
noremap <C-_> :Commentary<Cr>

" highlight! EndOfBuffer ctermbg=bg ctermfg=bg guibg=bg guifg=bg

" References:
" " [1] https://github.com/asvetliakov/vscode-neovim/issues/103
" " [2] https://github.com/Microsoft/WSL/issues/892

let clip = '/mnt/c/Windows/System32/clip.exe'  " change this path according to your mount point [2]
" copy to 'a' register, then call it by @a
" map <leader>c "ay:call system(clip, @a)<Cr>
" vnoremap <leader>x d:call system(clip, @")<Cr>

" highlight trailing white spaces
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$/

" Highlight all instances of word under cursor, when idle.
" list of colors: :so $VIMRUNTIME/syntax/hitest.vim
:autocmd CursorMoved * exe printf('match Underlined /\V\<%s\>/', escape(expand('<cword>'), '/\'))
