#!/usr/bin/env escript
-module('A').
-export([main/1]).

for(0,_,Val) -> Val;
for(N, Mask, Val) when N > 0 ->
  C = lists:nth(N, Mask),
  case C of
    $0 -> for(N-1, Mask, Val band (bnot (1 bsl (N - 1))));
    $1 -> for(N-1, Mask, Val bor (1 bsl (N - 1)));
    $X -> for(N-1, Mask, Val)
  end.

apply_mask(Mask, Val) ->
  for(36, Mask, Val).

loop(L) -> loop(L, 0, #{}, "").
loop([], _Acc, Mem, _Mask) -> Mem;
loop([V|T], Acc, Mem, Mask) ->
  A = string:split(V, " = "),
  A1 = lists:nth(1, A),
  A2 = lists:nth(2, A),
  C = string:find(A1, "mem"),
  if
    C =:= A1 -> % if begins with "mem"
      Addr = string:trim(A1, both, "mem[]"),
      loop(T, Acc+1, maps:put(Addr, apply_mask(Mask, list_to_integer(A2)), Mem), Mask);
    true -> % else
      loop(T, Acc+1, Mem, lists:reverse(A2))
  end.

main(_) ->
  {ok, Data} = file:read_file("input.txt"),
  A = [binary_to_list(X) || X <- binary:split(Data, [<<"\n">>], [global])],
  io:fwrite("~p~n", [lists:foldl(fun(X, Sum) -> X + Sum end, 0, maps:values(loop(lists:filter(fun (E) -> E /= [] end, A))))]).
