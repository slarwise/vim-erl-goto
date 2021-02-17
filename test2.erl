-module(test2).

-type(result() :: success |
      fail
     ).
-opaque(msg() :: hej).

add(X, Y) ->
    X + Y,
    another_line,
    lists:foreach(
      fun(X)
          io:format("~n", [X])
      end,
      [a, b, c]
     ),
    ok.
