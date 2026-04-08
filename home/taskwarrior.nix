{ pkgs, ... }:

{
  programs.taskwarrior = {
    enable = true;
    package = pkgs.taskwarrior3;
    config = {
      weekstart = "Monday";
      default.command = "next";
      include = "no-color.theme";

      color.active = "white";
      color.overdue = "rgb510";
      "color.due" = "rgb530";
      "color.due.today" = "rgb530 bold";
      color.tagged = "rgb444";
      color.blocked = "rgb333";
      color.blocking = "white bold";
      color.recurring = "rgb444";
      color.completed = "rgb333";
      color.deleted = "rgb333";
      "color.uda.priority.H" = "white bold";
      "color.uda.priority.M" = "white";
      "color.uda.priority.L" = "rgb444";

      # Domain UDA
      "uda.domain.type" = "string";
      "uda.domain.label" = "Domain";
      "uda.domain.values" = "governance,identity,infra,appsec,detection,people,strategy";

      # Epic UDA
      "uda.epic.type" = "string";
      "uda.epic.label" = "Epic";

      # Epic priority UDA
      "uda.epic_priority.type" = "string";
      "uda.epic_priority.label" = "Epic Priority";
      "uda.epic_priority.values" = "H,M,L";
      "urgency.uda.epic_priority.H.coefficient" = 6;
      "urgency.uda.epic_priority.M.coefficient" = 3;
      "urgency.uda.epic_priority.L.coefficient" = 1;
    };
  };
}
