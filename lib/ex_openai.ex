defmodule ExOpenAI do
  use HTTPoison.Base

  @moduledoc """
  An Elixir client for the OpenAI API.

  The OpenAI API lets developers use new AI technologies from OpenAI,
  integrating them into products and services. The API is general-purpose
  and can be tried on virtually any natural language task, and its success
  is roughly correlated with how complex the task is.

  Each module corresponds to each major area of the API.

  ## Authentication

  Each request is authenticated with an `api_key` which is sent to
  the OpenAI API in the form of an `Authorization` header.

  The `api_key`can be specified in one of three ways.

  1. The `api_key` can be specified in an environment variable called
     `OPENAI_API_KEY`.

  2. The `api_key` can be specified via the config. This will override the
     environment variable.

  ```
  # config/config.exs

  config :ex_openai, api_key: {:system, "sk-myapikey"}
  ```

  3. The `api_key` can be specified on a per request basis in the
  `options` parameter with an `api_key` key.

  ```
  result = ExOpenAI.Completion.create(:davinci, [], [api_key: "sk-yourapikey"])
  ```

  ## Responses

  Responses from each request are returned with an `:ok` or `:error` tuple. If
  the response contains an error, then a tuple with an `:error` key is returned.
  An error is returned even in the response is successful but it has an error in the
  body.

  ```
  {:error, response} = ExOpenAI.Completion.create(:davinci)
  ```

  If the response is successful, an `:ok` keyed tuple is returned.

  ```
  {:ok, response} = ExOpenAI.Completion.create(:davinci)
  ```
  """

  @base_url "https://api.openai.com/"
  @version "v1"
  @user_agent [{"User-agent", "ex_openai"}]

  @doc """
  Makes a `POST` request to the OpenAI API.

  Returns the wrapped response with either an `ok` or `error` tuple along
  with the `HTTPoison.Response` as the second element in the tuple.

  parameters: A `Keyword` list of parameters that will be passed with the
              request body as json.

  options:
  * `api_key` - A binary API key to be used for this request. This will
    override any API key specified in the config or as an environment variable.
  """
  def post(url, parameters, options \\ []) do
    {api_key, opts} = Keyword.pop(options, :api_key, system_api_key())

    make_request(
      :post,
      url(url),
      body(parameters),
      default_headers() ++ [authorization_header(api_key)],
      opts
    )
  end

  @doc false
  def process_response_body(""), do: nil

  @doc false
  def process_response_body(body), do: Jason.decode!(body)

  defp authorization_header(api_key) do
    {"Authorization", "Bearer #{api_key}"}
  end

  defp base_url do
    URI.merge(@base_url, @version) |> to_string()
  end

  defp body(parameters) do
    Jason.encode!(Enum.into(parameters, %{}))
  end

  defp default_headers do
    [{"Content-Type", "application/json"}] ++ @user_agent
  end

  defp make_request(method, url, body, headers, options) do
    method
    |> request!(url, body, headers, options)
    |> process_response
    |> wrap_response
  end

  defp system_api_key do
    Application.get_env(:ex_openai, :api_key)
  end

  defp url("/" <> _path = full_path), do: base_url() <> full_path
  defp url(path), do: url("/#{path}")

  defp wrap_response(%HTTPoison.Response{body: %{"error" => _error}} = response) do
    {:error, response}
  end

  defp wrap_response(response) do
    {:ok, response}
  end
end
