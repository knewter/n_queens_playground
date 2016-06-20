defmodule NQueens do
  @moduledoc """
  `NQueens` is a module that encapsulates an algorithm to solve the [N-Queens
  Problem](https://developers.google.com/optimization/puzzles/queens).

  Its only important public function is `solve/1` but I've left the rest
  exported for playing with in the REPL.
  """


  @typedoc """
  A `branch_state` represents the state for a branch of our N-Queens calculation.
  It is represented as a 2-tuple containing:

  - `n`
  - `positions`

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
  A `board` is a list of lists of strings that represents an `NxN` game board, which
  will be used to show queen placements and open versus unusable spaces.  This is
  not used for calculations, and is entirely meant for display purposes.
  """
  @type board ::
  list(list(String.t))

  @doc """
  `solve/1` takes an N and returns a list of solutions for that N-Queens problem.
  The solutions take the form `{non_neg_integer, non_neg_integer}`, which is
  the same as type `position`.

      iex> NQueens.solve(4)
      [[{0, 2}, {1, 0}, {2, 3}, {3, 1}], [{0, 1}, {1, 3}, {2, 0}, {3, 2}]]

  """
  @spec solve(non_neg_integer) :: list(solution)
  def solve(n) when is_integer(n) and n >= 0 do
    do_solve({n, []})
      |> Enum.filter(fn val -> val != [] end)
      |> Enum.map(&Enum.sort/1)
      |> Enum.uniq
  end

  @doc false
  @spec do_solve(branch_state) :: list(solution)
  def do_solve({n, positions}) when is_integer(n) and n >= 0 and length(positions) == n do
    [positions]
  end
  def do_solve({n, positions}) when is_integer(n) and n >= 0 and is_list(positions) do
    possible_positions(n, positions)
      |> Enum.flat_map(fn {x, y} ->
        do_solve({n, [{x, y} | positions]})
      end)
      |> Enum.filter(fn val -> val != [] end)
  end

  @doc """
  `render/2` returns a 2-dimensional list of size `n` in each dimension, showing
  a `Q` in each position that is present in the solution, and an `0` in each
  position that is not present in the solution.
  """
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

  @doc """
  `possible_positions/1` returns all possible positions in an `NxN` grid.
  """
  @spec possible_positions(non_neg_integer) :: list(position)
  def possible_positions(n) when is_integer(n) and n >= 0 do
    for y <- (0..n-1),
        x <- (0..n-1),
        do: {x, y}
  end

  @doc """
  `possible_positions/2` returns all possible positions to place a queen,
  omitting those positions that are blocked by any of the currently placed
  queens.
  """
  @spec possible_positions(non_neg_integer, list(position)) :: list(position)
  def possible_positions(n, used_positions) when is_integer(n) and n >= 0 do
    blocked_positions = blocked_positions(n, used_positions)
    for y <- (0..n-1),
        x <- (0..n-1),
        !Enum.member?(blocked_positions, {x, y}),
        do: {x, y}
  end

  @doc """
  `blocked_positions/2` will return a list of those positions that are blocked
  on the board, given a list of queen placements.
  """
  @spec blocked_positions(non_neg_integer, list(position)) :: list(position)
  def blocked_positions(n, used_positions) when is_integer(n) and n >= 0 and is_list(used_positions) do
    used_positions
    |> Enum.flat_map(&blocked_positions_for_position(n, &1))
    |> Enum.uniq
  end

  @doc """
  `blocked_positions_for_position/2` returns those positions that are
  unavailable due to a queen being placed in the given position.
  """
  @spec blocked_positions_for_position(non_neg_integer, position) :: list(position)
  def blocked_positions_for_position(n, position={_x, _y}) when is_integer(n) and n >= 0 do
    (
      row_for(n, position) ++
      column_for(n, position) ++
      diagonal_for(n, position)
    ) |> Enum.uniq
  end

  @doc """
  Given a position for queen placement, `row_for/2` returns all the positions
  that would be unavailable for placement because they are on the queen's row.
  """
  @spec row_for(non_neg_integer, position) :: list(position)
  def row_for(n, {_, y}) when is_integer(n) and n >= 0 and is_integer(y) and y >= 0 do
    for x <- (0..n-1),
        do: {x, y}
  end

  @doc """
  Given a position for queen placement, `column_for/2` returns all the positions
  that would be unavailable for placement because they are on the queen's column.
  """
  @spec column_for(non_neg_integer, position) :: list(position)
  def column_for(n, {x, _}) when is_integer(n) and n >= 0 and is_integer(x) and x >= 0 do
    for y <- (0..n-1),
        do: {x, y}
  end

  @doc """
  Given a position for queen placement, `diagonal_for/2` returns all the positions
  that would be unavailable for placement because they are on a diagonal with the
  queen.
  """
  @spec diagonal_for(non_neg_integer, position) :: list(position)
  def diagonal_for(n, {x, y}) when is_integer(n) and n >= 0 and is_integer(x) and x >= 0 and is_integer(y) and y >= 0 do
    for {px, py} <- possible_positions(n),
        abs(x-px) == abs(y-py),
        do: {px, py}
  end
end
