-module(calculator).
-export([ add/1 ]).


add(String) -> 
	lists:foldl(fun(Number, Sum) ->
		Sum + Number
	end, 0, to_numbers(String)).

to_numbers(String) ->
	Numbers = [ to_number(Token) || Token <- split_into_tokens(String) ],
	AllowedNumbers = filter_numbers_bigger_than_1000(Numbers),
	throw_if_contains_negatives(AllowedNumbers),
	AllowedNumbers.

split_into_tokens([ $/, $/ | DelimiterAndString ]) ->
	{ String, Delimiters } = extract_delimiter(remove_any_spaces(DelimiterAndString)),
	split_into_tokens(String, Delimiters);
split_into_tokens(String) ->
	split_into_tokens("//,\n" ++ String).
split_into_tokens(String, Delimiters) ->
	DelimitersExpression = string:join([ "\\Q" ++ Delimiter ++ "\\E" || Delimiter <- Delimiters ], "|"),
	re:split(String, DelimitersExpression ++ "|\n", [ { return, list } ]).

extract_delimiter(DelimiterAndString) ->
	extract_delimiter(DelimiterAndString, "", []).
extract_delimiter([ $\n | String ], "", Delimiters) ->
	{ String, Delimiters };
extract_delimiter([ $\n | String ], DelimiterSoFar, Delimiters) ->
	{ String, [ lists:reverse(DelimiterSoFar) | Delimiters ] };
extract_delimiter([ $[ | DelimiterAndString ], _, Delimiters) ->
	extract_delimiter(DelimiterAndString, "", Delimiters);
extract_delimiter([ $] | DelimiterAndString ], DelimiterSoFar, Delimiters) ->
	extract_delimiter(DelimiterAndString, "", [ lists:reverse(DelimiterSoFar) | Delimiters ]);
extract_delimiter([ DelimiterCharacter | DelimiterAndString ], DelimiterSoFar, Delimiters) ->
	extract_delimiter(DelimiterAndString, [ DelimiterCharacter | DelimiterSoFar ], Delimiters).

filter_numbers_bigger_than_1000(Numbers) ->
	[ Number || Number <- Numbers, Number =< 1000 ].

to_number(String) ->
	case string:to_float(String) of
		{ error, no_float} -> 
			case string:to_integer(String) of
				{ error, no_integer } -> 0;
				{ Integer, _ } -> Integer
			end;
		{ Float, _ } -> Float
	end.

throw_if_contains_negatives(Numbers) ->
	throw_if_not_empty([ Number || Number <- Numbers, Number < 0 ]).

throw_if_not_empty([]) -> do_nothing;
throw_if_not_empty(Negatives) -> 
	Message = "negatives not allowed: " ++ string:join([ integer_to_list(Negative) || Negative <- Negatives ], ", "),
	throw({ negative_numbers, Message }).

remove_any_spaces(StringWithSpaces) ->
	re:replace(StringWithSpaces, "\s*", "", [ { return, list }, global ]).



-ifdef(TEST).
-include_lib("../test/calculator.hrl").
-endif.
