# Starting with Asset Mapper & Bootstrap

[⬅️ Symfony Starter documentation](../README.md)

---

Follow these steps to reproduce the setup from scratch.

## 1. Generate the project

```shell
# Generate a minimalist Symfony application with Docker configuration (LTS - long-term support release)
make minimalist@lts BRANCH=starting/frontend-asset-mapper-bootstrap-sf7.4
```

## 2. Install AssetMapper

```shell
make frontend_asset_mapper
```

## 3. Install Bootstrap

```shell
make require_bootstrap
```

## 4. Configure `app.js`

> [!IMPORTANT]
>
> `importmap:require bootstrap` only registers the package in `importmap.php` — it doesn't load it.

Add it to `assets/app.js`:

```js
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap';
import './styles/app.css';
```

And save all:

```shell
git add . && git commit -m "Configure app.js to load Bootstrap"
```

## 5. Create application files

`src/Controller/DefaultController.php`:

```php
<?php

namespace App\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;

class DefaultController extends AbstractController
{
    #[Route('/', name: 'app_home')]
    public function index(): Response
    {
        return $this->render('default/index.html.twig');
    }
}
```

`templates/default/index.html.twig`:

```twig
{% extends 'base.html.twig' %}

{% block body %}
    <div class="container py-5">
        <h1 class="display-4 fw-bold text-primary">Hello World</h1>
        <p class="lead text-secondary">This page is styled with Bootstrap, installed via AssetMapper.</p>
        <button type="button" class="btn btn-primary">Bootstrap button</button>
    </div>
{% endblock %}
```

And save all:

```shell
git add . && git commit -m "Create the application files"
```

## 6. Build and verify

```shell
# Install and generate all assets
make assets
```

Go to https://symfony-starter.localhost:8442/ — you should see "Hello World" styled with Bootstrap.

---

[⬅️ Symfony Starter documentation](../README.md)
