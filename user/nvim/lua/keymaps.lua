local keymap = vim.keymap.set

-- Window manipulation
keymap("n", "<leader>c", "<C-w>c", { desc = "Close the current window" })
keymap("n", "<leader>n", "<C-w>n", { desc = "Create a new window" })

-- Tab management
keymap("n", "<leader>to", vim.cmd.tabnew, { desc = "Open a new tab" })
keymap("n", "<leader>tq", vim.cmd.tabclose, { desc = "Close the current tab" })
keymap("n", "<leader>tn", vim.cmd.tabnext, { desc = "Next tab" })
keymap("n", "<leader>tp", vim.cmd.tabprevious, { desc = "Previous tab" })
keymap("n", "<M-L>", vim.cmd.tabnext, { desc = "Next tab" })
keymap("t", "<M-L>", vim.cmd.tabnext, { desc = "Next tab" })
keymap("n", "<M-H>", vim.cmd.tabprevious, { desc = "Previous tab" })
keymap("t", "<M-H>", vim.cmd.tabprevious, { desc = "Previous tab" })
keymap("n", "<M-S-0>", vim.cmd.tabfirst, { desc = "First tab" })
keymap("t", "<M-S-0>", vim.cmd.tabfirst, { desc = "First tab" })

-- Package Management
keymap("n", "<leader>pu", vim.pack.update, { desc = "Update all plugins" })

-- Pickers
keymap("n", "<leader>pf", function()
    MiniPick.builtin.files({ tool = 'rg' })
end, { desc = "Fuzzy find files" })
keymap("n", "<leader>ph", function()
    MiniPick.builtin.help()
end, { desc = "Fuzzy find help" })
keymap("n", "<leader>pg", function()
    MiniPick.builtin.grep_live()
end, { desc = "Fuzzy find live grep" })
keymap("n", "<leader>pl", function()
    MiniExtra.pickers.lsp({ scope = "workspace_symbol_live" })
end, { desc = "Fuzzy find LSP symbols" })
keymap("n", "<leader>pm", function()
    MiniExtra.pickers.manpages()
end, { desc = "Fuzzy find man pages" })
keymap("n", "<leader>pd", function()
    MiniExtra.pickers.diagnostic()
end, { desc = "Fuzzy find LSP diagonstics" })

-- File system management
keymap("n", "<leader>nt", function()
    -- We do it this way so that there aren't a million errors on the first install
    require("oil").open_float()
end, { desc = "Open a file tree editor" })

-- Terminal workflow
keymap("n", "<leader>tt", function()
    vim.cmd("belowright vsplit")
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(true, true)
    vim.api.nvim_win_set_buf(win, buf)
    vim.cmd("terminal")
end)
keymap("t", "<C-w>", "<C-\\><C-n><C-w>")

-- LSP
keymap("n", "<leader>gd", vim.lsp.buf.definition)
keymap("n", "<leader>gs", vim.lsp.buf.declaration)
keymap("n", "<leader>i", vim.lsp.buf.hover)
keymap("n", "<leader>e", vim.diagnostic.open_float)

-- Hex Editing
keymap("n", "<leader>ho", function()
    vim.cmd("HexDump")
    vim.cmd("set noeol")
end, { desc = "Hex editing on" })
keymap("n", "<leader>hf", function()
    vim.cmd("HexAssemble")
    vim.cmd("set eol")
end, { desc = "Hex editing off" })
