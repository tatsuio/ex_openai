defmodule ExOpenAI.Completion do
  import ExOpenAI

  @moduledoc """
  All of the OpenAI API Completion endpoints.
  """

  @doc """
  The `POST /completions` endpoint for the OpenAI API.

  Returns the wrapped response with either an `ok` or `error` tuple along
  with the `HTTPoison.Response` as the second element in the tuple.

  engine_id: The ID of the engine (i.e. davinci, babbage) to use for this request.

  parameters: A `Keyword` list of parameters that will be passed with the
              request body as json.
  * `prompt` - The prompt(s) to generate completions for, encoded as a string,
    a list of strings, or a list of token lists.
  * `max_tokens` - The maximum number of tokens to generate. Requests can use up to 2048 tokens shared between
    prompt and completion. (One token is roughly 4 characters for normal English text)
  * `temperature` - What sampling temperature to use.
  * `top_p` - An alternative to sampling with temperature, called nucleus sampling, where the model
     considers the results of the tokens with top_p probability mass.
  * `n` - How many completions to generate for each prompt.
  * `stream` - Whether to stream back partial progress.
  * `logprobs` - Include the log probabilities on the logprobs most likely tokens, as well the chosen tokens.
  * `echo` - Echo back the prompt in addition to the completion
  * `stop` - Up to 4 sequences where the API will stop generating further tokens. The returned text will not
    contain the stop sequence.
  * `presence_penalty` - Number between 0 and 1 that penalizes new tokens based on whether they appear in the text so far.
  * `frequency_penalty` - Number between 0 and 1 that penalizes new tokens based on their existing frequency in the text so far.
  * `best_of` - Generates best_of completions server-side and returns the "best" (the one with the lowest log probability per token).
  * `logit_bias` - Modify the likelihood of specified tokens appearing in the completion.

  options:
  * `api_key` - A binary API key to be used for this request. This will
    override any API key specified in the config or as an environment variable.

  ## Examples

  ```
  {:ok, response} = ExOpenAI.Completion.create(:davinci)

  {:error, response} = ExOpenAI.Completion.create(:blah)
  ```
  """
  def create(engine_id, parameters \\ [], options \\ []) do
    post("engines/#{engine_id}/completions", parameters, options)
  end
end
