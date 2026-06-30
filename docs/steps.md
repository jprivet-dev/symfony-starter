# How this project was initialized

[⬅️ Project documentation](README.md)

---

## 1. Clone the Symfony Starter and generate the reproducer

```shell
git clone git@github.com:jprivet-dev/symfony-starter.git
cd symfony-starter
make reproducer@6x BRANCH=reproducer/gotenberg-bundle/sf6.4
```

## 2. Install dependencies

> [!IMPORTANT]
>
> Install `symfony/http-client` **before** `sensiolabs/gotenberg-bundle` to avoid a `cache:clear`
> error: the bundle's Flex recipe configures a scoped HTTP client, which requires the component
> to be present.

```shell
# in /symfony-starter
make require_co a=symfony/http-client
make require_co a=sensiolabs/gotenberg-bundle
```

> [!NOTE]
>
> The Flex recipe automatically adds a `gotenberg` Docker service to `compose.yaml`, exposes
> its port in `compose.override.yaml`, and sets `GOTENBERG_DSN` in `.env`. Restart the stack
> to start the new service:

```shell
# in /symfony-starter
make restart
```

```shell
# in /symfony-starter
make require_asset_mapper
make require_bootstrap
```

## 3. Application code and custom Makefile commands

The following files were added to the reproducer:

* [.make/_gotenberg.mk](../.make/_gotenberg.mk) — `gotenberg_*` and `dagger_*` Makefile commands
* [assets/files/embeds.xml](../assets/files/embeds.xml) — sample embedded file
* [src/Controller/HomeController.php](../src/Controller/HomeController.php) — PDF generation examples
* [templates/home/index.html.twig](../templates/home/index.html.twig) — homepage with links to each example
* [templates/pdf/content.html.twig](../templates/pdf/content.html.twig), [footer.html.twig](../templates/pdf/footer.html.twig) and [svg.html.twig](../templates/pdf/svg.html.twig) — PDF templates

Bootstrap was also added to [templates/base.html.twig](../templates/base.html.twig):

```twig
{%- block stylesheets -%}
    <link href="{{ asset('vendor/bootstrap/dist/css/bootstrap.min.css') }}" rel="stylesheet"/>
{%- endblock -%}
```

## 4. Clone the fork

```shell
git clone https://github.com/jprivet-dev/GotenbergBundle ../GotenbergBundle
```

Or update an existing fork:

```shell
# in /GotenbergBundle
git pull --rebase upstream 1.x
```

## 5. Add the Docker volume, register the path repository and link the local version

```shell
# in /symfony-starter
make repo_volume d=GotenbergBundle
make repo_add d=GotenbergBundle
make require_co a="sensiolabs/gotenberg-bundle:1.x-dev"
```

> [!TIP]
>
> Composer expects a version following the `[branch-name]-dev` pattern. If your local branch is
> named `main`, use `main-dev`; if it's `1.x`, use `1.x-dev`.

## 6. Install the external dependencies used during the tests

```shell
# in /symfony-starter
make repo_install d=GotenbergBundle
```

## 7. Run the tests for the first time to verify everything is working

```shell
# in /symfony-starter
make repo_tests d=GotenbergBundle
```

```
OK (1069 tests, 2183 assertions)
```

```shell
# in /symfony-starter
make repo_coverage d=GotenbergBundle
```

## 8. Install Dagger

Install [Dagger](https://docs.dagger.io/install) on the host machine:

```shell
curl -fsSL https://dl.dagger.io/dagger/install.sh | sudo BIN_DIR=/usr/local/bin sh
dagger version
```

Initialize the Dagger module, then run all checks:

```shell
# in /symfony-starter
make dagger_develop
make dagger_all
```

> [!TIP]
>
> Run `make` to discover all available `gotenberg_*` and `dagger_*` commands.

## 9. Revert: remove the path repository and restore the published package

```shell
# in /symfony-starter
make repo_remove d=GotenbergBundle
make update a=sensiolabs/gotenberg-bundle
```

---

[⬅️ Project documentation](README.md)
