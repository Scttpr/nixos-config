{ pkgs, config, lib, ... }:
{
    programs = {
        neovim = {
            enable = true;
            defaultEditor = true;
            viAlias = true;
            vimAlias = true;
            vimdiffAlias = true;
            extraLuaConfig = ''
                vim.opt.number = true
                vim.opt.mouse = 'a'
                vim.opt.shiftwidth = 4
                vim.opt.tabstop = 4
                vim.opt.softtabstop = 4
                vim.opt.expandtab = true
            '';
        };
    };
}
