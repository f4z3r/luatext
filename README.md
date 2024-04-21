# ![LuaText](./assets/logo.png)

![GitHub License](https://img.shields.io/github/license/f4z3r/luatext?link=https%3A%2F%2Fgithub.com%2Ff4z3r%2Fluatext%2Fblob%2Fmain%2FLICENSE)
![GitHub Release](https://img.shields.io/github/v/release/f4z3r/luatext?logo=github&link=https%3A%2F%2Fgithub.com%2Ff4z3r%2Fluatext%2Freleases)
![LuaRocks](https://img.shields.io/luarocks/v/f4z3r/luatext?logo=lua&link=https%3A%2F%2Fluarocks.org%2Fmodules%2Ff4z3r%2Fluatext)

A small library to print colored text to the console.

---

<!--toc:start-->
- [Example](#example)
- [Reference](#reference)
- [Installation](#installation)
- [ANSI256 Color Codes](#ansi256-color-codes)
- [Development](#development)
  - [Testing](#testing)
<!--toc:end-->

---

> LuaText should be compatible with LuaJIT 2.1, Lua 5.1, 5.2, 5.3, and 5.4.

## Example

A simple example to render an entire string in red on a black background, underlined:

```lua
local text = require("luatext")

local my_str = text
    .Text
    :new("Hello world!!")
    :fg(160)  -- red as an ANSI256 color code
    :bg({0, 0, 0}) -- black as an RGB value
    :underlined()

print(my_str)
```

Running this code will produce the following output:

![Output from a simple example](assets/simple.gif)

You can also add substrings to your text. The substrings will inherit the formatting of the parent
text. Thus you can for instance run:

```lua
local text = require("luatext")

local my_str = text
    .Text
    :new()
    :fg(text.Color.Red)
    :append(
      "Hello ",
      text.Text:new("beautiful"):underlined(),
      " world"
    )

print(my_str)
```

Which will produce a fully red string, with only the substring `beautiful` underlined:

![Output from an example with substrings](assets/substrings.gif)

A LuaText object can also be used as a standard string:

```lua
local text = require("luatext")

print("Hello "..text.Text:new("fading"):blink().." world...")
```

Which will print `Hello fading world...` with the word `fading` blinking.

## Reference

For a full reference of the API, see [the reference](/docs/reference.md).

## NO_COLOR

This library supports [`NO_COLOR`](https://no-color.org/).

## Installation

This module is hosted on LuaRocks and can thus be installed via:

```bash
luarocks install luatext
```

Otherwise, since the module is fully self contained, one can also simply copy the `luatext.lua` into
their project.

## ANSI256 Color Codes

To get a list of ANSI color codes run:

```bash
curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/e50a28ec54188d2413518788de6c6367ffcea4f7/print256colours.sh | bash
```

## Development

You can setup a dev environment with the needed Lua version:

```bash
# launch shell with some lua version and the dependencies installed:
nix develop .#lua52
```

and then test with `busted`.
