:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 1.1,
		author is 'Paul Brown',
		date is 2019/10/25,
		comment is 'Unit tests for tictactoe.'
	]).

	:- uses(integer, [
		between/3
	]).

	cover(game(_)).
	cover(board(_)).
	cover(player).
	cover(human(_)).
	cover(computer(_)).

	cleanup :-
		^^clean_text_input.

    %%
    % Board
    %%
    test(board_init, true(B == [[1, 2, 3], [4, 5, 6], [7, 8, 9]])) :-
        board(B)::init.

    test(avail_move_all, true(Mvs == [1, 2, 3, 4, 5, 6, 7, 8, 9])) :-
        setof(Mv, board([[1, 2, 3], [4, 5, 6], [7, 8, 9]])::available_move(Mv), Mvs).
    test(avail_move_some, true(Mvs == [1, 6, 8])) :-
        setof(Mv, board([[1, x, o], [x, o, 6], [o, 8, x]])::available_move(Mv), Mvs).
    test(avail_move_none, fail) :-
        board([[o, x, o], [x, o, x], [o, o, x]])::available_move(_).

    test(board_update_r1, true(B == board([[1, x, 3], [4, 5, 6], [7, 8, 9]]))) :-
        board([[1, 2, 3], [4, 5, 6], [7, 8, 9]])::update(2, x, B).
    test(board_update_r2, true(B == board([[1, x, 3], [4, o, 6], [7, 8, 9]]))) :-
        board([[1, x, 3], [4, 5, 6], [7, 8, 9]])::update(5, o, B).
    test(board_update_r3, true(B == board([[1, x, 3], [4, o, 6], [7, 8, x]]))) :-
        board([[1, x, 3], [4, o, 6], [7, 8, 9]])::update(9, x, B).
    test(board_update_out, fail) :-
        board([[1, x, 3], [4, o, 6], [7, 8, x]])::update(0, x, _).
    test(board_update_moved, fail) :-
        board([[1, x, 3], [4, o, 6], [7, 8, x]])::update(2, x, _).
    test(board_update_o_moved, fail) :-
        board([[1, x, 3], [4, o, 6], [7, 8, x]])::update(5, x, _).

    test(prt_board) :- % succeeds at least...
        board([[1, x, 3], [4, o, 6], [7, 8, 9]])::print_board.

    %%
    % Players
    %%
    test(comp_easy_choose_move, true(between(1, 9, N))) :-
        computer(easy)::choose_move(board([[1, 2, 3], [4, 5, 6], [7, 8, 9]]), N).
    test(comp_hard_choose_move, true(between(1, 9, N))) :-
        computer(hard)::choose_move(board([[1, 2, 3], [4, 5, 6], [7, 8, 9]]), N).
    test(comp_easy_one_move, true(N == 9)) :-
        computer(easy)::choose_move(board([[x, o, x], [o, x, o], [x, o, 9]]), N).

    test(human_choose_move, true(N == 1)) :-
        ^^set_text_input('1.'),
        human(x)::choose_move(board([[1, 2, 3], [4, 5, 6], [7, 8, 9]]), N).
    test(human_choose_move_retry, true(N == 2)) :-
        ^^set_text_input('1.\n2.'),
        human(x)::choose_move(board([[o, 2, 3], [4, 5, 6], [7, 8, 9]]), N).

    test(player_choose_move, fail) :-
        player(_)::choose_move(board([[o, 2, 3], [4, 5, 6], [7, 8, 9]]), _).


    test(comp_only_move, true(B == board([[x, o, x], [o, x, o], [x, o, o]]))) :-
        computer(easy)::move(board([[x, o, x], [o, x, o], [x, o, 9]]), B).
    test(comp_hard_move, true(B \= NB)) :-
        B = board([ [x, 2, 3]
                  , [4, 5, o]
                  , [7, x, 9]
                  ]),
        computer(hard)::move(B, NB).

    test(has_won_1, true) :-
        human(x)::has_won(board([ [x, x, x]
                                , [_, _, _]
                                , [_, _, _]
                                ])).
    test(has_won_2, true) :-
        human(x)::has_won(board([ [_, _, _]
                                , [x, x, x]
                                , [_, _, _]
                                ])).
    test(has_won_3, true) :-
        human(x)::has_won(board([ [_, _, _]
                                , [_, _, _]
                                , [x, x, x]
                                ])).
    test(has_won_4, true) :-
        human(x)::has_won(board([ [x, _, _]
                                , [x, _, _]
                                , [x, _, _]
                                ])).
    test(has_won_5, true) :-
        human(x)::has_won(board([ [_, x, _]
                                , [_, x, _]
                                , [_, x, _]
                                ])).
    test(has_won_6, true) :-
        human(x)::has_won(board([ [_, _, x]
                                , [_, _, x]
                                , [_, _, x]
                                ])).
    test(has_won_7, true) :-
        human(x)::has_won(board([ [x, _, _]
                                , [_, x, _]
                                , [_, _, x]
                                ])).
    test(has_won_8, true) :-
        human(x)::has_won(board([ [_, _, x]
                                , [_, x, _]
                                , [x, _, _]
                                ])).
    test(has_won_9, fail) :-
        human(o)::has_won(board([ [x, x, x]
                                , [x, x, x]
                                , [x, x, x]
                                ])).
    test(has_won_10, true) :-
        computer(easy)::has_won(board([ [o, o, o]
                                      , [_, _, _]
                                      , [_, _, _]
                                      ])).

    test(win_msg_succeeds, true) :-
        computer(easy)::win_msg,
        computer(hard)::win_msg,
        human(o)::win_msg,
        human(x)::win_msg.

    %%
    % Game
    %%
    test(play_bad_mode_notice_succeeds, deterministic) :-
        game(not_a_valid_mode_ever)::play.
    test(play_easy_blind, true) :-
        ^^set_text_input('1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n'),
        game(easy)::play.
    test(play_hard_blind, true) :-
        ^^set_text_input('1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n'),
        game(hard)::play.
    test(play_human_blind, true) :-
        ^^set_text_input('1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n1.\n2.\n3.\n4.\n5.\n6.\n7.\n8.\n9.\n'),
        game('2p')::play.

:- end_object.
