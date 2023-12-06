local lsp = require'lspconfig'

local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

local on_attach = function(client, bufnr)
  local set = vim.keymap.set
  -- [[ other on_attach code ]]
  set('n', 'K', vim.lsp.buf.hover, {silent=true})

  -- illuminate stuff
  local illuminate = require"illuminate"
  set('n', '<leader>gn', illuminate.next_reference, {silent=true})
  set('n', '<leader>gp', function () illuminate.next_reference{reverse=true} end, {silent=true})
  require 'illuminate'.on_attach(client)


  set('n', '<leader>ln', function () vim.diagnostic.goto_next { wrap = false } end, {silent = true})
  set('n', '<leader>lp', function () vim.diagnostic.goto_prev { wrap = false } end, {silent = true})
  set('n', '<leader>ld', vim.lsp.buf.definition, {silent = true})
  set('n', '<leader>lrf', vim.lsp.buf.references, {silent = true})
  set('n', '<leader>lrn', vim.lsp.buf.rename, {silent = true})
  set('n', '<leader>la', vim.lsp.buf.code_action, {silent = true})
  set('n', '<leader>lf', function () vim.lsp.buf.format({ async = false }) end, {})
  set('n', '<leader><cr>', vim.diagnostic.open_float, {silent = true})

  -- Use LSP omni-completion in LSP enabled files.
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
end
return {capabilities = capabilities, on_attach = on_attach}
