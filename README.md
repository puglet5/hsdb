![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/puglet5/hsdb/ci.yml?label=ci&style=flat-square?branch=master)
![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/puglet5/hsdb/codeql-analysis.yml?label=security&style=flat-square?branch=master)
# ITMO Heritage Lab DB app (Heritage Science Database)

## Notes on development

### Locally




### in Docker

#### Services

Stop your local db services, e.g.:
```bash
sudo systemctl stop postgresql redis
```

#### `.env`

You must export the following environment variables before **initial build**:
```bash
PGHOST= # default is "db", defined in docker-compose.yml
PGUSER=
PGPASSWORD= # default is "changeme", defined in docker-compose.yml
REDIS_URL= # should be something like "redis://redis:6379/0",
# redis hostname is also defined in docker-compose.yml
```

Initial build:

```bash
git clone https://github.com/puglet5/hsdb.git
cd hsdb
docker compose build
# creates and seeds the database
docker compose run --rm web bin/rails db:setup
# alternatively, if you don't want to seed the database
docker compose run --rm web bin/rails db:create && bin/rails db:schema:load
```

On successive builds:
```bash
docker compose up --build
```

If you get the following error: `Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock`, execute:
```bash
sudo chmod 666 /var/run/docker.sock
```

### TailwindCSS styling

#### Flowbite
Flowbite component library is used (v. 1.4.7) with some modifications to work nicely with Turbo. Apply flowbite.path with `git apply flowbite.patch` to get Flowbite's JavaScript working properly, thought it shall soon be replaced/rewritten with Stimulus.

_As of now, all of Flowbite's JavaScript used in this app is rewritten with Stimulus._


#### Headwind
If you use VSCode, install Headwind extension and include this in your settings.json file:

```json
"files.associations": {
    "html.erb": "html"
  },
"tailwindCSS.includeLanguages": {
    "erb": "html"
  },
"tailwindCSS.experimental.classRegex": [
    "(?:class|cls)[:=] ['\"](.+?)['\"]",
  ],
"headwind.classRegex": {
    "html": "\\b(?:class|cls)\\s*=\\s*[\\\"\\']([_a-zA-Z0-9\\s\\-\\:\\/]+)[\\\"\\']",
    "erb": "(?:class|cls)[:=]\\s*['\"](.+?)['\"]"
  },
```

Then enable automatic sorting in the settings. This will keep TailwindCSS styles consistent across the project's views and ensure compatability with .erb files and ViewComponents.

### Code analysis, linting and formatting

Install [solargraph](https://github.com/castwide/solargraph) and [erb-lint](https://github.com/Shopify/erb-lint). Don't modify `.solargraph.yml` and `.erb-lint.yml` config files. Also read through [solargraph documentation](https://solargraph.org/) to set it up to work with Rails.

Don't use erb-lint formatting in your code (it is broken for .erb files). Instead use VSCode's formatter provided by official Ruby extension for .rb files and [htmlbeautifier](https://github.com/threedaymonk/htmlbeautifier) for .html.erb files, erb-lint should only provide linting. Use VSCode [extension](https://github.com/aliariff/vscode-erb-beautify) for integraion. Default indentation of two spaces is used, it can be configured in the settings.

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

Use ESLint to lint .js files. `.eslintrc.json` is located in project's root directory.

### Debugging

Install [debug gem](https://github.com/ruby/debug) and [VSCode rdbg Ruby Debugger](https://github.com/ruby/vscode-rdbg). Debug config is located in ```.vscode``` folder. Set breakpoints and choose ```Debug Rails server``` to debug. Multiprocess debugging is not possible, so if you want to debug sidekiq job for example, just run debugger without config and pass launch command for the desired process.

## Testing

### Locally

Create a testing database and run `bundle exec rspec`.

### Github Actions

GH Actions setup includes linters, code checks and RSpec testing. Refer to the `.github/workflows/ci.yml` and `.github/workflows/codeql-analysis.yml` config files.

You can test GH Actions locally by installing [act](https://github.com/nektos/act) (you must provide github token with workflow access to run this). *This doesn't work yet (services like postgres and redis are unsupported)*
