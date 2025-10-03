# PHPStan

[⬅️ Quality](../quality.md)

---

## About

PHPStan scans your whole codebase and looks for both obvious & tricky bugs.

## Installation

PHPStan - PHP Static Analysis Tool:

```
composer require --dev phpstan/phpstan
```

PHPStan Symfony Framework extensions and rules:

```
composer require --dev phpstan/phpstan-symfony
```

Doctrine extensions for PHPStan:

```
composer require --dev phpstan/phpstan-doctrine
```

PHPStan PHPUnit extensions and rules:

```
composer require --dev phpstan/phpstan-phpunit
```

## Configure PhpStorm

> Prerequisite : [Configure a remote PHP interpreter (Docker)](../remote-php-interpreter.md)

* Go on **Settings (Ctrl+Alt+S) > PHP > Quality Tools**.
* Expand the **PHPStan** area and switch `ON` the tool.
* In **Configuration**, choose `symfony-starter-app-php:latest`.
* In **Options** area:
    * Level: `8`.
    * Configuration file: choose the `phpstan.dist.neon` file of this repository.
* In the **Settings** dialog, click on `OK` or `Apply` to validate all.

### !!! TROUBLESHOOTING !!!

Works fine with the command line, but not in PhpStorm :

```
PHP Warning:  file_get_contents(/opt/project/vendor/phpstan/phpstan/../../../var/cache/dev/App_KernelDevDebugContainer.xml): Failed to open stream: No such file or directory in /opt/project/vendor/phpstan/phpstan-symfony/src/Symfony/XmlServiceMapFactory.php on line 28
Warning: file_get_contents(/opt/project/vendor/phpstan/phpstan/../../../var/cache/dev/App_KernelDevDebugContainer.xml): Failed to open stream: No such file or directory in /opt/project/vendor/phpstan/phpstan-symfony/src/Symfony/XmlServiceMapFactory.php on line 28

In XmlServiceMapFactory.php line 30:
                                                                               
  Container /opt/project/vendor/phpstan/phpstan/../../../var/cache/dev/App_KernelDevDebugContainer.xml does not exist                                     

analyse [-c|--configuration CONFIGURATION] [-l|--level LEVEL] [--no-progress] [--debug] [-a|--autoload-file AUTOLOAD-FILE] [--error-format ERROR-FORMAT] [-b|--generate-baseline [GENERATE-BASELINE]] [--allow-empty-baseline] [--memory-limit MEMORY-LIMIT] [--xdebug] [--fix] [--watch] [--pro] [--fail-without-result-cache] [--] [<paths>...]
```

Looking for a solution...

## Resources

* https://phpstan.org/
* https://packagist.org/packages/phpstan/phpstan-doctrine
* https://github.com/phpstan/phpstan
* https://github.com/phpstan/phpstan-symfony
* https://github.com/phpstan/phpstan-doctrine
* https://github.com/phpstan/phpstan-phpunit

---

[⬅️ Quality](../quality.md)

