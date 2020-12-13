|inp early timeTable res|
inp := 'input.txt' asFileReference contents lines.
early := (inp at: 1) asNumber.
timeTable := (((inp at: 2) splitOn: $,) reject: [:each | each = 'x']) collect: [:i | i asNumber].
res := timeTable collect: [ :i | i - (early rem: i) ].

Transcript 
    open;
    clear;
    show: ((timeTable at: (res indexOf: res min)) * (res min)).
    