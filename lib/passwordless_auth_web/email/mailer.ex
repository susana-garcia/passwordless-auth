defmodule PasswordlessAuthWeb.Mailer do
  @moduledoc """
  Mailgun client
  """
  use Swoosh.Mailer, otp_app: :passwordless_auth
  use Phoenix.Swoosh, view: PasswordlessAuthWeb.EmailView, layout: {PasswordlessAuthWeb.LayoutView, :email}
  import Swoosh.Email
  import PasswordlessAuthWeb.Gettext

  def login(%{user: user, link: link}) do
    new()
    |> to({user.name, user.email})
    |> from(from_email_address())
    |> subject(dgettext("email", "Login Verification"))
    |> render_body(:login, %{
      username: user.name,
      login_link: link
    })
  end

  defp from_email_address,
    do: :passwordless_auth |> Application.fetch_env!(__MODULE__) |> Keyword.fetch!(:from_address)
end
