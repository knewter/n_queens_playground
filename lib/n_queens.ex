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

  @doc """
  `solve` takes an N and returns a list of solutions for that N-Queens problem.
  The solutions take the form `{non_neg_integer, non_neg_integer}`, which is
  the same as type `position`.
  """
  @spec solve(non_neg_integer) :: list(solution)
  def solve(n) when is_integer(n) and n >= 0 do
    do_solve({n, []})
      |> Enum.filter(fn val -> val != [] end)
      |> Enum.map(&Enum.sort/1)
      |> Enum.uniq
  end

  @spec do_solve(branch_state) :: list(solution)
  def do_solve({n, positions}) when is_integer(n) and n >= 0 and is_list(positions) and length(positions) == n do
    [positions]
  end
  def do_solve({n, positions}) when is_integer(n) and n >= 0 and is_list(positions) do
    possible_positions(n, positions)
      |> Enum.flat_map(fn {x, y} ->
        do_solve({n, [{x, y} | positions]})
      end)
      |> Enum.filter(fn val -> val != [] end)
  end

  @spec render(non_neg_integer, solution) :: board
  def render(n, solution) when is_list(solution) and is_integer(n) and n >= 0 do
    for y <- (0..n-1) do
      for x <- (0..n-1) do
        case solution |> Enum.member?({x,y}) do
          true -> "Q"
          false -> "0"
        end
      end
    end
  end

  @spec possible_positions(non_neg_integer) :: list(position)
  def possible_positions(n) when is_integer(n) and n >= 0 do
    for y <- (0..n-1),
        x <- (0..n-1),
        do: {x, y}
  end

  @spec possible_positions(non_neg_integer, list(position)) :: list(position)
  def possible_positions(n, used_positions) when is_integer(n) and n >= 0 do
    blocked_positions = blocked_positions(n, used_positions)
    for y <- (0..n-1),
        x <- (0..n-1),
        !Enum.member?(blocked_positions, {x, y}),
        do: {x, y}
  end

  @spec blocked_positions(non_neg_integer, list(position)) :: list(position)
  def blocked_positions(n, used_positions) when is_integer(n) and n >= 0 and is_list(used_positions) do
    used_positions
    |> Enum.flat_map(&blocked_positions_for_position(n, &1))
    |> Enum.uniq
  end

  @spec blocked_positions_for_position(non_neg_integer, position) :: list(position)
  def blocked_positions_for_position(n, position={_x, _y}) when is_integer(n) and n >= 0 do
    (
      row_for(n, position) ++
      column_for(n, position) ++
      diagonal_for(n, position)
    ) |> Enum.uniq
  end

  @spec row_for(non_neg_integer, position) :: list(position)
  def row_for(n, {_, y}) when is_integer(n) and n >= 0 and is_integer(y) and y >= 0 do
    for x <- (0..n-1),
        do: {x, y}
  end

  @spec column_for(non_neg_integer, position) :: list(position)
  def column_for(n, {x, _}) when is_integer(n) and n >= 0 and is_integer(x) and x >= 0 do
    for y <- (0..n-1),
        do: {x, y}
  end

  @spec diagonal_for(non_neg_integer, position) :: list(position)
  def diagonal_for(n, {x, y}) when is_integer(n) and n >= 0 and is_integer(x) and x >= 0 and is_integer(y) and y >= 0 do
    for {px, py} <- possible_positions(n),
        abs(x-px) == abs(y-py),
        do: {px, py}
  end
end
