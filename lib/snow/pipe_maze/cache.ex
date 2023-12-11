defmodule Snow.PipeMaze.Cache do
  use Nebulex.Cache,
    otp_app: :snow,
    adapter: Nebulex.Adapters.Local
end
