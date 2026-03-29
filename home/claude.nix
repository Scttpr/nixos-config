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
      PostToolUse = [
        {
          matcher = "Write|Edit";
          hooks = [
            {
              type = "command";
              command = "jq -r '.tool_input.file_path // .tool_response.filePath' | { read -r f; case \"$f\" in *.nix) nix flake check --no-build 2>&1 | head -20 ;; esac; } || true";
              timeout = 30;
              statusMessage = "Checking nix flake...";
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
