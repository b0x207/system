-- Monkeypatch in a PR to remove a call to the deprecated `client.notify`
-- function.
--
-- See: https://github.com/folke/lazydev.nvim/pull/106
local config = require("lazydev.config")
config.have_0_11 = vim.fn.has("nvim-0.11") == 1

local lsp = require("lazydev.lsp")
lsp.update = function(client)
    lsp.assert(client)
    if config.have_0_11 then
        client:notify("workspace/didChangeConfiguration", {
            settings = { Lua = {} },
        })
    else
        client.notify("workspace/didChangeConfiguration", {
            settings = { Lua = {} },
        })
    end
end

require("lazydev").setup {
    library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        -- { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
}
