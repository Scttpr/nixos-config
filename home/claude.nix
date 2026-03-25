{ ... }:

{
  home.file.".claude/settings.json".text = builtins.toJSON {
    hooks = {
      PreToolUse = [
        {
          matcher = "Bash";
          hooks = [
            {
              type = "command";
              command = "/home/scttpr/.claude/hooks/rtk-rewrite.sh";
            }
          ];
        }
      ];
    };
    permissions = {
      allow = [
        "Read"
        "Edit"
        "Bash(git status *)"
        "Bash(git diff *)"
        "Bash(git log *)"
        "Bash(git add *)"
        "Bash(git commit *)"
        "Bash(git branch *)"
        "Bash(git checkout *)"
        "Bash(git switch *)"
        "Bash(git stash *)"
        "Bash(git merge *)"
        "Bash(git rebase *)"
        "Bash(nix *)"
        "Bash(nix-shell *)"
        "Bash(nixos-rebuild *)"
        "Bash(rtk *)"
        "Bash(ls *)"
        "Bash(cargo build *)"
        "Bash(cargo test *)"
        "Bash(cargo check *)"
        "Bash(cargo clippy *)"
        "Bash(npm run *)"
        "Bash(npm test *)"
        "Bash(npm install *)"
        "WebFetch(domain:github.com)"
        "WebFetch(domain:raw.githubusercontent.com)"
      ];
      deny = [
        "Bash(git push --force *)"
        "Bash(git reset --hard *)"
        "Bash(git clean -f *)"
        "Bash(rm -rf *)"
        "Bash(chmod 777 *)"
        "Bash(curl * | sh)"
        "Bash(curl * | bash)"
        "Bash(wget * | sh)"
        "Bash(eval *)"
      ];
    };
    attribution = {
      enabled = false;
    };
  };

  home.file.".claude/CLAUDE.md".source = ./claude/CLAUDE.md;
  home.file.".claude/RTK.md".source = ./claude/RTK.md;
}
