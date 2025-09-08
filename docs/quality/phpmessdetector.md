# PHP Mess Detector

[⬅️ Quality](../quality.md)

---

## About

PHPMD takes a given PHP source code base and look for several potential problems within that source. These problems can be things like:

* Possible bugs
* Suboptimal code
* Overcomplicated expressions
* Unused parameters, methods, properties

List of rulesets and rules contained in each ruleset.

* [Clean Code Rules](https://phpmd.org/rules/index.html#clean-code-rules): The Clean Code ruleset contains rules that enforce a clean code base. This includes rules from SOLID and object calisthenics.
* [Code Size Rules](https://phpmd.org/rules/index.html#code-size-rules): The Code Size Ruleset contains a collection of rules that find code size related problems.
* [Controversial Rules](https://phpmd.org/rules/index.html#controversial-rules): This ruleset contains a collection of controversial rules.
* [Design Rules](https://phpmd.org/rules/index.html#design-rules): The Design Ruleset contains a collection of rules that find software design related problems.
* [Naming Rules](https://phpmd.org/rules/index.html#naming-rules): The Naming Ruleset contains a collection of rules about names - too long, too short, and so forth.
* [Unused Code Rules](https://phpmd.org/rules/index.html#unused-code-rules): The Unused Code Ruleset contains a collection of rules that find unused code.

## Installation

```
composer require --dev phpmd/phpmd
```

## Troubleshooting

### Missing class import via use statement

If you are using an external class (e.g.: `new \DateTimeImmutable()`), this violation may appear in PhpStorm:

```
phpmd: Missing class import via use statement
```

Or with the `phpmd` command:

```
FILE: /app/src/...
--------------------------------------------
 24 | VIOLATION | Missing class import via use statement ...
```

Solution - Exclude the `MissingImport` rule in `phpmd.xml`:

```xml
    <!-- https://phpmd.org/rules/#clean-code-rules -->
    <rule ref="rulesets/cleancode.xml">
        <exclude name="StaticAccess"/>
        <exclude name="MissingImport"/>
    </rule>
```

> See https://phpmd.org/rules/cleancode.html#missingimport

## Configure PhpStorm

> Prerequisite : [Configure a remote PHP interpreter (Docker)](../remote-php-interpreter.md)

* Go on **Settings (Ctrl+Alt+S) > PHP > Test Framework**.
* Click on `+` and select **PHPUnit by Remote Interpreter**.
* In the **PHPUnit by Remote Interpreter** dialog, select `Interpreter: php`.
* Click on `OK`.
* In the **Settings** dialog:
    * CLI interpreter: `symfony-starter-app-php:latest`.
    * In **PHPUnit library** area:
        * Choose **Use Composer autoloader**.
        * Path to script: `/app/vendor/autoload.php`.
        * PHPUnit version is indicated.
    * In **Test Runner** area:
        * Default configuration file: `/app/phpunit.xml.dist`.
    * Click on `OK` or `Apply` to validate all.

## Resources

* https://phpmd.org/
* https://github.com/phpmd/phpmd
* https://packagist.org/packages/phpmd/phpmd
* https://www.jetbrains.com/help/phpstorm/using-php-mess-detector.html

---

[⬅️ Quality](../quality.md)
