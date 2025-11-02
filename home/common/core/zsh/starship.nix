{ ... }:
{
  add_newline = false;
  line_break = {
    disabled = true;
  };
  character = {
    disabled = true;
  };
  package = {
    disabled = true;
  };
  battery = {
    full_symbol = "🔋 ";
    charging_symbol = "⚡️ ";
    discharging_symbol = "💀 ";
    display = [
      {
        threshold = 10;
        style = "bold red";
      }
    ];
  };
  kubernetes = {
    style = "dimmed green";
    disabled = false;
  };
  elixir = {
    symbol = "🔮 ";
  };
}
