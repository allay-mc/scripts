=begin
-------------------------------------------------------------------------------

This script transforms JSON files by inserting spaces at possible places. This
script is mainly used to make generated JSON files more human readable or
removing all unnecessary spaces to reduce the total file size.


# Additional Options

- `--indent=AMOUNT` --- indent level by this amount of spaces (default: 2
  spaces)
- `--after-colon=AMOUNT` --- amount of spaces inserted after each colon (`:`)
  (default: 1 space)
- `--before-colon=AMOUNT` --- amount of spaces inserted after each colon
  (`:`) (default: none)
- `--array-indent` --- amount of newlines used to indent arrays (default: 1
  newline)
- `--object-indent` --- amount of newlines used to indent objects (default: 1
  newline)

Leaving all options will generate human readable format by default.


# Examples

This script is usually put in the far end of pre scripts. Transform into
minimum file size.

```toml
[scripts]
# ...
pre = [
  # ...
  {
    run = "transformjson.rb",
    with = "ruby",
    args = [
      "--indent=0",
      "--before-colon=0",
      "--after-colon=0",
      "--array-indent=0",
      "--object-indent=0",
    ]
  }
]
```

-------------------------------------------------------------------------------
=end

require 'json'
require 'optparse'
require 'pathname'

BP = Pathname.new(ENV['ALLAY_BP_PATH'])
RP = Pathname.new(ENV['ALLAY_RP_PATH'])
SP = Pathname.new(ENV['ALLAY_SP_PATH'])
WT = Pathname.new(ENV['ALLAY_WT_PATH'])

options = {
  :indent => " " * 2,
  :space => " ",
  :space_before => "",
  :array_nl => "\n",
  :object_nl => "\n",
}
OptionParser.new do |opts|
  opts.on "--indent=AMOUNT" do |a|
    options[:indent] = " " * Integer(a)
  end

  opts.on "--after-colon=AMOUNT" do |a|
    options[:space] = " " * Integer(a)
  end

  opts.on "--before-colon=AMOUNT" do |a|
    options[:space_before] = " " * Integer(a)
  end

  opts.on "--array-indent=AMOUNT" do |a|
    options[:array_nl] = "\n" * Integer(a)
  end

  opts.on "--object-indent" do |a|
    options[:object_nl] = "\n" * Integer(a)
  end
end.parse!

[BP, RP, SP, WT].each do |path|
  path.glob "**/*.json" do |json_file|
    next if json_file.directory?
    json_data = JSON.load_file json_file
    transformed = JSON.generate(json_data, options)
    json_file.open('w') do |f|
      json_file.write(transformed)
    end
  end
end
