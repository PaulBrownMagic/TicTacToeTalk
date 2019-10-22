:- initialization((
	set_logtalk_flag(report, warnings),
	logtalk_load([types(loader), meta(loader), random(loader)]),
	logtalk_load(lgtunit(loader)),
	logtalk_load(game, [source_data(on), debug(on)]),
	logtalk_load(tests, [hook(lgtunit)]),
	tests::run
)).
