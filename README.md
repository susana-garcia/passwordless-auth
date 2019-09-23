# Passwordless Auth API

To start the Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Start Phoenix endpoint with `mix phx.server`

This is a basic project to create a passwordless auth API using GraphQL, Phoenix and Swoosh (for emails). The API provides these mutations:

* Sign up:
    * Expects only a valid email.
    * The resolver will create a user and send an email with a magic link.
* Confirm Auth:
    * Expects email and token.
    * The resolver will validate the email and token and send back a JWT authentication token.
* Login:
    * Expects a registered user’s email.
    * The resolver will create a user and send an email with a magic link (same as in sign up).
* Update User:
    * Expects a name as param and a HTTP header with the auth token retrieved in 'Confirm Auth' mutation.

Configuration:
* Joken is used to generate a valid JWT token. You can generate your own `default_signer` running in the terminal `mix phx.gen.secret`. For more information, please check: [https://hexdocs.pm/joken/introduction.html#usage](https://hexdocs.pm/joken/introduction.html#usage)
* Swoosh is used to send the emails and in this example we use Mailgun (you can use another service just changing the adapter in the config). You just need to provide your own domain and API key. For more information, please check: [https://hexdocs.pm/swoosh/Swoosh.html#module-adapters](https://hexdocs.pm/swoosh/Swoosh.html#module-adapters)

Schedule task:
* There is a schedule task to delete old tokens (in this example, we delete the ones older than two hours, but you can change it in the configuration `max_age_auth_token_in_seconds`).
* The schedule task runs daily, but this can be changed as well, changing the value of the jobs in `PasswordlessAuth.Scheduler` in the configuration.

To try the API, run the server and then go to the GraphQL Playground: `http://localhost:4000/graphiql`

First add:

```
mutation {
  signUp (email:”your@email.com”) {
    email
  }
}
```

Then go to: `http://localhost:4000/dev/mailbox`

If everything goes well, you will see the email sent and you can copy the token of the link as a param.

Then go back to the GraphQL Playground and add a new mutation:

```
  mutation confirmAuth($input: ConfirmAuthInput!) {
    confirmAuth(input: $input) {
      authToken
      user {
        email
      }
    }
  }
```

With query variables:

```
{ "input":
  {
    "email": "your@email.com",
    "token": “COPIED-TOKEN-FROM-THE-SIGNUP”
  }
}
```

You should receive a valid JWT authentication token that you need to use in the next call.

Last but not least, try this mutation to update the user name:

```
mutation UpdateUser($input: Input!) {
  updateUser(input: $input) {
    name
  }
}
```

With query variables:

```
{"input":
  {
    "name": “your-name”
  }
}
```

And HTTP headers:

`authorization`: `Bearer AUTH-TOKEN-FROM-PREVIOUS-RESPONSE`

And that's it.

Happy coding!