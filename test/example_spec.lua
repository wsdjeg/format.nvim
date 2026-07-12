-- test/example_spec.lua
-- Example test file for format.nvim

local lu = require('luaunit')

TestFormatSetup = {}

function TestFormatSetup:setUp()
  -- Reload format module before each test
  package.loaded['format'] = nil
end

function TestFormatSetup:teardown()
  package.loaded['format'] = nil
end

function TestFormatSetup:test_module_loads()
  local ok, mod = pcall(require, 'format')
  lu.assertTrue(ok)
  lu.assertNotNil(mod)
  lu.assertIsFunction(mod.format)
  lu.assertIsFunction(mod.setup)
end

function TestFormatSetup:test_setup_accepts_custom_formatters()
  local format = require('format')
  local ok = pcall(format.setup, {
    custom_formatters = {
      lua = {
        exe = 'stylua',
        args = { '-' },
        stdin = true,
      },
    },
    timeout = 3000,
  })
  lu.assertTrue(ok)
end

function TestFormatSetup:test_setup_accepts_empty_opts()
  local format = require('format')
  local ok = pcall(format.setup, {})
  lu.assertTrue(ok)
end

-- Test filetype formatter modules

TestFiletypeFormatters = {}

function TestFiletypeFormatters:test_lua_formatter()
  local ft = require('format.ft.lua')
  lu.assertNotNil(ft)
  lu.assertIsFunction(ft.enabled)
  lu.assertIsFunction(ft.stylua)

  local enabled = ft.enabled()
  lu.assertIsTable(enabled)
  lu.assertEquals(#enabled, 1)
  lu.assertEquals(enabled[1], 'stylua')

  local spec = ft.stylua({ filepath = '/tmp/test.lua' })
  lu.assertEquals(spec.exe, 'stylua')
  lu.assertIsTable(spec.args)
  lu.assertTrue(spec.stdin)
end

function TestFiletypeFormatters:test_c_formatters()
  local ft = require('format.ft.c')
  lu.assertNotNil(ft)
  lu.assertIsFunction(ft.enabled)

  local enabled = ft.enabled()
  lu.assertIsTable(enabled)
  lu.assertEquals(#enabled, 3)
  lu.assertEquals(enabled[1], 'uncrustify')
  lu.assertEquals(enabled[2], 'clangformat')
  lu.assertEquals(enabled[3], 'astyle')

  local spec = ft.clangformat({ filepath = '/tmp/test.c' })
  lu.assertEquals(spec.exe, 'clang-format')
  lu.assertTrue(spec.stdin)
end

function TestFiletypeFormatters:test_python_formatter()
  local ft = require('format.ft.python')
  lu.assertNotNil(ft)

  local enabled = ft.enabled()
  lu.assertEquals(enabled[1], 'yapf')

  local spec = ft.yapf({ filepath = '/tmp/test.py' })
  lu.assertEquals(spec.exe, 'yapf')
  lu.assertTrue(spec.stdin)
end

function TestFiletypeFormatters:test_rust_formatter()
  local ft = require('format.ft.rust')
  lu.assertNotNil(ft)

  local enabled = ft.enabled()
  lu.assertEquals(enabled[1], 'rustfmt')

  local spec = ft.rustfmt({ filepath = '/tmp/test.rs' })
  lu.assertNotNil(spec.exe)
end

function TestFiletypeFormatters:test_go_formatter()
  local ft = require('format.ft.go')
  lu.assertNotNil(ft)

  local enabled = ft.enabled()
  lu.assertEquals(enabled[1], 'gofmt')
end

function TestFiletypeFormatters:test_json_formatter()
  local ft = require('format.ft.json')
  lu.assertNotNil(ft)

  local enabled = ft.enabled()
  lu.assertEquals(enabled[1], 'prettier')
end

function TestFiletypeFormatters:test_toml_formatters()
  local ft = require('format.ft.toml')
  lu.assertNotNil(ft)

  local enabled = ft.enabled()
  lu.assertEquals(#enabled, 2)
  lu.assertEquals(enabled[1], 'taplo')
  lu.assertEquals(enabled[2], 'topiary')

  local spec = ft.taplo({ filepath = '/tmp/test.toml' })
  lu.assertEquals(spec.exe, 'taplo')
end

function TestFiletypeFormatters:test_all_ft_modules_return_table_for_enabled()
  local filetypes = { 'c', 'lua', 'python', 'rust', 'go', 'json', 'markdown',
    'javascript', 'java', 'asm', 'elixir', 'toml' }
  for _, ft_name in ipairs(filetypes) do
    local ok, ft = pcall(require, 'format.ft.' .. ft_name)
    lu.assertTrue(ok, 'failed to load format.ft.' .. ft_name)
    lu.assertIsFunction(ft.enabled)
    local enabled = ft.enabled()
    lu.assertIsTable(enabled)
    lu.assertTrue(#enabled > 0, 'no formatters enabled for ' .. ft_name)
  end
end

return TestFormatSetup

