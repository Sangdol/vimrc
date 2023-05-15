--
-- From https://github.com/malkoG/dotfiles/commit/ac7c9aa889ad5a7b31fa39036cdcb6b9f4fd5d60
--
-- Pre-requisites:
--   pip install inko-py
--
local function generate_command(line, language)
  local inko_option = ''

  if language == 'korean' then
    inko_option = 'en2ko'
  end

  local sanitized_line = ''
  local last_pos = #line
  if line:sub(last_pos, last_pos) == "\n" then
    sanitized_line = line:sub(1, last_pos - 1)
  else
    sanitized_line = line
  end

  local command = "python -c \""
  command = command .. "from inko import Inko;"
  command = command .. "converter = Inko();"
  command = command .. "print(converter." .. inko_option .. "('" .. sanitized_line .. "'), end='')"
  command = command .. "\""

  return command
end

function SwitchToHangeul()
  local buffer = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buffer, 0, -1, false)

  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  for line = start_line, end_line do
    local command = generate_command(lines[line], "korean")
    local handle = io.popen(command)
    local result = handle:read("a*")
    handle:close()
    if #lines[line] >= 1 then
      vim.api.nvim_buf_set_text(0, line - 1, 0, line - 1, #lines[line], {result})
    end
  end
end

vim.keymap.set('x', '<leader>ek', ':lua SwitchToHangeul()<CR>', {noremap = true, silent = true})
