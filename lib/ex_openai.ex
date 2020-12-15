defmodule ExOpenAI do
  use HTTPoison.Base

  @base_url "https://api.openai.com/"
  @version "v1"

  @moduledoc """
  Documentation for `ExOpenAI`.
  """

  def post(url, parameters, options \\ []) do
    make_request(:post, url(url), parameters, [], options)
  end

  def process_response_body(""), do: nil
  def process_response_body(body), do: Jason.decode!(body)

  defp base_url do
    URI.merge(@base_url, @version) |> to_string()
  end

  defp url("/" <> _path = full_path), do: base_url() <> full_path
  defp url(path), do: url("/#{path}")

  defp make_request(method, url, body, headers, options) do
    method
    |> request!(url, body, headers, options)
    |> process_response
    |> wrap_response
  end

  defp wrap_response(%HTTPoison.Response{body: %{"error" => _error}} = response) do
    {:error, response}
  end

  defp wrap_response(response) do
    {:ok, response}
  end
end
