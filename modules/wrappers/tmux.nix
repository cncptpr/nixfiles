{ ... }:
{
  # Figuring out how to write and use this tmux wrapper took 1:30h
  # ouch
  flake.wrappers.tmux =
    { wlib, ... }:
    {
      imports = [ wlib.wrapperModules.tmux ];
      modeKeys = "vi";
      statusKeys = "vi";
      vimVisualKeys = true;
    };
}
