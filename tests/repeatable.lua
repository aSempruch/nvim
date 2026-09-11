local pair = require('config.repeatable').pair
local rm = require 'nvim-treesitter-textobjects.repeatable_move'

local inner_calls = 0
local inner_next, inner_prev = pair(function()
	inner_calls = inner_calls + 1
end, function()
	inner_calls = inner_calls - 1
end)

local outer_next, outer_prev = pair(inner_next, inner_prev)

outer_next()
local outer_repeat = rm.last_move.func
assert(inner_calls == 1, 'outer motion did not run its nested forward action')

rm.repeat_last_move_next()
assert(inner_calls == 2, 'repeating the outer motion did not run its nested action')
assert(rm.last_move.func == outer_repeat, 'nested motion replaced the outer repeat record')

outer_prev()
local reverse_repeat = rm.last_move.func
assert(inner_calls == 1, 'reverse outer motion did not run its nested backward action')

rm.repeat_last_move_previous()
assert(inner_calls == 0, 'reversing the outer motion did not run its nested action')
assert(rm.last_move.func == reverse_repeat, 'nested reverse motion replaced the outer repeat record')

outer_next()
local user_repeat = rm.last_move.func
local automatic_navigation = require('config.repeatable').preserve_last_move(inner_next)
automatic_navigation()
assert(inner_calls == 2, 'preserved automatic navigation did not run')
assert(rm.last_move.func == user_repeat, 'automatic navigation replaced the user repeat record')
