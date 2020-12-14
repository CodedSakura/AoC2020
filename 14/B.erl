#!/usr/bin/env escript
-module('B').
-export([main/1]).

for_mask(0,_,Val) -> Val;
for_mask(N, Mask, Val) when N > 0 ->
  C = lists:nth(N, Mask),
  case C of
    $0 -> for_mask(N-1, Mask, Val);
    $1 -> for_mask(N-1, Mask, Val bor (1 bsl (N - 1)));
    $X -> for_mask(N-1, Mask, Val band (bnot (1 bsl (N - 1))))
  end.

mask_variations(Mask) -> mask_variations(Mask, 36, [0]).
mask_variations(_Mask, 0, Arr) -> Arr;
mask_variations(Mask, N, Arr) ->
  C = lists:nth(N, Mask),
  if
    C =:= $X ->
      mask_variations(Mask, N-1, Arr ++ [X bor (1 bsl (N - 1)) || X <- Arr]);
    true ->
      mask_variations(Mask, N-1, Arr)
  end.

apply_mask(Mask, Val) ->
  V = for_mask(36, Mask, Val),
  [V bor X || X <- mask_variations(Mask)].

put_values_at([], _Val, Mem) -> Mem;
put_values_at([P|Arr], Val, Mem) ->
  put_values_at(Arr, Val, maps:put(P, Val, Mem)).

loop(L) -> loop(L, 0, #{}, "").
loop([], _Acc, Mem, _Mask) -> Mem;
loop([V|T], Acc, Mem, Mask) ->
  A = string:split(V, " = "),
  A1 = lists:nth(1, A),
  A2 = lists:nth(2, A),
  C = string:find(A1, "mem"),
  if
    C =:= A1 ->
      Addr = list_to_integer(string:trim(A1, both, "mem[]")),
      loop(T, Acc+1, put_values_at(apply_mask(Mask, Addr), list_to_integer(A2), Mem), Mask);
    true ->
      loop(T, Acc+1, Mem, lists:reverse(A2))
  end.

main(_) ->
  {ok, Data} = file:read_file("input.txt"),
  A = [binary_to_list(X) || X <- binary:split(Data, [<<"\n">>], [global])],
  io:fwrite("~p~n", [lists:foldl(fun(X, Sum) -> X + Sum end, 0, maps:values(loop(lists:filter(fun (E) -> E /= [] end, A))))]).
