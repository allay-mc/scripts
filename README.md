# Allay Scripts

> [!WARNING]
> The scripts present in this repository are deprecated as of Allay version 0.1.0
> and will likely not work.

Common Allay scripts that can be used for your project. Copy the scripts you
need into your `scripts/` directory of your project or simply use
`allay add <name_of_script>` without its extension and don't forget to include
it in your `allay.toml` configuration file in the right place.

```toml
[scripts]
base-path = "scripts"
pre = [
  { run = "templating.rb", with = "ruby", args = ["--trim-mode='%<>'"] },
  { run = "yaml_to_json.rb", with = "ruby" },
]
post = [
  { run = "autoimport.rb", with = "ruby" },
]
```

You can read more in the [documentation](https://allay-mc.github.io/docs/scripts/index.html).

Each script contains a concise description at the top of the file.

Script             | Exists | Description                                                              | License                                                     | Author <!-- full name or username with optional link to homepage or profile -->
-------------------|--------|--------------------------------------------------------------------------|-------------------------------------------------------------|--------------------------------------------------------------------------------
`transformjson.rb` | ✅     | Transform JSON in order to make it human readable or reduce file size.     | [Unlicense](https://choosealicense.com/licenses/unlicense/) | [phoenixr-codes](https://github.com/phoenixr-codes)
`templating.rb`    | ✅     | Enables [ERB](https://github.com/ruby/erb) for your files                | [Unlicense](https://choosealicense.com/licenses/unlicense/) | [phoenixr-codes](https://github.com/phoenixr-codes)
`yaml_to_json.rb`  | ✅     | Converts [YAML](https://yaml.org/) to JSON                               | [Unlicense](https://choosealicense.com/licenses/unlicense/) | [phoenixr-codes](https://github.com/phoenixr-codes)
`autoimport.rb`    | ❌     | Copies the build into the corresponding Minecraft add-on folder          | [Unlicense](https://choosealicense.com/licenses/unlicense/) | [phoenixr-codes](https://github.com/phoenixr-codes)


## Requirements

In order to use these scripts in your Allay project,
[Ruby](https://www.ruby-lang.org/) needs to be installed on your system.

