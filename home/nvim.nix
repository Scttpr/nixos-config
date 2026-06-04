{ pkgs, ... }:

# Self-contained Neovim; per-project LSP servers come from direnv, not the closure.
{
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    withNodeJs = false;
    withRuby = false;
    withPython3 = false;

    extraPackages = with pkgs; [
      nixd
      lua-language-server
      nixfmt
      stylua
      fzf
      ripgrep
      fd
    ];

    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      nvim-lspconfig
      blink-cmp
      friendly-snippets
      fzf-lua
      mini-icons
      gitsigns-nvim
      lualine-nvim
      which-key-nvim
      mini-pairs
      oil-nvim
      conform-nvim
      vague-nvim
    ];

    initLua = ''
      vim.g.mapleader = " "
      vim.g.maplocalleader = " "
      local o = vim.opt
      o.number = true
      o.relativenumber = true
      o.mouse = "a"
      o.clipboard = "unnamedplus"
      o.expandtab = true
      o.shiftwidth = 2
      o.tabstop = 2
      o.smartindent = true
      o.ignorecase = true
      o.smartcase = true
      o.signcolumn = "yes"
      o.termguicolors = true
      o.undofile = true
      o.updatetime = 250
      o.timeoutlen = 400
      o.splitright = true
      o.splitbelow = true
      o.scrolloff = 6
      o.cursorline = true
      o.wrap = false

      vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")

      require("vague").setup({})
      vim.cmd.colorscheme("vague")

      -- nvim-treesitter `main` branch dropped the `.configs` API; use vim.treesitter.start.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          pcall(vim.treesitter.start, ev.buf)
        end,
      })

      require("blink.cmp").setup({
        keymap = { preset = "default" },
        sources = { default = { "lsp", "path", "snippets", "buffer" } },
        completion = { documentation = { auto_show = true } },
      })

      vim.diagnostic.config({
        virtual_text = true,
        severity_sort = true,
        float = { border = "rounded" },
      })

      local caps = require("blink.cmp").get_lsp_capabilities()
      vim.lsp.config("*", { capabilities = caps })
      vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } } } } })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local fzf = require("fzf-lua")
          local map = function(k, fn, desc)
            vim.keymap.set("n", k, fn, { buffer = ev.buf, desc = "LSP: " .. desc })
          end
          map("gd", vim.lsp.buf.definition, "definition")
          map("gr", fzf.lsp_references, "references")
          map("gi", vim.lsp.buf.implementation, "implementation")
          map("K", vim.lsp.buf.hover, "hover")
          map("<leader>rn", vim.lsp.buf.rename, "rename")
          map("<leader>ca", vim.lsp.buf.code_action, "code action")
          map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "prev diagnostic")
          map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "next diagnostic")
          map("<leader>e", vim.diagnostic.open_float, "line diagnostics")
        end,
      })

      vim.lsp.enable({
        "nixd", "lua_ls", "rust_analyzer", "pyright", "ruff",
        "clangd", "gopls", "ts_ls", "bashls",
      })

      local fzf = require("fzf-lua")
      fzf.setup({})
      vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "find files" })
      vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "live grep" })
      vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "buffers" })
      vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "help" })
      vim.keymap.set("n", "<leader>fd", fzf.diagnostics_document, { desc = "diagnostics" })

      require("mini.icons").setup()
      MiniIcons.mock_nvim_web_devicons()
      require("mini.pairs").setup()
      require("gitsigns").setup()
      require("lualine").setup({ options = { theme = "auto", globalstatus = true } })
      require("which-key").setup()
      require("oil").setup({ view_options = { show_hidden = true } })
      vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "parent dir (oil)" })

      require("conform").setup({
        formatters_by_ft = {
          nix = { "nixfmt" },
          lua = { "stylua" },
        },
      })
      vim.keymap.set({ "n", "v" }, "<leader>f", function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end, { desc = "format buffer" })
    '';
  };
}
