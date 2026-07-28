{ ... }:
{
  # Figuring out how to write and use this tmux wrapper took 1:30h
  # ouch
  flake.wrappers.hyprlock =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.hyprlock ];
    };
}
