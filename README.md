# 🐳 🎵 Symfony Starter

**Generate a fully Dockerized Symfony application in seconds.**

This project provides a streamlined way to set up a new Symfony application with Docker. Whether you need a minimalist skeleton, a full web application, an API, or an Administration panel, this starter has you covered. It leverages the power of [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker) with a powerful Makefile to manage everything.

## ✨ Available Flavors

You can choose from several pre-configured setups.

<table>
  <thead>
    <tr>
      <th width="100">Flavor</th>
      <th width="250">Preview</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center"><strong>Minimalist</strong></td>
      <td>
        <img src="docs/img/minimalist.png" alt="Symfony Minimalist" width="250">
        <img src="docs/img/minimalist-lts.png" alt="Symfony LTS" width="250">
      </td>
      <td>
        A bare-bones Symfony 7 skeleton. Perfect for starting from scratch.
        <ul>
          <li>Command: <code>make minimalist</code> <code>make minimalist@lts</code></li>
          <li>Branch: <a href="https://github.com/jprivet-dev/symfony-starter/tree/minimalist">minimalist</a></li>
          <li>Branch: <a href="https://github.com/jprivet-dev/symfony-starter/tree/minimalist@lts">minimalist@lts</a></li>
        </ul>
      </td>
    </tr>
    <tr>
      <td align="center"><strong>Web App</strong></td>
      <td align="center"><em>(Same as Minimalist)</em></td>
      <td>
        Full stack application with Twig, AssetMapper, Profiler, etc.
        <ul>
          <li>Command: <code>make webapp</code> <code>make webapp@lts</code></li>
          <li>Branch: <a href="https://github.com/jprivet-dev/symfony-starter/tree/webapp">webapp</a></li>
          <li>Branch: <a href="https://github.com/jprivet-dev/symfony-starter/tree/webapp@lts">webapp@lts</a></li>
        </ul>
      </td>
    </tr>
    <tr>
      <td align="center"><strong>API Platform</strong></td>
      <td><img src="docs/img/api.png" alt="API Platform" width="250"></td>
      <td>
        Includes <strong>API Platform</strong> and <strong>PostgreSQL</strong>. Ready for REST/GraphQL.
        <ul>
          <li>Command: <code>make api@lts</code></li>
          <li>Branch: <a href="https://github.com/jprivet-dev/symfony-starter/tree/api@lts">api@lts</a></li>
        </ul>
      </td>
    </tr>
    <tr>
      <td align="center"><strong>EasyAdmin</strong></td>
      <td><img src="docs/img/easy-admin.png" alt="EasyAdmin" width="250"></td>
      <td>
        Includes <strong>EasyAdmin</strong> and <strong>PostgreSQL</strong>. The quickest back-office.
        <ul>
          <li>Command: <code>make easy_admin</code> <code>make easy_admin@lts</code></li>
          <li>Branch: <a href="https://github.com/jprivet-dev/symfony-starter/tree/easy_admin">easy_admin</a></li>
          <li>Branch: <a href="https://github.com/jprivet-dev/symfony-starter/tree/easy_admin@lts">easy_admin@lts</a></li>
        </ul>
      </td>
    </tr>
    <tr>
      <td align="center"><strong>Demo</strong></td>
      <td><img src="docs/img/demo.png" alt="Symfony Demo" width="250"></td>
      <td>
        The official <strong>Symfony Demo</strong> application (SQLite). Great for learning.
        <ul>
          <li>Command: <code>make demo</code></li>
          <li>Branch: <a href="https://github.com/jprivet-dev/symfony-starter/tree/demo">demo</a></li>
        </ul>
      </td>
    </tr>
  </tbody>
</table>

> **Note:** To use an LTS version on other flavors (e.g., API), simply append `@lts` (e.g., `make api@lts`).
## 🚀 Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## 🛠️ Usage

There are two ways to use this starter:

### Method 1: The Generator (Recommended for new projects)

Clone the main repository and generate the application you need on the fly.

1. **Clone the repository:**
```shell
git clone git@github.com:jprivet-dev/symfony-starter.git my-project
cd my-project
```


2. **Generate your application:**
```shell
# Example: Generate a full Web App (Stable)
make webapp

# Example: Generate an API Platform project (LTS)
make api@lts

# Example: Generate a specific Minimalist Version
SYMFONY_VERSION=6.4.3 make minimalist
```

This will:

* Clone `dunglas/symfony-docker` configuration files and extract them to your project root.
* Build the necessary Docker images and start the containers.
* Generate a fresh Symfony application inside the container.
* Eventually add extra packages to give you everything you need to build a web application.

3. **Access the app:**
 Open `https://symfony-starter.localhost:8443/` in your browser and [accept the auto-generated TLS certificate](https://stackoverflow.com/a/15076602/1352334).

> See [Caddy - Validate certificates](docs/certificates.md)

### Method 2: The Snapshot (Fastest start)

If you just want to test a specific configuration immediately without waiting for the generation process, checkout the specific branch.

1. **Clone and checkout:**
```shell
git clone git@github.com:jprivet-dev/symfony-starter.git my-project
cd my-project

# Switch to the desired flavor
git checkout webapp
```

2. **Install and Start:**
```shell
make install
```

## 🔄 Switching Flavors & Cleanup

You can easily switch between flavors or restart from scratch using the cleanup command. This will **delete** the current Symfony application and Docker configuration to allow a fresh generation.

```shell
# 1. Nuke the current setup (Containers, Volumes, Source code)
make kill_current_app

# 2. Generate a different flavor
make easy_admin
```

## 🎮 Daily Commands

Everything is managed via `make`. Run `make` without arguments to see the beautiful help menu.

```shell
make start    # Start the project (detached mode) and show info
make stop     # Stop the project and remove containers
```

> Run `make` in your terminal or see directly the [Makefile documentation](docs/makefile.md) for the full list of commands.

## 🏗️ Project Structure

After `make minimalist`, your project structure will look like this (Minimalist Stable Release):

```
./
├── bin/                 (*)
├── config/              (*)
├── docs/
├── frankenphp/          (*)
├── public/              (*)
├── src/                 (*)
├── var/                 (*)
├── vendor/              (*)
├── compose.override.yaml(*)
├── compose.prod.yaml    (*)
├── composer.json        (*)
├── composer.lock        (*)
├── compose.yaml         (*)
├── Dockerfile           (*)
├── LICENSE
├── Makefile
├── README.md
└── symfony.lock         (*)
```

**(\*)** Indicates files/directories generated or copied from `dunglas/symfony-docker` or `symfony/skeleton`.

To visualize your structure (requires `tree` command):

```shell
tree -A -L 1 -F --dirsfirst
```

## 📚 Documentation

* [ADR](docs/adr.md)
* [Caddy - Validate certificates](docs/certificates.md)
* [Compose - Accessing the `var/` directory](docs/var.md)
* [Makefile - Discover all commands](docs/makefile.md)
* [PHP - Quality](docs/quality.md)
* [PHP - Testing](docs/testing.md)
* [PhpStorm - Configure a remote PHP interpreter (Docker)](docs/remote-php-interpreter.md)
* [PhpStorm - Connect it to the running PostgreSQL container](docs/postgre.md)
* [Symfony - Save your generated application](docs/save.md)
* [Symfony and Docker - Use build options](docs/options.md)
* [Troubleshooting](docs/troubleshooting.md)

## Main links

* https://symfony.com/doc/current/setup/docker.html
* https://github.com/dunglas/symfony-docker
* https://github.com/jprivet-dev/symfony-docker

## Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-starter/issues).

## 🤝 Credits & License

* Based on [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker).
* This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter/blob/main/LICENSE).

