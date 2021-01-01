return function(client)
	-- [[ other on_attach code ]]
	vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
	vim.cmd [[autocmd CursorHold <buffer> :lua vim.lsp.buf.hover()]]
	require 'illuminate'.on_attach(client)
end
