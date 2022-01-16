" Use LSP omni-completion in Rust files.
setlocal omnifunc=v:lua.vim.lsp.omnifunc
set foldexpr=nvim_treesitter#foldexpr()
set foldmethod=expr

lua << EOF
local inlay_hints = require('lsp_extensions').inlay_hints

-- Global function, so you can just call it on the lua side
ShowHintsLine = function()
  inlay_hints {
    only_current_line = true
  }
end

ShowHintsFile = function()
  inlay_hints()
end
EOF
" not working for some reason
" autocmd CursorHold,CursorHoldI *.rs :lua ShowHintsLine()

nnoremap <silent> <leader>h <cmd>lua ShowHintsFile()<CR>
