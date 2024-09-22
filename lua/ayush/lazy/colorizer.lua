return {
    "norcalli/nvim-colorizer.lua",
    opts = {},
    config = function()
        require('colorizer').setup()
        vim.api.nvim_create_autocmd("VimEnter", {
            pattern = "*",
            command = "ColorizerAttachToBuffer"
        })
    end
}
