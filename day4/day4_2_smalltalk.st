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
        | unchecked sum uncheckedVals|
        unchecked := collections gather:[:x | (x select:[:c | (c iscrossed)=false ])].
        uncheckedVals := unchecked collect: [:x | x val].
        uncheckedVals printNl.
        sum := 0.
        unchecked do:[:x | sum := sum + (x val)].
        ^sum
    ]
]



Object subclass: Board [
    | rows cols cells hasBingo |
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
      hasBingo := false.
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
      hasBingo := isbingo.
      ^isbingo.
  ]

  hasBingo [
      ^hasBingo
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
    | boards lastBingoBoard |
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
        | check boardNo numberOfBingos|
        boardNo := 1. 
        numberOfBingos := 0.
        boards  do: [:board| 
            board select: value.
            board hasBingo ifFalse: [
                check := board check.
                check ifTrue: [
                    numberOfBingos := numberOfBingos +1.
                    lastBingoBoard := boardNo.
                ].
            ].
            boardNo := boardNo + 1.
        ].
        ^numberOfBingos
    ]

    at: value [
        ^boards at: value.
    ]

    size [
        ^(boards size)
    ]

    last [
        ^lastBingoBoard
    ]

]

cnt := 0.
boardlines := OrderedCollection new.
boards := BoardCollection new.

f := FileStream open: 'realdata.txt' mode: FileStream read.

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

numberOfBingos := 0.
[numberOfBingos=(boards size)] whileFalse: [
    next := numberpicker selectNext.
    numberOfNewBingos := boards select: next.
    numberOfBingos := numberOfBingos + numberOfNewBingos.
    numberOfBingos=(boards size) ifTrue: [
        isBingo := true.
        ' Number of bingos found : ' printNl.
        numberOfBingos printNl.
        boards size printNl.
        ' Last selected number : ' printNl.
        next printNl.
        'Last bingo is on board ' printNl.
        boards last printNl.
        uncheckedsum := (boards at: boards last ) uncheckedSum.
        ' SUm of all unchecked numbers ' printNl.
        uncheckedsum printNl.
        finalAnswer := uncheckedsum * next.
        finalAnswer printNl.
    ]
]