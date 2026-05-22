local ns = vim.api.nvim_create_namespace("todoage")

local M = {}

function M.refresh()
	vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for i, line in ipairs(lines) do
		if line:find("%f[%w_]TODO%f[%W_]") then
			vim.api.nvim_buf_set_extmark(0, ns, i - 1, 0, {
				virt_text = { { "(found)", "Comment" } },
				virt_text_pos = "eol",
			})
		end
	end
end

return M
