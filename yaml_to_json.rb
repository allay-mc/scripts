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

Converts [YAML](https://yaml.org/) files into JSON files.


# Example

```yaml
format_version: "1.19.50"
"minecraft:camera_preset":
  identifier: "example:custom"
  inherit_from: "minecraft:free"
  pos_x: 30
  pos_y: 90
  pos_z: -20
  rot_x: 10
  rot_y: 40
```

The above would be converted into this:

```json
{"format_version":"1.19.50","minecraft:camera_preset":{"identifier":"example:custom","inherit_from":"minecraft:free","pos_x": 30,"pos_y":90,"pos_z":-20,"rot_x":10,"rot_y":40}}
```

-------------------------------------------------------------------------------
=end

# TODO: support `.yml` files

require 'json'
require 'pathname'
require 'yaml'

BP = Pathname::new(ENV.fetch('ALLAY_BP_PATH'))
RP = Pathname::new(ENV.fetch('ALLAY_RP_PATH'))
SP = Pathname::new(ENV.fetch('ALLAY_SP_PATH'))
WT = Pathname::new(ENV.fetch('ALLAY_WT_PATH'))

[BP, RP, SP, WT].each do |path|
  path.glob('**/*.yaml').each do |yaml_file|
    json_data = YAML.load_file(yaml_file).to_json
    json_file = yaml_file.parent + "#{yaml_file.basename('.*')}.json"
    json_file.write(json_data)
    yaml_file.unlink()
  end
end
