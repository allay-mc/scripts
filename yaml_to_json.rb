=begin
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
