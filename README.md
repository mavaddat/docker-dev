<div align="center">
  <img src="docs/logo.jpg" alt="LAMP LDE" style="width:100%" />
  <p></p>
  <h1>LAMP Local Development Environment on Docker</h1>
  <p></p>
  <p align="center">
    <a href="#-intro"><b>What is this?</b></a>
    &nbsp;&nbsp;&mdash;&nbsp;&nbsp;
    <a href="#installation-"><b>Installation</b></a>
    &nbsp;&nbsp;&mdash;&nbsp;&nbsp;
    <a href="#common-commands-"><b>Usage</b></a>
    &nbsp;&nbsp;&mdash;&nbsp;&nbsp;
    <a href="#further-reading"><b>Docs</b></a>
  </p>
  <br />
</div>

__An everyday local development environment for PHP Developers.__ At [Pivotal Agency](https://www.pivotalagency.com.au/), we've done a _buuunnnch_ of R&D to find the best local dev tools for our team. This is the result of our hard work. This tool has been put to its paces everyday by our team, we hope it can also help yours.


## Intro 👋

This is a set of Docker images to spin up a LAMP stack (Linux, Apache, MySQL and PHP) for developing locally. It's perfect for local development because you can very simply add new sites to specified directory and they're magically accessible as a subdomain of your chosen hostname (eg. `~/Projects/example` maps to `http://example.localhost/`).

It includes all the required dependencies for everyday PHP development with common tools like Laravel, Wordpress and Magento (1 & 2). Specifically:

**Default Services**

- Apache (including HTTPS)
- PHP 8.2
    - Composer (latest)
    - Node.js (latest LTS) & NPM (latest)*
    - Yarn (latest of 1.x)*
    - PHPCS (with Wordpress code standards added)*
    - Wordpress CLI*
    - ZSH*
- Mailpit
- MariaDB 10.3

<p><i>* Available in latest PHP container</i></p>

**Optional Services**

- PHP 5.6, all 7.x and all 8.x
- Memcached 1.x
- Redis 7.x
- [Blackfire](https://blackfire.io/) (latest)

These optional services (eg. PHP 5.6, PHP 7.4) can be added in the `.env` file by appending them to the `COMPOSE_FILE` option. See `.env` for an example.


## Prerequisites ⚠️

You'll need to install a modern version of Docker Desktop (or Docker on Linux).


## Domain Mapping 🗺

You can tell Docker Dev which version of PHP to use or whether it should load code from a "public" folder (required for Laravel, WordPress Bedrock and Magento) simply by adjusting your project's URL.

It's assumed that all of your projects are stored as folders in `~/Projects/`. You can use a different folder by changing the `DOCUMENTROOT` variable in your `.env` file.

Here is the the simplest form of domain mapping:

- `https://<folder>.localhost` will use the latest version of PHP and load the code from `~/Projects/<folder>/`

Please note that PHP is upgraded yearly. If you want to use a specific version of PHP, you can specify it in the URL:

* `https://<folder>.php82.localhost` will use PHP 8.2

Or, if you want the code loaded from the "public" folder:

* `https://<folder>.pub.localhost` will use latest version of PHP and load the code from `~/Projects/<folder>/public/`

Lastly, you can combine the two:

* `https://<folder>.php82.pub.localhost` will use PHP 8.2 and load the code from `~/Projects/<folder>/public/`

Some frameworks use a different public folder name (eg. [Wordpress Bedrock](https://roots.io/bedrock/) uses "web"). In these instances we recommend adding a symlink to the public folder:

```bash
cd ~/Projects/<folder>/
ln -s web public
```


## Installation 🚀

> Windows Users: The Docker Dev containers perform best while running inside WSL2. We'll assume you will run these commands in a WSL2 terminal (eg. Ubuntu LTS).

1. Open a terminal window
2. Create a new folder for your projects
```
mkdir ~/Projects
cd ~/Projects
```
**Note**: The `~/` alias points to your home folder (eg. `/home/USERNAME/`)

3. Clone this repo into your projects folder
```
git clone git@github.com:pvtl/docker-dev.git
cd docker-dev
```
4. Copy `.env.example` to `.env` and set the `DOCUMENTROOT` to your projects folder (eg. `/home/USERNAME/Projects/`)
5. Build and start the Docker containers:
```
docker compose up -d
```

For ease of use we recommend you also set up the [Daily Shortcuts](https://github.com/pvtl/docker-dev/#daily-shortcuts-%EF%B8%8F).

You can test if your Docker Dev environment is working correctly using a simple PHP info file.

1. Create the folder and file: `/home/USERNAME/Projects/test/index.php`
1. Edit the file and paste `<?php phpinfo();`
1. In your browser, open https://test.localhost. You should see the PHP info page.


## Updating 🔄

To install the latest versions of all tools (eg. PHP, Redis, Node.js etc.), open a terminal window, browse to the `docker-dev` folder and run:

```bash
# 1. Fetch our latest updates
git pull

# 2. Erase previous containers. Your project files and DB's will be left as-is.
docker compose down --remove-orphans

# 3. Get latest images from Docker Hub
docker compose pull

# 4. Rebuild Dockerfiles from scratch (inc. pull any parent images)
docker compose build --pull --no-cache --parallel

# 5. Start the updated environment
docker compose up -d --remove-orphans

# 6. Erase any unused containers, images, volumes etc. to free disk space.
docker system prune --volumes
```


## Common Commands 🔥

Docker must be running and these commands must be run from the Docker Dev folder (eg. `/home/USERNAME/Projects/docker-dev`).

Most of these actions can also be done in the Docker Desktop app.

| Command | Description |
|---|---|
| `docker compose start` | Start all containers |
| `docker compose stop`  | Stop all containers (keeps any config changes you've made to the containers) |
| `docker compose up -d --build --no-cache` | Recreate all containers from scratch |
| `docker compose down`  | Tear down all containers (MySQL data and project folders are kept) |
| `docker compose exec php82-fpm zsh`  | Open a zsh terminal in the PHP 8.2 container |
| `docker compose logs php82-fpm` | View all logs for PHP-FPM 8.2 |
| `docker compose ps` | Show which containers are running |


## Daily Shortcuts ⚡️

While the above commands work, they're a bit tedious to type out on a daily basis. You can set up terminal aliases to make life easier.

If you use ZSH, edit `~/.zshrc`. Otherwise edit `~/.bashrc`. Create the file if it doesn't exist.

1. Paste the code (below) at the bottom of the file. Adjust your folder path to suit.
1. Close and re-open your terminal to apply the changes
1. Try running `devup` or `devdown`

```
# Usage: "devup" or "devdown"
alias devup='(cd /home/USERNAME/Projects/docker-dev && docker compose start)'
alias devdown='(cd /home/USERNAME/Projects/docker-dev && docker compose stop)'

# Usage (for PHP 8.2): "devin 82"
# Simply change the numbers for your preferred PHP version (assuming it's installed/enabled)
devin() {
  docker exec -it php$1 bash
}
```


## Further Reading

- 🚥 [Connections](docs/connections.md)
    - [Email](docs/connections.md#Email)
    - [MySQL](docs/connections.md#MySQL)
    - [Redis](docs/connections.md#Redis)
    - [Memcached](docs/connections.md#Memcached)
    - [XDebug](docs/xdebug.md)
- ❓ [FAQs](docs/faqs.md)
    - [localhost isn't working](docs/faqs.md)
    - [Running additional commands inside the container during build](docs/faqs.md#how-do-i-run-additional-commands-inside-the-container-during-build)
    - [Crons](docs/faqs.md#how-do-i-setuprun-crons)
    - [BrowserSync](docs/faqs.md#how-do-i-get-browsersync-working-from-inside-a-container)
    - [CURL requests from/to LDE sites](docs/faqs.md#curl-requests-from-an-lde-site-to-another-lde-site)
    - [HTTPS](docs/faqs.md#how-do-i-use-httpsssl-for-my-local-containers)
    - [BlackFire](docs/faqs.md#how-do-i-use-blackfire)
    - [Mapping a Custom Hostname to a local site](docs/faqs.md#mapping-a-custom-hostname-to-a-local-site)
    - [Changing your MySQL Root password](docs/faqs.md#changing-your-mysql-root-password)
    - [Adding custom PHP configuration](docs/faqs.md#adding-custom-php-configuration)
    - [Using Redis as a session handler](docs/faqs.md#using-redis-as-a-session-handler)
    - [How do I change the 'default' PHP container?](docs/faqs.md#how-do-i-change-the-default-php-container)
    - [Custom domains / Testing OAuth Logins](docs/custom-domains.md)

