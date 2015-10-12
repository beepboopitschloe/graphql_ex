defmodule GraphQL.LexerTest do
  use ExUnit.Case

  alias GraphQL.Lexer

  test "returns a function which returns tokens" do
    source = %{
      body: "
      :
      foo
      |
      # this is a comment and should be skipped
      bar
      ",
      name: "Test Query"
    }

    lexer = Lexer.lex source

    %{ kind: kind, value: value, end_pos: position } = lexer.(0)
    assert kind == :colon
    assert value == nil

    %{ kind: kind, value: value, end_pos: position } = lexer.(position)
    assert kind == :name
    assert value == "foo"

    assert %{ kind: kind, value: value, end_pos: position } = lexer.(position)
    assert kind == :pipe
    assert value == nil

    assert %{ kind: kind, value: value, end_pos: position } = lexer.(position)
    assert kind == :name
    assert value == "bar"
  end

end

