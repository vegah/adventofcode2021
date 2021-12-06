"Runs with GNU Smalltalk
This is the first time I have written smalltalk, and the first time I have looked at it.  
Enjoyed it, but the code probably is terrible - and some of it was to test collections etc.  Of course you could use just one array etc.
For Advent of code 2021 - Challenge: Use a different programming language each day"

Object subclass: Cell [
    | value iscrossed | 
    Cell class >> new: cellValue [
        | r |
        r := super new.
        r init: cellValue.
        ^r
    ]

    init: cellValue [
        value := cellValue.
        iscrossed := false.
    ]

    select: selectvalue [
        value = selectvalue ifTrue: [ iscrossed:= true]
    ]

    iscrossed [
        ^iscrossed.
    ]

    val [
        ^value.
    ]

]

Object subclass: CellCollection [
    | collections |
    CellCollection class >> new: size [
        | r | 
        r := super new.
        r init: size.
        ^r
    ] 

    init: size [
        collections := OrderedCollection new.
        1 to: size do:[:x | collections add: OrderedCollection new.] 
    ]

    add: cell x: x [
        | y |
        (collections at: x) add: cell.
    ]

    check [
        | cnt temp | 
        cnt := collections collect:[:x | (x select:[:c | c iscrossed ]) size].
        temp := cnt select:[:c | c=(collections size)].
        ^(temp size)>0.
    ]

    uncheckedSum [
        | unchecked sum |
        unchecked := collections gather:[:x | (x select:[:c | (c iscrossed)=false ])].
        sum := 0.
        unchecked do:[:x | sum := sum + (x val)].
        ^sum
    ]
]



Object subclass: Board [
    | rows cols cells |
  Board class >> new: boardstrings [
    | r |
    r := super new.
    r init: boardstrings.
    ^r
  ]

  

  init: boardstrings [
      | a width height |
      rows := OrderedCollection new.
      cols := OrderedCollection new.
      a := boardstrings gather:[:str | str subStrings: ' '  ].
      cells := a collect: [:val | Cell new: (val asNumber)].
      height := boardstrings size.
      width  := cells size / height.
      rows := CellCollection new: height.
      cols := CellCollection new: width.
      1 to: height do:[:x | 1 to: width do:[:y | cols add: (cells at: (y-1)*width+x) x:x ]].
      1 to: height do:[:x | 1 to: width do:[:y | rows add: (cells at: (y-1)*width+x) x:y ]].

  ]

  select: value [
      | temp | 
      temp := cells do:[:c | c select: value ] 

  ]

  check [
      | isbingo  |
      isbingo := rows check.
      isbingo := isbingo or: [cols check].
      ^isbingo.
  ]

  uncheckedSum [
      | ret | 
      ret :=rows uncheckedSum.
      ^ret
  ]

]

Object subclass: NumberPicker [
    | selectednumbers current | 
    NumberPicker class >> new: commaseparatedlist [
        | r  | 
        r := super new.
        r init: commaseparatedlist.
        ^r
        
    ]
 
    init: commaseparatedlist [
        selectednumbers := OrderedCollection new.
        (commaseparatedlist subStrings: ',') do:[:x | selectednumbers add: (x asNumber)].
        current := 1
    ]

    selectNext [
        | selected | 
        selected := selectednumbers at: current.
        current := current + 1.
        ^selected
    ]
]

Object subclass: BoardCollection [
    | boards |
    BoardCollection class >> new [
        | r | 
        r := super new.
        r init.
        ^r
    ]
    
    init [
        boards := OrderedCollection new.
    ]

    add: board [
        boards add: board 
    ]

    select: value [
        | check boardNo|
        boardNo := 1. 
        boards do: [:board| 
            board select: value.
            check := board check.
            check ifTrue: [
                ^boardNo
            ].
            boardNo := boardNo + 1.
        ].
        ^-1
    ]

    at: value [
        ^boards at: value.
    ]

]

cnt := 0.
boardlines := OrderedCollection new.
boards := BoardCollection new.

f := FileStream open: 'data.txt' mode: FileStream read.

f linesDo: [ :c | 
    c='' ifTrue: [
        boardlines size=0 ifFalse: [
            newboard := Board new: boardlines.
            boards add: newboard.
            boardlines empty.
        ].
    ].

    cnt=0 ifTrue: [
        numberpicker := NumberPicker new: c.        
    ]
    ifFalse: [
        c size = 0 ifFalse: [ boardlines add: c. ].
    ].
    cnt := cnt + 1. 
].

isBingo := false.
[isBingo] whileFalse: [
    next := numberpicker selectNext.
    bingoOnBoard := boards select: next.
    bingoOnBoard=-1 ifFalse: [
        isBingo := true.
        ' Bingo found on board : ' printNl.
        bingoOnBoard printNl.
        ' Last selected number : ' printNl.
        next printNl.
        uncheckedsum := (boards at: bingoOnBoard) uncheckedSum.
        ' SUm of all unchecked numbers ' printNl.
        uncheckedsum printNl.
        finalAnswer := uncheckedsum * next.
        finalAnswer printNl.
    ]
]