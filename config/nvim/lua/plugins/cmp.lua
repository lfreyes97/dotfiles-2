local cmp = require "cmp"
local luasnip = require "luasnip"

cmp.setup {
  experimental = {
    ghost_text = false,
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = O.icons.kinds[vim_item.kind]
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snip]",
        buffer = "[Buf]",
        spell = "[Spl]",
        path = "[Path]",
        cmdline = "[Cmd]",
      })[entry.source.name]
      return vim_item
    end,
  },
  documentation = {
    border = O.borders,
  },
  sources = {

    { name = "luasnip" },
    { name = "path" },
    { name = "spell" },
    { name = "buffer" },
  },
}
local search_sources = {
  sources = cmp.config.sources({
    { name = "nvim_lsp_document_symbol" },
  }, {
    { name = "buffer" },
  }),
}
-- Use buffer source for `/`.
cmp.setup.cmdline("/", search_sources)
cmp.setup.cmdline("?", search_sources)
-- Use cmdline & path source for ':'.
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline", keyword_length = 4 },
  }),
})
