/* TicTacToeTalk

An implementation of TicTacToe in Logtalk

@author Paul Brown
@license MIT
*/

:- if((
	current_logtalk_flag(prolog_dialect, Dialect),
	(Dialect == cx; Dialect == sicstus; Dialect == swi; Dialect == yap)
)).

	:- initialization((
		logtalk_load([types(loader), meta(loader), random(loader)]),
		logtalk_load(game, [optimize(on)])
	)).

:- else.

	:- initialization((
		nl, write('WARNING: example not supported on this backend Prolog compiler!'), nl, nl
	)).

:- endif.
