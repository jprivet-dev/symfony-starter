# 🐳 🎵 Symfony Starter

**Generate a fully Dockerized Symfony application in seconds.**

This project provides a streamlined way to set up a new Symfony application with Docker. Whether you need a minimalist skeleton, a full web application, an API, or an Administration panel, this starter has you covered. It leverages the power of [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker) with a powerful Makefile to manage everything.

## ✨ Available Flavors

You can choose from several pre-configured setups.

<table>
    <thead>
    <tr>
        <th>Flavor & Description</th>
        <th width="300">Preview</th>
    </tr>
    </thead>
    <tbody>
    <tr>
        <td>
            <h3>Minimalist</h3>
            <p>A bare-bones <strong>Symfony skeleton</strong>. Perfect for starting from scratch.</p>
            <ul>
                <li>Doc: <a href="https://symfony.com/doc/current/setup.html">Installing & Setting up the Symfony Framework</a></li>
                <li>
                    <span>Stable version:</span>
                    <ul>
                        <li>Command: <code>make minimalist</code></li>
                        <li>Branch: <a href="https://github.com/jprivet-dev/symfony-starter/tree/minimalist">minimalist</a></li>
                    </ul>
                </li>
                <li>
                    <span>LTS version:</span>
                    <ul>
                        <li>Command: <code>make minimalist@lts</code></li>
                        <li>Branch: <a href="https://github.com/jprivet-dev/symfony-starter/tree/minimalist@lts">minimalist@lts</a></li>
                    </ul>
                </li>
            </ul>
        </td>
        <td>
            <img src="docs/img/minimalist.png" alt="Symfony Minimalist" width="300">
            <img src="docs/img/minimalist-lts.png" alt="Symfony LTS" width="300">
        </td>
    </tr>
    <tr>
        <td>
            <h3>Web App</h3>
            <p><strong>Full stack application</strong> with Twig, AssetMapper, Profiler, etc.</p>
            <ul>
                <li>Doc: <a href="https://symfony.com/doc/current/setup.html">Installing & Setting up the Symfony Framework</a></li>
                <li>
                    <span>Stable version:</span>
                    <ul>
                        <li>Command: <code>make webapp</code></li>
                        <li>Branch: <a href="https://github.com/jprivet-dev/symfony-starter/tree/webapp">webapp</a></li>
                    </ul>
                </li>
                <li>
                    <span>LTS version:</span>
                    <ul>
                        <li>Command: <code>make webapp@lts</code></li>
                        <li>Branch: <a href="https://github.com/jprivet-dev/symfony-starter/tree/webapp@lts">webapp@lts</a></li>
                    </ul>
                </li>
            </ul>
        </td>
        <td align="center"><em>(Same as Minimalist)</em></td>
    </tr>
    <tr>
        <td>
            <h3>API Platform</h3>
            <p>Includes <strong>API Platform</strong> and <strong>PostgreSQL</strong>. Ready for REST/GraphQL.</p>
            <ul>
                <li>Doc: <a href="https://api-platform.com/docs/symfony/">Getting Started With API Platform with Symfony</a></li>
                <li>
                    <span>Stable version:</span>
                    <ul>
                        <li>Not available</li>
                    </ul>
                </li>
                <li>
                    <span>LTS version:</span>
                    <ul>
                        <li>Command: <code>make api@lts</code></li>
                        <li>Branch: <a href="https://github.com/jprivet-dev/symfony-starter/tree/api@lts">api@lts</a></li>
                    </ul>
                </li>
            </ul>
        </td>
        <td><img src="docs/img/api.png" alt="API Platform" width="300"></td>
    </tr>
    <tr>
        <td>
            <h3>EasyAdmin</h3>
            <p>Includes <strong>EasyAdmin</strong> and <strong>PostgreSQL</strong>. The quickest back-office.</p>
            <ul>
                <li>Doc: <a href="https://symfony.com/bundles/EasyAdminBundle/current/index.html">EasyAdmin</a></li>
                <li>
                    <span>Stable version:</span>
                    <ul>
                        <li>Command: <code>make easy_admin</code></li>
                        <li>Branch: <a href="https://github.com/jprivet-dev/symfony-starter/tree/easy_admin">easy_admin</a></li>
                    </ul>
                </li>
                <li>
                    <span>LTS version:</span>
                    <ul>
                        <li>Command: <code>make easy_admin@lts</code></li>
                        <li>Branch: <a href="https://github.com/jprivet-dev/symfony-starter/tree/easy_admin@lts">easy_admin@lts</a></li>
                    </ul>
                </li>
            </ul>
        </td>
        <td><img src="docs/img/easy-admin.png" alt="EasyAdmin" width="300"></td>
    </tr>
    <tr>
        <td>
            <h3>Demo</h3>
            <p>The official <strong>Symfony Demo</strong> application (SQLite). Great for learning.</p>
            <ul>
                <li>Doc: <a href="https://github.com/symfony/demo">Symfony Demo Application</a></li>
                <li>
                    <span>Stable version:</span>
                    <ul>
                        <li>Command: <code>make demo</code></li>
                        <li>Branch: <a href="https://github.com/jprivet-dev/symfony-starter/tree/demo">demo</a></li>
                    </ul>
                </li>
                <li>
                    <span>LTS version:</span>
                    <ul>
                        <li>Not available</li>
                    </ul>
                </li>
            </ul>
        </td>
        <td><img src="docs/img/demo.png" alt="Symfony Demo" width="300"></td>
    </tr>
    </tbody>
</table>

## 🚀 Prerequisites

Be sure to install the latest version of [Docker Engine](https://docs.docker.com/engine/install/).

## 🛠️ Usage

There are two ways to use this starter:

### Method 1: The Generator (Recommended for new projects)

Clone the main repository and generate the application you need on the fly.

#### Step 1. Clone the repository

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git
cd symfony-starter
```

#### Step 2. Generate your application
 
```shell
# Example: Generate a full Web App (Stable)
make webapp

# Example: Generate an API Platform project (LTS)
make api@lts

# Example: Generate a specific Minimalist Version
SYMFONY_VERSION=6.4.3 make minimalist
```

> This will:
> 
> * Clone `dunglas/symfony-docker` configuration files and extract them to your project root.
> * Build the necessary Docker images and start the containers.
> * Generate a fresh Symfony application inside the container.
> * Eventually add extra packages to give you everything you need to build a web application.

#### Step 3. Access the app

Open `https://symfony-starter.localhost:8443/` in your browser and [accept the auto-generated TLS certificate](https://stackoverflow.com/a/15076602/1352334).

> See [Caddy - Validate certificates](docs/certificates.md)

### Method 2: The Snapshot (Fastest start)

If you just want to test a specific configuration immediately without waiting for the generation process, checkout the specific branch.

#### Step 1. Clone and checkout

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git
cd symfony-starter

# Switch to the desired flavor
git checkout webapp
```

#### Step 2. Install and Start

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

Everything is managed via `make`. For example:

```shell
make start    # Start the project (detached mode) and show info
make stop     # Stop the project and remove containers
```

> Just run `make` in your terminal or see directly the [Makefile documentation](docs/makefile.md) for the full list of commands.

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

## 🔗 Main links

* https://symfony.com/doc/current/setup/docker.html
* https://github.com/dunglas/symfony-docker
* https://github.com/jprivet-dev/symfony-docker

## 📝 Comments, suggestions?

Feel free to make comments/suggestions to me in the [Git issues section](https://github.com/jprivet-dev/symfony-starter/issues).

## 🤝 Credits & License

* Based on [dunglas/symfony-docker](https://github.com/dunglas/symfony-docker).
* This project is released under the [**MIT License**](https://github.com/jprivet-dev/symfony-starter/blob/main/LICENSE).

