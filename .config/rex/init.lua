-- Migrated from tmux (~/.tmux.conf) and Ghostty (~/.config/ghostty/config)

-- tmux: repeat mode for bind -r bindings
rex.mode("repeat", { exclusive = true })
rex.bind("ctrl+b>r", "client.mode.enter", { name = "repeat" })
rex.bind("repeat/enter", "client.mode.exit")
rex.bind("repeat/escape", "client.mode.exit")

-- tmux
rex.bind("ctrl+b>ctrl+a", "pane.send_key", { key = "ctrl+b" })
rex.bind("ctrl+b>c", "client.tab.new")
rex.bind("ctrl+b>e", "client.tab.new")
rex.bind("ctrl+b>ctrl+c", "session.new")
rex.bind("ctrl+b>x", "client.close")
rex.bind("ctrl+b>shift+'", "pane.split", { direction = "down" })
rex.bind("ctrl+b>shift+5", "pane.split", { direction = "right" })
rex.bind("ctrl+b>-", "pane.split", { direction = "down" })
rex.bind("ctrl+b>shift+-", "pane.split", { direction = "right" })
rex.bind("ctrl+b>h", "pane.focus", { direction = "left" })
rex.bind("repeat/h", "pane.focus", { direction = "left" })
rex.bind("ctrl+b>j", "pane.focus", { direction = "down" })
rex.bind("repeat/j", "pane.focus", { direction = "down" })
rex.bind("ctrl+b>k", "pane.focus", { direction = "up" })
rex.bind("repeat/k", "pane.focus", { direction = "up" })
rex.bind("ctrl+b>l", "pane.focus", { direction = "right" })
rex.bind("repeat/l", "pane.focus", { direction = "right" })
rex.bind("ctrl+b>shift+.", "pane.move", { direction = "down" })
rex.bind("ctrl+b>shift+,", "pane.move", { direction = "up" })
rex.bind("ctrl+b>shift+h", "pane.resize", { amount = 2, direction = "left" })
rex.bind("repeat/shift+h", "pane.resize", { amount = 2, direction = "left" })
rex.bind("ctrl+b>shift+j", "pane.resize", { amount = 2, direction = "down" })
rex.bind("repeat/shift+j", "pane.resize", { amount = 2, direction = "down" })
rex.bind("ctrl+b>shift+k", "pane.resize", { amount = 2, direction = "up" })
rex.bind("repeat/shift+k", "pane.resize", { amount = 2, direction = "up" })
rex.bind("ctrl+b>shift+l", "pane.resize", { amount = 2, direction = "right" })
rex.bind("repeat/shift+l", "pane.resize", { amount = 2, direction = "right" })
rex.bind("ctrl+b>ctrl+h", "client.tab.previous")
rex.bind("repeat/ctrl+h", "client.tab.previous")
rex.bind("ctrl+b>ctrl+l", "client.tab.next")
rex.bind("repeat/ctrl+l", "client.tab.next")

rex.bind("ctrl+b>,", "client.tab.rename")
rex.bind("ctrl+b>shift+4", "session.rename")
for index = 1, 9 do
  rex.bind("ctrl+b>" .. index, "client.tab.goto", { index = index })
end

rex.action{
  name = "go_to_tab_number",
  title = "Go to Tab Number",
  run = function()
    local text = rex.ui.input{ title = "Go to Tab Number", placeholder = "Tab number" }
    local index = tonumber((text or ""):match("^%s*(%d+)%s*$") or "")
    if index and index > 0 and index < math.huge then
      rex.client.queue("client.tab.goto", { index = index })
    end
  end,
}
rex.bind("ctrl+b>'", "go_to_tab_number")

-- Ghostty: cmd+k=clear_screen moved to shift+cmd+k by user decision (cmd+k keeps session picker)
rex.bind("shift+cmd+k", "com.superlogical.terminal.clear")

-- Ghostty: cmd+/=text:\x20/ (vim <leader>/ comment toggle); sends space then /
rex.action{
  name = "vim_comment_toggle",
  title = "Vim: Toggle Comment",
  run = function(ctx, args)
    rex.client.queue("pane.send_key", { key = "space" })
    rex.client.queue("pane.send_key", { key = "/" })
  end,
}
rex.bind("cmd+/", "vim_comment_toggle")
rex.bind("cmd+shift+/", "client.sidebar.toggle")

-- vim-tmux-navigator (tmux plugin): ctrl+hjkl go to nvim when it is in front, else focus the Rex pane.
-- Overrides tmux.conf:59 C-l, as the plugin loads later.
-- At nvim's edge, ~/.config/nvim/lua/plugins/tmux-navigator.lua calls Rex's session.focus_direction.
local vim_names = { nvim = true, vim = true, vi = true }
rex.action{
  name = "vim_navigate",
  title = "Navigate Vim or Pane",
  args = { direction = "string", key = "string" },
  run = function(ctx, args)
    local p = rex.block.call("com.superlogical.terminal", "process", {})
    if p and p.foreground and vim_names[p.foreground.name] then
      rex.client.queue("pane.send_key", { key = args.key })
    else
      rex.client.queue("pane.focus", { direction = args.direction, wrap = true })
    end
  end,
}
rex.bind("ctrl+h", "vim_navigate", { direction = "left", key = "ctrl+h" })
rex.bind("ctrl+j", "vim_navigate", { direction = "down", key = "ctrl+j" })
rex.bind("ctrl+k", "vim_navigate", { direction = "up", key = "ctrl+k" })
rex.bind("ctrl+l", "vim_navigate", { direction = "right", key = "ctrl+l" })
