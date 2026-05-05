local ls = require 'luasnip'
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require('luasnip.extras.fmt').fmt
local rep = require('luasnip.extras').rep

return {

  -- main function template
  s(
    'main',
    fmt(
      [[
def main() -> None:
    {}

if __name__ == '__main__':
    main()
]],
      { i(1, 'pass') }
    )
  ),

  -- File load template
  s(
    'openfile',
    fmt(
      [[
with open("{}", "{}") as {}:
    {} = {}.read()
    {}
]],
      {
        i(1, 'filename.txt'), -- Filename
        i(2, 'r'), -- Mode
        i(3, 'f'), -- File object
        i(4, '_file'), -- Store content to read
        rep(3), -- Same f as in f.read()
        i(5, 'pass'), -- Optional processing
      }
    )
  ),

  -- File write template
  s(
    'writefile',
    fmt(
      [[
with open("{}", "{}") as {}:
    {}.write({})
    {}
]],
      {
        i(1, 'filename.txt'),
        i(2, 'w'),
        i(3, 'f'),
        rep(3),
        i(4, 'content'),
        i(5, 'pass'),
      }
    )
  ),

  -- JSON Load
  s(
    'jsonload',
    fmt(
      [[
import json

with open("{}", "{}") as {}:
    {} = json.load({})
    {}
]],
      {
        i(1, 'data.json'),
        i(2, 'r'),
        i(3, 'f'),
        i(4, 'data'),
        rep(3),
        i(5, 'pass'),
      }
    )
  ),

  -- JSON write
  s(
    'jsondump',
    fmt(
      [[
import json

with open("{}", "{}") as {}:
    json.dump({}, {}, indent={})
    {}
]],
      {
        i(1, 'data.json'),
        i(2, 'w'),
        i(3, 'f'),
        i(4, 'data'), -- Data to write
        rep(3),
        i(5, '4'), -- indent
        i(6, 'pass'),
      }
    )
  ),

  -- CSV Load
  s(
    'csvread',
    fmt(
      [[
import csv

with open("{}", "{}") as {}:
    reader = csv.reader({})
    {} = list(reader)
    {}
]],
      {
        i(1, 'data.csv'),
        i(2, 'r'),
        i(3, 'f'),
        rep(3),
        i(4, 'rows'),
        i(5, 'pass'),
      }
    )
  ),

  -- CSV write
  s(
    'csvwrite',
    fmt(
      [[
import csv

with open("{}", "{}", newline="") as {}:
    writer = csv.writer({})
    writer.writerows({})
    {}
]],
      {
        i(1, 'data.csv'),
        i(2, 'w'),
        i(3, 'f'),
        rep(3),
        i(4, 'rows'),
        i(5, 'pass'),
      }
    )
  ),

  -- Python class creation snippet
  s(
    'class',
    fmt(
      [[
class {}({}):
    """
    {}
    """
    def __init__(self, {}):
        {}
        {}
    
    {}
]],
      {
        i(1, 'MyClass'), -- Class name
        i(2, 'object'), -- Parent class
        i(3, 'Class Description'), -- docstring
        i(4, 'arg1'), -- __init__ argument
        i(5, 'self.arg1 = arg1'), -- Processing in __init__
        i(6, 'pass'), -- Remaining __init__ processing
        i(7, 'def method(self):\n        pass'), -- For adding methods
      }
    )
  ),
  -- PySide6 app launch snippet
  s(
    'pyside',
    fmt(
      [[
  import sys

  from PySide6 import QtWidgets
  from {} import {}

  app = QtWidgets.QApplication(sys.argv)

  window = {}()
  window.show()

  app.exec()
  ]],
      {
        i(1, 'widget'), -- Module name
        i(2, 'Widget'), -- Class name
        i(3, 'Widget'), -- Instance creation class
      }
    )
  ),
}
