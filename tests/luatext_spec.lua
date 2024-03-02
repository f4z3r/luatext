local string = require("string")
local text = require("luatext")

local ESCAPE = string.char(27).."["
local RESET = ESCAPE .. "0m"
local FG_PREFIX = ESCAPE .. "38;5;"
local BG_PREFIX = ESCAPE .. "48;5;"

context("Given simple texts,", function()
  local simple = nil
  before_each(function()
    simple = text:new("hello world")
  end)

  describe("when they are unformatted, they", function()
    it("should escape their formating", function()
      assert.are.equal(RESET .. "hello world" .. RESET, simple:render())
    end)
  end)

  describe("when they their text is modified, they", function()
    before_each(function()
      simple:text("hello world!!")
    end)

    it("should return the new text, escaped", function()
      assert.are.equal(RESET .. "hello world!!" .. RESET, simple:render())
    end)
  end)
end)

context("Given colored texts,", function()
  local red = nil
  local blue = nil
  before_each(function()
    red = text:new("red")
    blue = text:new("blue")
  end)

  describe("when they are rendered with a foreground color, they", function()
    before_each(function()
      red:fg(160)
      blue:fg(20)
    end)
    it("should provide their color escape", function()
      assert.are.equal(RESET .. FG_PREFIX .. tostring(160) .. "m" .. "red" .. RESET, red:render())
      assert.are.equal(RESET .. FG_PREFIX .. tostring(20) .. "m" .. "blue" .. RESET, blue:render())
    end)
  end)

  describe("when they are rendered with a background color, they", function()
    before_each(function()
      red:bg(160)
      blue:bg(20)
    end)
    it("should provide their color escape", function()
      assert.are.equal(RESET .. BG_PREFIX .. tostring(160) .. "m" .. "red" .. RESET, red:render())
      assert.are.equal(RESET .. BG_PREFIX .. tostring(20) .. "m" .. "blue" .. RESET, blue:render())
    end)
  end)

  describe("when they are rendered with both fg and bg colors, they", function()
    before_each(function()
      red:fg(160):bg(160)
      blue:fg(20):bg(20)
    end)
    it("should provide their color escape", function()
      assert.is_true(
        string.find(red:render(), BG_PREFIX .. tostring(160) .. "m", nil, true) < string.find(red:render(), "red")
      )
      assert.is_true(
        string.find(red:render(), FG_PREFIX .. tostring(160) .. "m", nil, true) < string.find(red:render(), "red")
      )
      assert.is_true(
        string.find(blue:render(), BG_PREFIX .. tostring(20) .. "m", nil, true) < string.find(blue:render(), "blue")
      )
      assert.is_true(
        string.find(blue:render(), FG_PREFIX .. tostring(20) .. "m", nil, true) < string.find(blue:render(), "blue")
      )
    end)
  end)

  describe("when they are rendered modifiers, they", function()
    before_each(function()
      red:bold()
      blue:dim()
    end)
    it("should provide the modifier's escape", function()
      assert.is_true(
        string.find(red:render(), ESCAPE .. tostring(1) .. "m", nil, true) < string.find(red:render(), "red")
      )
      assert.is_true(
        string.find(blue:render(), ESCAPE .. tostring(2) .. "m", nil, true) < string.find(blue:render(), "blue")
      )
    end)
  end)
end)
