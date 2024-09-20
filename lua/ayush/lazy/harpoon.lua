return {
    "ThePrimeagen/harpoon",
    config = function()
        local harpoon = require("harpoon")

        harpoon.setup()

        vim.keymap.set("n", "<leader>a", function() harpoon.add_file() end)
        vim.keymap.set("n", "<C-e>", function() harpoon.ui.toggle_quick_menu() end)

        for i = 1, 4 do
            vim.keymap.set("n", "<C-" .. string.char(104 + i - 1) .. ">", function() harpoon.ui.nav_file(i) end)
            vim.keymap.set("n", "<leader><C-" .. string.char(104 + i - 1) .. ">", function() harpoon.replace_file(i) end)
        end
    end
}