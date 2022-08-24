-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- install your plugins here
return packer.startup(function(use)
    use "wbthomason/packer.nvim" -- have packer manage itself

    use "windwp/nvim-autopairs" -- self-explanatory

    use "ellisonleao/gruvbox.nvim" -- gruvbox theme

    use {
        "nvim-treesitter/nvim-treesitter",
        run = ":TSUpdate"
    } -- better syntax highlighting
end)
