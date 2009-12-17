-include_lib("eunit/include/eunit.hrl").


empty_string_should_add_to_0_test() ->
	?assertEqual(0, calculator:add("")).

string_N_should_add_to_N_test() ->
	?assertEqual(0, calculator:add("0")),
	?assertEqual(1, calculator:add("1")),
	?assertEqual(2, calculator:add("2")),
	?assertEqual(3, calculator:add("3")),
	?assertEqual(4, calculator:add("4")),
	?assertEqual(5, calculator:add("5")),
	?assertEqual(6, calculator:add("6")),
	?assertEqual(7, calculator:add("7")),
	?assertEqual(8, calculator:add("8")),
	?assertEqual(9, calculator:add("9")),
	?assertEqual(10, calculator:add("10")),
	?assertEqual(125, calculator:add("125")).

string_with_2_and_3_should_add_to_5_test() ->
	?assertEqual(5, calculator:add("2,3")).

string_with_few_numbers_should_add_to_their_sum_test() ->
	?assertEqual(125, calculator:add("100,20,5")).

newline_is_a_valid_delimiter_test() ->
	?assertEqual(7, calculator:add("2\n3,2")).

an_alternative_identifier_could_be_specified_test() ->
	?assertEqual(7, calculator:add("//;\n2;3;2")).

an_alternative_identifier_could_be_of_any_length_test() ->
	?assertEqual(7, calculator:add("//;;;\n2;;;3;;;2")).

an_alternative_identifier_could_be_made_of_regular_expressions_special_characters_test() ->
	?assertEqual(7, calculator:add("//**\n2**3**2")).

an_alternative_identifier_could_be_asymmetric_test() ->
	?assertEqual(7, calculator:add("//.,\n2.,3.,2")).

negative_numbers_should_not_be_allowed_test() ->
	?assertException(throw, { negative_numbers, _ }, calculator:add("1,2,3,-1")).

negative_numbers_should_be_specified_in_the_exception_message_test() ->
	?assertException(throw, { negative_numbers, "negatives not allowed: -1" }, calculator:add("1,2,3,-1")).

negative_numbers_could_be_more_than_one_test() ->
	?assertException(throw, { negative_numbers, "negatives not allowed: -1, -2, -3" }, calculator:add("-1,-2,-3,1")).

numbers_can_have_decimals_test() ->
	?assert(float_match(3.3, calculator:add("1.1,2.2"), 3)).

multiple_alternative_delimiters_could_be_specified_test() ->
	?assertEqual(7, calculator:add("//[;][-]\n2;3-2")).

multiple_alternative_delimiters_could_be_of_any_length_test() ->
	?assertEqual(7, calculator:add("//[;][--]\n2;3--2")).

numbers_bigger_than_1000_should_be_ignored_test() ->
	?assertEqual(5, calculator:add("9999,2,3")),
	?assertEqual(5, calculator:add("1001,2,3")),
	?assertEqual(1005, calculator:add("1000,2,3")).

any_amount_of_space_is_allowed_between_numbers_test() ->
	?assertEqual(7, calculator:add(" 2,3,2")),
	?assertEqual(7, calculator:add("2,3,2 ")),
	?assertEqual(7, calculator:add(" 2,3,2 ")),
	?assertEqual(7, calculator:add("2 ,3,2")),
	?assertEqual(7, calculator:add("2,3 ,2")),
	?assertEqual(7, calculator:add("2 , 3 ,  2")).



float_match(A,B,L) ->
    <<AT:L/binary, _/binary>> = <<A/float>>,
    <<BT:L/binary, _/binary>> = <<B/float>>,
    AT =:= BT.
