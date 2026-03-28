local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Highlight yanked text
local highlight_group = augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({ timeout = 170 })
    end,
    group = highlight_group,
})

-- Package update/build hooks
local packages_group = augroup("PackageUpdates", { clear = true })
autocmd("PackChanged", {
    pattern = "*",
    callback = function(ev)
        local kind = ev.data.kind
        local spec = ev.data.spec
        local path = ev.data.path

        if not (kind == "install" or kind == "update") then
            return
        end

        local on_exit = function(obj)
            if not obj.code == 0 then
                vim.notify("Failed to run build command!\n" .. obj.stdout .. "\n" .. obj.stderr)
            end
        end

        if spec.data == nil or spec.data.build == nil then
            return
        end

        vim.schedule(function()
            vim.system(spec.data.build, { cwd = path }, on_exit)
        end)

        vim.notify(path .. " was " .. kind)
    end,
    group = packages_group
})

-- Terminals
vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter", "TermOpen" }, {
    callback = function(args)
        if vim.startswith(vim.api.nvim_buf_get_name(args.buf), "term://") then
            vim.cmd("startinsert")
        end
    end,
})

-- Set indentation to 2 spaces for certain file types
augroup("setIndent", { clear = true })
autocmd("Filetype", {
  group = "setIndent",
  pattern = { "nix" },
  command = "setlocal shiftwidth=2 tabstop=2"
})
