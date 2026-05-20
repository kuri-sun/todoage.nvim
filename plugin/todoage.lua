vim.api.nvim_create_user_command("Todoage", function()
	require("todoage").refresh()
end, {})
