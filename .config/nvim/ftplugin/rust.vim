" Use LSP omni-completion in Rust files.
setlocal omnifunc=v:lua.vim.lsp.omnifunc

lua << EOF
local inlay_hints = require('lsp_extensions.inlay_hints')

local M = {}

-- Global function, so you can just call it on the lua side
ShowHintsLine = function()
  vim.lsp.buf_request(0, 'rust-analyzer/inlayHints', inlay_hints.get_params(), inlay_hints.get_callback {
    only_current_line = true
  })
end

ShowHintsFile = function()
  vim.lsp.buf_request(0, 'rust-analyzer/inlayHints', inlay_hints.get_params(), inlay_hints.get_callback{})
end
EOF
autocmd CursorHold,CursorHoldI,CursorMoved *.rs :lua ShowHintsLine()

nnoremap <silent> <leader>h <cmd>lua ShowHintsFile()<CR>
