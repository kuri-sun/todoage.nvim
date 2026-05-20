local ns = vim.api.nvim_create_namespace("todoage")

local M = {}

function M.refresh()
	vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

	vim.api.nvim_buf_set_extmark(
		0, -- 0 for current buffer
		ns, -- the namespace id from create_namespace
		0, -- 0-indexed!! line 1 = 0
		0, -- 0-indexed; for end-of-line virt_text, 0 is fine
		{
			virt_text = { { "(hardcoded)", "Comment" } },
			virt_text_pos = "eol",
		}
	)
end

return M
