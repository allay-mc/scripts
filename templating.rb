=begin
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

