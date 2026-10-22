-- Tmux-style prefix followed by Vim pane navigation keys.
rex.bind("ctrl+b>h", "pane.focus", { direction = "left" })
rex.bind("ctrl+b>j", "pane.focus", { direction = "down" })
rex.bind("ctrl+b>k", "pane.focus", { direction = "up" })
rex.bind("ctrl+b>l", "pane.focus", { direction = "right" })

-- Zoom the focused pane.
rex.bind("ctrl+b>z", "pane.zoom")

-- Select tabs 1 through 9 with the same prefix.
for index = 1, 9 do
  rex.bind("ctrl+b>" .. index, "client.tab.goto", { index = index })
end

-- Press Ctrl+B twice to send Ctrl+B to the terminal.
rex.bind("ctrl+b>ctrl+b", "pane.send_key", { key = "ctrl+b" })
