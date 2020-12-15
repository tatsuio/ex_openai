defmodule ExOpenAI do
  use HTTPoison.Base

  @moduledoc """
  Documentation for `ExOpenAI`.
  """

  @base_url "https://api.openai.com/"
  @version "v1"
  @user_agent [{"User-agent", "ex_openai"}]

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

  def process_response_body(""), do: nil
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
