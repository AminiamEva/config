local platform = require('utils.platform')

---@type Config
local options = {
   -- ref: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
   ssh_domains = {},

   -- ref: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
   unix_domains = {},

   -- ref: https://wezfurlong.org/wezterm/config/lua/WslDomain.html
   wsl_domains = {},
}

if platform.is_win then
   -- options.ssh_domains = {
   --    {
   --       name = 'ssh:wsl',
   --       username = 'aminiam',
   --       remote_address = 'localhost',
   --       multiplexing = 'None',
   --       default_prog = { 'fish', '-l' },
   --       assume_shell = 'Posix',
   --    },
   -- }

   options.wsl_domains = {
      -- {
      --    name = 'wsl:ubuntu',
      --    distribution = 'Ubuntu',
      --    username = 'aminiam',
      --    default_cwd = '/home/aminiam',
      --    default_prog = { 'fish', '-l' },
      -- },
      {
         name = 'wsl:ubuntu-bash',
         distribution = 'Ubuntu',
         username = 'aminiam',
         default_cwd = '/home/aminiam',
         default_prog = { 'bash', '-l' },
      },
   }
end

return options
