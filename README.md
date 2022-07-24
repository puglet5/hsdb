## ITMO Heritage Lab DB app (Heritage Science Database)

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


### Headwind
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
