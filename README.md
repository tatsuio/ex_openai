ExOpenAI
========

> OpenAI API client in Elixir

## DESCRIPTION

ExOpenAI is an Elixir client that wraps the [OpenAI API](https://beta.openai.com/).

## INSTALLATION

You can add ExOpenAI as a dependency in your `mix.exs` file.

```
defp deps do
  [{:ex_openai, "~> 0.0.1"}]
end
```

You can install that dependency by running:

```
$ mix deps.get
```

## USAGE

## Configuration

1. Get your API Key from https://beta.openai.com/docs/developer-quickstart/your-api-keys

2. You can add your API key to your environment variables using `OPENAI_API_KEY` and ExOpenAI will automatically use the API key specified in that environment variable.

```
$ export OPENAI_API_KEY=sk-xxxxx
```

Alternatively, you can specify the API key within your configuration:

```
# config/config.exs

config :ex_openai,
  api_key: {:system, "MY_API_KEY"}
```

## Completions

This is the main endpoint for the OpenAI API. It returns the predicted completion for the provided prompt.

The OpenAI documentation for this endpoint: https://beta.openai.com/docs/api-reference/create-completion

```
ExOpenAI.Completion.create(engine_id: :davinci, prompt: "Once upon a time")
```

## TESTING

You can run the tasks with the standard mix command:

```
$ mix test
```

## CONTRIBUTING

1. Clone the repository `git clone https://github.com/tatsuio/ex_openai`
1. Create a feature branch `git checkout -b my-awesome-feature`
1. Codez!
1. Commit your changes (small commits please)
1. Push your new branch `git push origin my-awesome-feature`
1. Create a pull request `gh pr create --base tatsuio:main --head tatsuio:my-awesome-feature`

## LICENSE

Copyright (c) 2020, Jamie Wright.

ExOpenAI source code is licensed under the [MIT License](LICENSE.md).
