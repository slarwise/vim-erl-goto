-define(PI,
        3.14).
-record(hej, {}).
-type(integer(), non_neg_integer()).
-opaque(float(), non_neg_float()).

main() ->
    4 = hej 1XEnd,
    X = 3,
    3 = MyVar,
    ?PI,
    lists:member(X, [1, 2, 3]),
    X,
    MyVar,
    main(),
    integer(),
    test2:add(1, 3),
    test2:result(),
    test2:msg(),
    #hej{}.
