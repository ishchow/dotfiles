local use = require('packer').use
local empty = vim.fn.empty
local glob = vim.fn.glob
local expand = vim.fn.expand

return require('packer').startup(function()
    -- Packer can manage itself as an optional plugin
    use {'wbthomason/packer.nvim', opt = true}

    -- #### Colorschemes ####
    use 'sainnhe/sonokai'
    -- #### Colorschemes ####

    -- #### Editing ####
    use 'tomtom/tcomment_vim' -- Comments
    use 'machakann/vim-sandwich' -- Quotes/Paranthesizing
    use 'jiangmiao/auto-pairs' -- Automatically add pairs for code punctuation
    use 'unblevable/quick-scope' -- Highlight unique characters in line for easy f/F
    -- #### Editing ####

    -- #### Cosmetic Stuff ####
    use 'Yggdroot/indentLine' -- Display thin vertical lines for indents
    use 'itchyny/lightline.vim' -- Status bar
    -- #### Cosmetic Stuff ####

    -- #### Git ####
    use 'lambdalisue/gina.vim' -- Async control of git repos (similar to vim-fugitive)
    use 'airblade/vim-gitgutter' -- Git gutter
    -- #### Git ####

    -- #### Search ####
    use 'haya14busa/is.vim' -- Automatically clear search highlight after cursor moves
    use 'nelstrom/vim-visual-star-search' -- Modify * to also work with visual selections.
    use 'mhinz/vim-grepper' -- Handle multi-file find and replace.
    -- #### Search ####

    -- #### Misc ####
    use 'voldikss/vim-floaterm' -- Create floating terminals
    -- #### Misc ####

    -- #### Syntax Highlighting ####
    use 'lepture/vim-jinja' -- Jinja/Nunjucks Template Highlighting
    -- #### Syntax Highlighting ####

    if vim.fn.has('nvim-0.5') then
        -- #### Telescope ####
        use {
            'nvim-telescope/telescope.nvim', -- Fuzzy finder
            requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
        }
        -- #### Telescope ####
    end
end)
