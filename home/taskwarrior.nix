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
    };
  };
}
