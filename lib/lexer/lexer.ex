defmodule GraphQL.Lexer do

  @doc """
  Get a generator function to get the next source token from `source`.
  """
  def lex source do
    prevPosition = 0

    fn source ->
      token = read_token(
        source,
        prevPosition
      )

      prevPosition = token.end
      
      token
    end
  end
  
  @doc """
  Read the token at `position` in `source`.
  """
  defp read_token source, position do
    body = source.body
    body_length = String.length body

    position = position_after_whitespace body, position
    code = String.at body, position

    {token_kind, end_position, value} = case code do
      # handle invalid characters
      x when (x < 0x0020 and x != 0x0009 and x != 0x000A and x != 0x000D) ->
        raise "syntax error: #{source}, #{position}, invalid 
          character #{to_string x}"

      # handle end-of-string
      nil ->
        {:eof, position, nil}

      # handle names
      x when x == "_" or (x >= 65 and x <= 90) or (x >= 97 and x <= 122) ->
        read_name source, position

      # handle numbers
      x when x == "-" or (x >= 48 and x <= 57) ->
        read_number source, position

      # handle strings
      "\"" ->
        read_string source, position

      # handle punctuation characters
      "!" ->
        {:bang, position + 1, nil}
      "$" ->
        {:dollar, position + 1, nil}
      "(" ->
        {:paren_l, position + 1, nil}
      ")" ->
        {:paren_r, position + 1, nil}
      "." ->
        if (
          String.at(body, position + 1) == "." and
          String.at(body, position + 2) == "."
        ) do
          {:spread, position + 3, nil}
        else
          nil
        end
      ":" ->
        {:colon, position + 1, nil}
      "=" ->
        {:equals, position + 1, nil}
      "@" ->
        {:at, position + 1, nil}
      "[" ->
        {:bracket_l, position + 1, nil}
      "]" ->
        {:bracket_r, position + 1, nil}
      "{" ->
        {:brace_l, position + 1, nil}
      "|" ->
        {:pipe, position + 1, nil}
      "}" ->
        {:brace_r, position + 1, nil}

      x ->
        raise "syntax error: #{source}, #{position}, unexpected character
          #{to_string x}"
    end

    %{
      kind: token_kind,
      start_pos: position,
      end_pos: end_position,
      value: value
    }
  end

  @doc """
  Skip all whitespace after `position` in `str` and return the new position.
  """
  defp position_after_whitespace str, position do
    raise "no impl"
  end

  @doc """
  Read a name from `source` starting from `position`.
  Return `{:name, <end position>, <name as string>}`.
  """
  defp read_name source, position do
    raise "no impl"
  end

  @doc """
  Read a number from `source` starting at `position`.
  Return `{<:int or :float>, <end position>, <value of number>}`.
  """
  defp read_number source, position do
    raise "no impl"
  end

  @doc """
  Read a string from `source` starting from `position.
  Return `{:string, <end position>, <value of string}`.
  """
  defp read_string source, position do
    raise "no impl"
  end

end

