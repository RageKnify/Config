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
  -- illuminate stuff
  local illuminate = require"illuminate"
  require 'illuminate'.on_attach(client)


  set('n', '<leader>lrf', vim.lsp.buf.references, {silent = true})
  set('n', '<leader>lrn', vim.lsp.buf.rename, {silent = true})
  set('n', '<leader>la', vim.lsp.buf.code_action, {silent = true})
  set('n', '<leader>lf', vim.lsp.buf.format, {silent = true})
  set('n', '<leader><cr>', vim.diagnostic.open_float, {silent = true})

  if client.supports_method('textDocument/inlayHint') then
    set('n', '<leader>i', function()
      vim.lsp.inlay_hint.enable(
        not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
        { bufnr = bufnr }
      )
    end, { buffer = bufnr })
  end
end
return {capabilities = capabilities, on_attach = on_attach}
