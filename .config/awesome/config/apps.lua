local _M = {
   terminal = os.getenv('TERMINAL') or 'alacritty',
   editor   = os.getenv('EDITOR')   or 'nvim',
   browser  = os.getenv('BROWSER')  or 'firefox',
   shell    = os.getenv('SHELL')    or '/usr/bin/zsh',
}

_M.editor_cmd = _M.terminal .. ' -e ' .. _M.editor
_M.manual_cmd = _M.terminal .. ' -e man awesome'

return _M
