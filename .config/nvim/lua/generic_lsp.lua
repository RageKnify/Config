return function(client)
	-- [[ other on_attach code ]]
	vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
	vim.cmd [[autocmd CursorHold <buffer> :lua vim.lsp.buf.hover()]]

	-- illuminate stuff
	vim.api.nvim_buf_set_keymap(0, 'n', '<leader>gn', '<cmd>lua require"illuminate".next_reference{}<cr>', {noremap = true})
	vim.api.nvim_buf_set_keymap(0, 'n', '<leader>gp', '<cmd>lua require"illuminate".next_reference{reverse=true}<cr>', {noremap = true})
	require 'illuminate'.on_attach(client)
end
