--
-- Original code from
-- https://www.reddit.com/r/neovim/comments/t48x5i/git_branch_aheadbehind_info_status_line_component/
--

Gstatus = {
  ahead = 0,
  behind = 0,
  statusbar = function(self)
    local ahead = self.ahead > 0 and self.ahead .. '↑' or ''
    local behind = self.behind > 0 and self.behind .. '↓' or ''
    return ahead .. behind
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
  local ok, Job = pcall(require, 'plenary.job')

  if not ok then
    print('plenary.job not found. git-branch-status-timer.lua will not work.')
    _G.Gstatus_timer:stop()
    return
  end

  Job:new({
    command = 'git',
    args = { 'rev-list', '--left-right', '--count', 'HEAD...@{upstream}' },
    on_exit = function(job, _)
      local res = job:result()[1]
      if type(res) ~= 'string' then Gstatus:reset() return end
      local ok, ahead, behind = pcall(string.match, res, "(%d+)%s*(%d+)")
      if not ok then ahead, behind = 0, 0 end

      Gstatus:update(tonumber(ahead), tonumber(behind))
    end,
  }):start()
end

local function safe_update_gstatus()
  local success, message = pcall(update_gstatus)

  if not success then
    print("An error occurred in update_gstatus: " .. message)
    _G.Gstatus_timer:stop()
  end
end

if _G.Gstatus_timer == nil then
  _G.Gstatus_timer = vim.loop.new_timer()
else
  _G.Gstatus_timer:stop()
end

_G.Gstatus_timer:start(0, 2000, vim.schedule_wrap(safe_update_gstatus))

