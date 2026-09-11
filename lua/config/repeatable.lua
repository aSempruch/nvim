-- Make any next/prev motion pair repeatable with `;` and `,`.
--
-- Stock Vim only lets `;`/`,` repeat f/F/t/T. nvim-treesitter-textobjects'
-- repeatable_move module generalises that: it remembers the last "move" you
-- ran and `;`/`,` replay it forward/backward. This wraps an arbitrary
-- (next_fn, prev_fn) pair so hunk jumps, next/prev-file in diff reviews,
-- etc. all participate. The `;`/`,` maps themselves live in
-- plugins/treesitter.lua.
--
-- The textobjects plugin is lazy-loaded, so require it at keypress time
-- rather than when the maps are defined.
local M = {}

--- @param next_fn fun()
--- @param prev_fn fun()
--- @return fun() next, fun() prev
function M.pair(next_fn, prev_fn)
  local move
  local function get_move()
    if not move then
      local rm = require 'nvim-treesitter-textobjects.repeatable_move'
      move = rm.make_repeatable_move(function(opts)
        -- A high-level motion may use another repeatable motion internally
        -- (for example, Octo's ]c advances files through its ]q action).
        -- Keep the command the user invoked as the repeat target.
        local outer_move = rm.last_move
        if opts.forward then next_fn() else prev_fn() end
        rm.last_move = outer_move
      end)
    end
    return move
  end
  return function() get_move() { forward = true } end,
      function() get_move() { forward = false } end
end

return M
