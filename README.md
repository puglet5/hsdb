# ITMO Heritage Lab DB app (Heritage Science Database)

## Notes on development

### Docker config

Export appropriate database env variables (see config/database.yml)

Install docker, docker-compose and run:

```bash
git clone https://github.com/puglet5/hsdb.git
cd hsdb/
docker-compose build && docker-compose up
```

If you get the following error: `Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock`, execute:
```bash
sudo chmod 666 /var/run/docker.sock
```

---

### TailwindCSS styling

#### Flowbite
Flowbite component library is used (v. 1.4.7) with some modifications to work nicely with Turbo. Apply flowbite.path with `git apply flowbite.patch` to get Flowbite's JavaScript working properly, thought it shall soon be replaced/rewritten with Stimulus.


#### Headwind
If you use VSCode, install Headwind extension and include this in your settings.json file:

```json
"files.associations": {
    "html.erb": "html"
  },
"tailwindCSS.includeLanguages": {
    "erb": "html"
  },
"headwind.classRegex": {
    "html": "\\bclass\\s*=\\s*[\\\"\\']([_a-zA-Z0-9\\s\\-\\:\\/]+)[\\\"\\']",
    "erb": "class[:=]\\s*['\"](.+?)['\"]",
  },
```

Then enable automatic sorting in the settings. This will keep TailwindCSS styles consistent across the project's views.

### Code analysis, linting and formatting

Install [solargraph](https://github.com/castwide/solargraph) and [erb-lint](https://github.com/Shopify/erb-lint). Please don't modify `.solargraph.yml` and `.erb-lint.yml` config files. Also read through [solargraph documentation](https://solargraph.org/) to set it up for working with Rails.

Don't use erb-lint formatting in your code (it is broken for .erb files). Instead use VSCode's formatter provided by official Ruby extension for .rb files and [htmlbeautifier](https://github.com/threedaymonk/htmlbeautifier) for .html.erb files, erb-lint should only provide linting. User VSCode [extension](https://github.com/aliariff/vscode-erb-beautify) for integraion. Default indentation of two spaces is used, it can be configured in the settings.

It is important to configure file associations in your settings.json:
```json
"[erb]": {
  "editor.defaultFormatter": "aliariff.vscode-erb-beautify",
  "editor.formatOnSave": true
},
"files.associations": {
  "*.html.erb": "erb"
}
```

If you use rvm (which is strongly encouraged) and have problems with extensions not being able to find the executable, also include this in your settings.json:

```json
  "vscode-erb-beautify.bundlerPath": "/home/user/.rvm/gems/ruby-3.1.2/wrappers/bundler",
  "vscode-erb-beautify.executePath": "/home/user/.rvm/gems/ruby-3.1.2/wrappers/htmlbeautifier",
  "erb.erb-lint.executePath": "/home/user/.rvm/gems/ruby-3.1.2/wrappers/",

```
