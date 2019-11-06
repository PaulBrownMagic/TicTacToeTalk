:- encoding('UTF-8').

:- object(board(_Board_)).

    :- info([ version is 1.0
            , author is 'Paul Brown'
            , date is 2019/10/22
            , comment is 'The TicTacToe game board'
            , parnames is ['Board']
            ]).

    :- public(init/0).
    :- mode(init, zero_or_more).
    :- info(init/0,
        [ comment is 'Initialize a new board'
        ]).
    init :-
        % Use numbers for easy human and machine navigation
        _Board_ = [ [1, 2, 3]
                  , [4, 5, 6]
                  , [7, 8, 9]
                  ].

    :- public(available_move/1).
    :- mode(available_move(+integer), zero_or_one).
    :- mode(available_move(-integer), zero_or_more).
    :- info(available_move/1,
        [ comment is 'The number is available for a move to be played'
        , argnames is ['GridNumber']
        ]).
    available_move(N) :-
        list::flatten(_Board_, Flat),
        list::member(N, Flat),
        integer(N).

    :- public(update/3).
    :- mode(update(+integer, +atom, -list), zero_or_one).
    :- info(update/3,
        [ comment is 'Update the board given the move by GridNumber and Player'
        , argnames is ['GridNumber', 'PlayerChar', 'NewBoard']
        ]).
    update(N, C, board([N1, R2, R3])) :-
        % In row 1
        _Board_ = [R1, R2, R3],
        list::select(N, R1, C, N1), !.
    update(N, C, board([R1, N2, R3])) :-
        % In row 2
        _Board_ = [R1, R2, R3],
        list::select(N, R2, C, N2), !.
    update(N, C, board([R1, R2, N3])) :-
        % In row 3
        _Board_ = [R1, R2, R3],
        list::select(N, R3, C, N3), !.

    :- public(print_board/0).
    :- mode(print_board, one).
    :- info(print_board/0,
        [ comment is 'Print the board to stdout'
        ]).
    print_board :-
        _Board_ = [R1, R2, R3],
        write('┌─┬─┬─┐\n'),
        print_row(R1),
        write('├─┼─┼─┤\n'),
        print_row(R2),
        write('├─┼─┼─┤\n'),
        print_row(R3),
        write('└─┴─┴─┘\n').

    % Helper to print board, prints row.
    print_row(Row) :-
        meta::map(print_tile, Row), write('│\n').

    % Helper to print row, prints one tile
    print_tile(Tile) :-
        integer(Tile), write('│'), write(Tile)
    ;   Tile == o, write('│○')
    ;   Tile == x, write('│×').

:- end_object.


:- object(player).

    :- info([ version is 1.0
            , author is 'Paul Brown'
            , date is 2019/10/22
            , comment is 'A human player'
            ]).

    :- private(char/1).
    :- mode(char(?atom), zero_or_one).
    :- info(char/1,
        [ comment is 'The player''s character (x or o)'
        , argnames is ['Char']
        ]).

    :- public(choose_move/2).
    :- mode(choose_move(+list, -integer), zero_or_more).
    :- info(choose_move/2,
        [ comment is 'The player determines the move to take given the board'
        , argnames is ['Board', 'Move']
        ]).

    :- public(has_won/1).
    :- mode(has_won(+list), zero_or_more).
    :- info(has_won/1,
        [ comment is 'Check if the given board is a winning board for the player'
        , argnames is ['Board']
        ]).
    has_won(board(Board)) :-
        ::char(C),
        has_won(C, Board).

    :- private(has_won/2).
    :- mode(has_won(+atom, +list), zero_or_more).
    :- info(has_won/2,
        [ comment is 'Check if the given board is a winning board for the given character'
        , argnames is ['Char', 'Board']
        ]).
    has_won(C, [ [C, C, C]
               , [_, _, _]
               , [_, _, _]
               ]).
    has_won(C, [ [_, _, _]
               , [C, C, C]
               , [_, _, _]
               ]).
    has_won(C, [ [_, _, _]
               , [_, _, _]
               , [C, C, C]
               ]).
    has_won(C, [ [C, _, _]
               , [C, _, _]
               , [C, _, _]
               ]).
    has_won(C, [ [_, C, _]
               , [_, C, _]
               , [_, C, _]
               ]).
    has_won(C, [ [_, _, C]
               , [_, _, C]
               , [_, _, C]
               ]).
    has_won(C, [ [_, _, C]
               , [_, C, _]
               , [C, _, _]
               ]).
    has_won(C, [ [C, _, _]
               , [_, C, _]
               , [_, _, C]
               ]).

    :- public(move/2).
    :- mode(move(+list, -list), zero_or_one).
    :- info(move/2,
       [ comment is 'Ask the human to choose a number and make the move'
       , argnames is ['Board', 'UpdatedBoard']
       ]).
    move(Board, NewBoard) :-
        ::choose_move(Board, N),
        ::char(C),
        Board::update(N, C, NewBoard).

    :- public(win_msg/0).
    :- mode(win_msg, zero_or_one).
    :- info(win_msg/0,
        [ comment is 'Print out a congratulatory message on winning'
        ]).
    win_msg :-
        ::char(C),
        write('Player '),
        write(C),
        write(' wins!\n').

:- end_object.


:- object(human(_C_),
    extends(player)).

    :- info([ version is 1.0
            , author is 'Paul Brown'
            , date is 2019/10/22
            , comment is 'A human player'
            , parnames is ['Char']
            ]).

   char(_C_).

   choose_move(Board, N) :-
        write('Where should '), write(_C_), write(' go?\n'),
        read(N), integer(N),
        Board::available_move(N)
    ; % Move is invalid, notify and recurse
        write('Can''t make that move\n'),
        choose_move(Board, N).

:- end_object.


:- object(computer(_Difficulty_),
    extends(player)).

    :- info([ version is 1.0
            , author is 'Paul Brown'
            , date is 2019/10/22
            , comment is 'A computer player'
            , parnames is ['Difficulty']
            ]).

    char(o).

    win_msg :-
        write('Sorry, you lose!\n').

    choose_move(Board, N) :-
        choose_move(_Difficulty_, Board, N).

    :- public(choose_move/3).
    :- mode(choose_move(+atom, +list, -integer), zero_or_more).
    :- info(choose_move/3,
        [ comment is 'Choose a move using the strategy appropriate for the Difficulty'
        , argnames is ['Difficulty', 'Board', 'Move']
        ]).
    choose_move(easy, Board, N) :-
        choose_random_member(N, [1, 2, 3, 4, 5, 6, 7, 8, 9]),
        Board::available_move(N),
        write('Computer choooses '), write(N), nl.
    choose_move(hard, Board, N) :-
        ai_choose_move(Board, N),
        write('Computer choooses '), write(N), nl.

    :- private(ai_choose_move/2).
    :- mode(ai_choose_move(+list, -integer), zero_or_one).
    :- info(ai_choose_move/2,
        [ comment is 'Use a strategy to choose a move'
        , argnames is ['Board', 'GridNumber']
        ]).
    ai_choose_move(Board, N) :-
        % Computer can win
        Board::available_move(N),
        Board::update(N, o, NewBoard),
        ^^has_won(NewBoard), !.
    ai_choose_move(Board, N) :-
        % Player can win
        Board::available_move(N),
        Board::update(N, x, NewBoard),
        human(x)::has_won(NewBoard), !.
    ai_choose_move(Board, N) :-
        % Pick a corner
        choose_random_member(N, [1, 3, 7, 9]),
        Board::available_move(N), !.
    ai_choose_move(Board, 5) :-
        % Pick the center
        Board::available_move(5), !.
    ai_choose_move(Board, N) :-
        % Pick a middle
        choose_random_member(N, [2, 4, 6, 8]),
        Board::available_move(N), !.

    :- private(choose_random_member/2).
    :- mode(choose_random_member(-any, +list), zero_or_more).
    :- info(choose_random_member/2,
        [ comment is 'Yield elements from list in random order'
        , argnames is ['Elem', 'List']
        ]).
    choose_random_member(N, L) :-
        fast_random::permutation(L, NL),
        list::member(N, NL).

:- end_object.


:- object(game(_Mode_)).

    :- info([ version is 1.0
            , author is 'Paul Brown'
            , date is 2019/10/22
            , comment is 'A game of TicTacToe'
            , parnames is ['Mode']
            ]).

    :- public(play/0).
    :- mode(play, one).
    :- info(play/0,
        [ comment is 'Play a game of TicTacToe at the game object difficulty'
        ]).
    play :-
        % Invalid mode, notify and quit.
        \+ ( _Mode_ == easy ; _Mode_ == hard ; _Mode_ == '2p'),
        write('Games can only be easy, hard or ''2p'' (game(easy)::play)\n'), !.
    play :-
        % Valid difficulty mode, let's play!
        ( _Mode_ == easy ; _Mode_ == hard ),
        write('Welcome to TicTacToe!\n'),
        board(Board)::init, % Make the board
        turn(board(Board), human(x), computer(_Mode_)). % Human Player 'x' goes first
    play :-
        % 2 player
        _Mode_ == '2p',
        write('Welcome to TicTacToe!\nReady player 1\n'),
        board(Board)::init, % Make the board
        turn(board(Board), human(x), human(o)). % Human Player 'x' goes first

    :- private(turn/3).
    :- mode(turn(+list, +term, +term), zero_or_one).
    :- info(turn/3,
        [ comment is 'Play a turn of the game'
        , argnames is ['Board', 'PlayerChar1', 'PlayerChar2']
        ]).
    turn(Board, C1, C2) :-
        Board::print_board,
        C1::move(Board, NewBoard),
        ( C1::has_won(NewBoard)
        -> NewBoard::print_board,
           C1::win_msg
        ; \+ NewBoard::available_move(_)
        -> NewBoard::print_board,
           write('It''s a draw!\n')
        ; turn(NewBoard, C2, C1)
        ).

:- end_object.
