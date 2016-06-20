# N-Queens Playground

This was just a bit of fun for me to solve the
[N-Queens Problem](https://developers.google.com/optimization/puzzles/queens) in
a decidedly functional style, and to use dialyzer to drive types as I went along
my merry way.

## Example

To solve the N-Queens Problem for N=4:

```elixir
NQueens.solve(4)
```

## Tests

To run the tests:

```sh
mix test
```

## Docs

To generate the docs:

```sh
mix docs
```
