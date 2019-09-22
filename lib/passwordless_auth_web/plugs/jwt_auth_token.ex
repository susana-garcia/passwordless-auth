defmodule PasswordlessAuthWeb.Plug.JwtAuthToken do
  @moduledoc """
  Jwt Token
  """

  use Joken.Config

  # 30 days
  @exp_time 30 * 24 * 60 * 60

  def token_config, do: default_claims(default_exp: @exp_time)

  def get_exp_time, do: @exp_time
end
