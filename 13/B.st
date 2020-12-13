|inp timeTable res|
inp := (('input.txt' asFileReference contents lines) at: 2) splitOn: $,.
timeTable := inp reject: [:each | each = 'x'] thenCollect: [:i | i asNumber].
Transcript clear.

[ |lastI| lastI := 1.
    1 to: inp size
        do: [ :i | 
            (inp at: i) = 'x'
                ifFalse: [ | val | val := timeTable at: lastI.
                    timeTable at: lastI put: {val. (val - (i-1 rem: val) rem: val)}.
                    lastI := lastI + 1. ] ]] value.

res := (timeTable at: 1) at: 1.
[ |inc| inc := res.
    2 to: timeTable size
        do: [ :i | |val| val := timeTable at: i.
            [(res rem: (val at: 1)) ~= (val at: 2)] whileTrue: [ 
                res := res + inc.
            ].
            inc := inc * (val at: 1).
        ]] value.

Transcript show: res.
