# Starting with Asset Mapper & Tailwind

[⬅️ Symfony Starter documentation](../README.md)

---

Follow these steps to reproduce the setup from scratch.

## 1. Generate the project

```shell
# Generate a minimalist Symfony application with Docker configuration (LTS - long-term support release)
make minimalist@lts BRANCH=starting/frontend-asset-mapper-tailwind-sf7.4
```

## 2. Install AssetMapper

```shell
make frontend_asset_mapper
```

## 3. Install Tailwind CSS

```shell
make require_tailwind
```

> [!TIP]
>
> `tailwind:init` will ask a couple of questions — the defaults are fine, just press enter.

## 4. Create application files

Create `src/Controller/DefaultController.php`:

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

Create `templates/default/index.html.twig`:

```twig
{% extends 'base.html.twig' %}

{% block body %}
    <div class="min-h-screen bg-slate-100 flex items-center justify-center">
        <div class="max-w-3xl text-center">
            <h1 class="text-5xl font-bold text-blue-600">Hello World</h1>
            <p class="text-xl text-gray-600 mt-4">This page is styled with Tailwind CSS, installed via AssetMapper.</p>
            <button type="button" class="mt-6 px-4 py-2 bg-blue-600 text-white font-semibold rounded hover:bg-blue-700">Tailwind button</button>
        </div>
    </div>
{% endblock %}
```

Save all:

```shell
git add . && git commit -m "Create the application files"
```

## 5. Build and see it running

```shell
# Install and generate all assets
make assets
```

Go to https://symfony-starter.localhost:8442/ — you should see "Hello World" styled with Tailwind CSS.

---

[⬅️ Symfony Starter documentation](../README.md)
