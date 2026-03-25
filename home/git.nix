{ ... }:

{
  programs.git = {
    enable = true;
    signing = {
      key = "~/.ssh/github.pub";
      signByDefault = true;
      format = "ssh";
    };
    settings = {
      user.name = "scttpr";
      user.email = "git.reformer354@passmail.net";
      init.defaultBranch = "main";
      pull.rebase = true;
      tag.gpgsign = true;
    };
  };
}
