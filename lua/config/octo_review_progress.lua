-- Lualine extension for Octo's review file panel.
--
-- The panel's statusline stays drawn while the cursor is in a diff pane
-- (where the stock line only shows the diff file's own position), so put
-- review progress there: how many files GitHub has marked "Viewed", split
-- into main and test sources since test changes get less attention, plus
-- which file of the list is currently selected.
local M = {}

local function current_layout()
  local reviews = package.loaded['octo.reviews']
  return reviews and reviews.get_current_layout()
end

--- Gradle-style test source sets: src/test, src/testFixtures,
--- src/integrationTest, ... Everything else (including build files) is main.
--- @param path string
function M.is_test(path)
  return ('/' .. path):find '/src/%w*[Tt]est%w*/' ~= nil
end

function M.viewed()
  local layout = current_layout()
  if not layout then
    return ''
  end
  local counts = { main = { viewed = 0, total = 0 }, test = { viewed = 0, total = 0 } }
  for _, file in ipairs(layout.files) do
    local count = counts[M.is_test(file.path) and 'test' or 'main']
    count.total = count.total + 1
    if file.viewed_state == 'VIEWED' then
      count.viewed = count.viewed + 1
    end
  end
  local parts = {}
  for _, kind in ipairs { 'main', 'test' } do
    if counts[kind].total > 0 then
      table.insert(parts, string.format('%s %d/%d', kind, counts[kind].viewed, counts[kind].total))
    end
  end
  return #parts > 0 and 'viewed: ' .. table.concat(parts, ' · ') or ''
end

function M.position()
  local layout = current_layout()
  if not layout or #layout.files == 0 then
    return ''
  end
  return string.format('file %d/%d', layout.selected_file_idx, #layout.files)
end

M.extension = {
  filetypes = { 'octo_panel' },
  sections = {
    lualine_c = { M.viewed },
    lualine_z = { M.position },
  },
}

return M
