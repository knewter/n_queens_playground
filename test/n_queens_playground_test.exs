defmodule NQueensPlaygroundTest do
  use ExUnit.Case
  import NQueens

  test "1-queens includes a known solution" do
    solution =
      [
        ~w(Q)
      ]

    result = solve(1) |> Enum.map(&render(1, &1))

    assert Enum.member?(result, solution)
  end

  test "4-queens includes a known solution" do
    # We encode our solution as "0" for an empty board space, and "Q" for a space containing a Queen.
    solution =
      [
        ~w(0 0 Q 0),
        ~w(Q 0 0 0),
        ~w(0 0 0 Q),
        ~w(0 Q 0 0)
      ]

    # Ask our module to solve the 4-Queens problem.
    result = solve(4) |> Enum.map(&render(4, &1))

    # Assert that our known-good solution is one of the solutions returned.
    assert Enum.member?(result, solution)
  end
end
