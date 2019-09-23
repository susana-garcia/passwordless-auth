defmodule PasswordlessAuth.Scheduler do
  @moduledoc false
  use Quantum.Scheduler, otp_app: :passwordless_auth
end
