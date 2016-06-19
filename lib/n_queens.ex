defmodule NQueens do
  @typedoc """
  A `branch_state` represents the state for a branch of our N-Queens calculation.
  It is represented as a 2-tuple containing:

  - n
  - positions

  Where `positions` is a list of type `position`.
  """
  @type branch_state ::
  {non_neg_integer, list(position)}

  @typedoc """
  A `position` is a 2-tuple representing a row, column pair.
  """
  @type position ::
  {non_neg_integer, non_neg_integer}

  @typedoc """
  A `solution` is a list of `position`.  This is what our `solve` function will
  return.
  """
  @type solution ::
  list(position)

  @typedoc """
  A `board` is a list of lists of strings that represents an NxN game board, which
  will be used to show queen placements and open versus unusable spaces.  This is
  not used for calculations, and is entirely meant for display purposes.
  """
  @type board ::
  list(list(String.t))

  @spec solve(non_neg_integer) :: list(solution)
  def solve(n) when is_integer(n) and n >= 0 do
    [
      [{0, 0}]
    ]
  end

  @spec render(non_neg_integer, solution) :: board
  def render(n, solution) when is_list(solution) and n >= 0 do
    for y <- (0..n-1) do
      for x <- (0..n-1) do
        case solution |> Enum.member?({x,y}) do
          true -> "Q"
          false -> " "
        end
      end
    end
  end
end
