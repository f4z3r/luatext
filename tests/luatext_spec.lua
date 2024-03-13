--# selene: allow(undefined_variable, incorrect_standard_library_use)

local string = require("string")
local text = require("luatext")

local ESCAPE = string.char(27) .. "["
local RESET = ESCAPE .. "0m"
local FG_PREFIX = ESCAPE .. "38;5;"
local BG_PREFIX = ESCAPE .. "48;5;"

context("Given simple texts,", function()
  local simple = nil
  before_each(function()
    simple = text.Text:new("hello world")
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
    red = text.Text:new("red")
    blue = text.Text:new("blue")
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

  describe("when retrieving their original string contents, they", function()
    it("should return the original string", function()
      assert.are.equal("red", red:get_raw_text())
      assert.are.equal("blue", blue:get_raw_text())
    end)

    it("should correctly handle substrings", function()
      local red = text.Text:new("red"):append(" balloon ", text.Text:new("flying"):bg(text.Color.Black))
      assert.are.equal("red balloon flying", red:get_raw_text())
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
      blue:fg({ 0, 0, 255 }):bg({ 0, 0, 255 })
    end)
    it("should provide their color escape", function()
      assert.is_true(string.find(red:render(), "%D48;5;160%D") < string.find(red:render(), "red"))
      assert.is_true(string.find(red:render(), "%D38;5;160%D") < string.find(red:render(), "red"))
      assert.is_true(string.find(blue:render(), "%D48;2;0;0;255%D") < string.find(blue:render(), "blue"))
      assert.is_true(string.find(blue:render(), "%D38;2;0;0;255%D") < string.find(blue:render(), "blue"))
    end)
  end)

  describe("when they are rendered modifiers, they", function()
    before_each(function()
      red:bold()
      blue:dim()
    end)
    it("should provide the modifier's escape", function()
      assert.is_true(string.find(red:render(), "%D1%D") < string.find(red:render(), "red"))
      assert.is_true(string.find(blue:render(), "%D2%D") < string.find(blue:render(), "blue"))
    end)
  end)

  describe("when they are provided with substrings, they", function()
    before_each(function()
      red:append(" car ", text.Text:new("speeding"):bold(), " through town")
    end)
    it("should apply potential modifications only to substrings", function()
      assert.is_true(string.find(red:render(), "%D1%D") < string.find(red:render(), "speeding"))
      assert.is_true(string.find(red:render(), "%D0%D", 7) < string.find(red:render(), "through"))
    end)
  end)
end)
