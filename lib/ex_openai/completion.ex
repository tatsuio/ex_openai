defmodule ExOpenAI.Completion do
  import ExOpenAI

  def create(engine_id, parameters \\ [], options \\ []) do
    post("engines/#{engine_id}/completions", parameters, options)
  end
end
