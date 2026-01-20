-- tools/pdf-filter.lua
-- Excludes any section whose header contains the marker: <!-- pdf-exclude -->
-- Drops the header and all blocks until the next header of the same or higher level.

local skipping_level = nil

local function header_has_marker(header)
  -- Pandoc parses HTML comments into RawInline("html", "<!-- ... -->") in many cases
  for _, inline in ipairs(header.content) do
    if inline.t == "RawInline" and inline.format == "html" then
      if inline.text:match("pdf%-exclude") then
        return true
      end
    end
    -- Fallback: sometimes the marker can appear in plain text depending on parser/version
    if inline.t == "Str" and inline.text:match("pdf%-exclude") then
      return true
    end
  end
  return false
end

function Block(el)
  -- If we're currently skipping a section:
  if skipping_level ~= nil then
    -- Stop skipping when we hit a header of same or higher level
    if el.t == "Header" and el.level <= skipping_level then
      skipping_level = nil
      -- fall through and process this header normally
    else
      return {} -- drop everything while skipping
    end
  end

  -- Start skipping if this header has the marker
  if el.t == "Header" and header_has_marker(el) then
    skipping_level = el.level
    return {} -- drop the header itself
  end

  return nil
end
