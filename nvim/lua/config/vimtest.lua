
      vim.cmd [[
      let g:test#javascript#runner = "mocha"
      let g:test#javascript#mocha#options = '--colors --recursive --timeout 0 --check-leaks --require source-map-support/register --globals database,models --require dist/common/test/init '
      let g:test#javascript#mocha#executable = 'make compile && npx mocha'
      let g:test#javascript#mocha#file_pattern = '.*'
      let test#project_root = "~/awayco-monorepo/backend"
      let test#strategy = "neovim"
      let g:test#runner_commands = ['Mocha']
      let g:test#preserve_screen = 1
      ]]
