local options = {
	backup = false, -- creates a backup file
	swapfile = false, -- creates a swapfile
	-- clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	cmdheight = 1, -- more space in the neovim command line for displaying messages
	conceallevel = 0, -- so that `` is visible in markdown files
	fileencoding = "utf-8", -- the enconding written to a file
	hlsearch = true, -- hightlight all matches on previous search pattern
	ignorecase = true, -- ignore case in search patterns
	mouse = "a", -- allow the mouse to be used in neovim
    pumheight = 10, -- pop up menu height
	showtabline = 2, -- always show tabs
	smartindent = true, -- make indenting smart again
	splitbelow = true, -- force all horizontal splits to go below the currrent window
	splitright = true, -- force all vertical splits to go to the right of the current window
	termguicolors = true, -- set term gui colors
	undofile = true, -- enable persistent undo
	updatetime = 300, -- faster completion
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	expandtab = true, -- convert tabs to spaces
	shiftwidth = 4, -- the number of spaces for each indentation
	tabstop = 4, -- insert 4 spaces for a tab
	cursorline = true, -- highlight the current line
	number = true, -- set numbered lines
	relativenumber = false, -- set relative numbered lines
    signcolumn = "yes", -- always show the sign column
	scrolloff = 8, -- to center view in cursor vertically
}

for key, value in pairs(options) do
	vim.opt[key] = value
end
