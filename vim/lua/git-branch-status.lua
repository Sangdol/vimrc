--
-- Original code from
-- https://www.reddit.com/r/neovim/comments/t48x5i/git_branch_aheadbehind_info_status_line_component/
--

if package.loaded['git-branch-status'] then
  print('git-branch-status already loaded')
  return
end

Gstatus = {
  ahead = 0,
  behind = 0,
  statusbar = function(self)
    return self.ahead..' '..self.behind..''
  end,
  reset = function(self)
    self.ahead = 0
    self.behind = 0
  end,
  update = function(self, ahead, behind)
    self.ahead = ahead
    self.behind = behind
  end
}

local function update_gstatus()
  local Job = require'plenary.job'
  Job:new({
    command = 'git',
    args = { 'rev-list', '--left-right', '--count', 'HEAD...@{upstream}' },
    on_exit = function(job, _)
      local res = job:result()[1]
      if type(res) ~= 'string' then Gstatus:reset() return end
      local ok, ahead, behind = pcall(string.match, res, "(%d+)%s*(%d+)")
      if not ok then ahead, behind = 0, 0 end

      Gstatus:update(ahead, behind)
    end,
  }):start()
end

if _G.Gstatus_timer == nil then
  _G.Gstatus_timer = vim.loop.new_timer()
else
  _G.Gstatus_timer:stop()
end

_G.Gstatus_timer:start(0, 2000,  vim.schedule_wrap(update_gstatus))

