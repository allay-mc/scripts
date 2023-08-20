=begin
-------------------------------------------------------------------------------

This is free and unencumbered software released into the public domain.

Anyone is free to copy, modify, publish, use, compile, sell, or
distribute this software, either in source code form or as a compiled
binary, for any purpose, commercial or non-commercial, and by any
means.

In jurisdictions that recognize copyright laws, the author or authors
of this software dedicate any and all copyright interest in the
software to the public domain. We make this dedication for the benefit
of the public at large and to the detriment of our heirs and
successors. We intend this dedication to be an overt act of
relinquishment in perpetuity of all present and future rights to this
software under copyright law.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

For more information, please refer to <https://unlicense.org>

-------------------------------------------------------------------------------

This script allows you to use [ERB](https://github.com/ruby/erb) within in your
project.


# Example

```erb
%# using erb
% 8.times do |i|
scoreboard objectives add score<%= i %> dummy
% end
```

The above would generate the following with `--trim-mode` set to `%<>` and
`--indicator` set to `%# using erb`:

```mcfunction
scoreboard objectives add score0 dummy
scoreboard objectives add score1 dummy
scoreboard objectives add score2 dummy
scoreboard objectives add score3 dummy
scoreboard objectives add score4 dummy
scoreboard objectives add score5 dummy
scoreboard objectives add score6 dummy
scoreboard objectives add score7 dummy
```


# Additional Options

- `--trim-mode=MODE` --- adjust the text generation (default: *none*)
  - `%` --- enables Ruby code processing for lines beginning with `%`
  - `<>` --- omit newline for lines starting with `<%` and ending in
    `%>`
  - `>` --- omit newline for lines ending in `%>`
  - `-` --- omit blank lines ending in `-%>`
- `--indicator=INDICATOR` --- the first line must match this to be rendered
  which is usually an ERB comment to exclude that indicator from the result
  as well (default: `<%# using erb %>`)

-------------------------------------------------------------------------------
=end

require 'erb'
require 'optparse'
require 'pathname'

BP = Pathname.new(ENV.fetch('ALLAY_BP_PATH'))
RP = Pathname.new(ENV.fetch('ALLAY_RP_PATH'))
SP = Pathname.new(ENV.fetch('ALLAY_SP_PATH'))
WT = Pathname.new(ENV.fetch('ALLAY_WT_PATH'))

options = {
  :trim_mode => nil,
  :indicator => "<%# using erb %>"
}
OptionParser.new do |opts|
  opts.on "--trim-mode=MODE" do |m|
    options[:trim_mode] = m
  end
  opts.on "--indicator=INDICATOR" do |i|
    options[:indicator] = i
  end
end.parse!

[BP, RP, SP, WT].each do |path|
  path.glob("**/*").each do |file|
    next if file.directory?
    file.open('r+') do |f|
      content = f.read
      next if content.each_line.count == 0
      next if content.each_line.first.chomp != options[:indicator] 
      tpl = ERB.new(content, trim_mode: options[:trim_mode])
      res = tpl.result
      f.seek(0, IO::SEEK_SET)
      f.write(res)
    end
    next
  end
end

