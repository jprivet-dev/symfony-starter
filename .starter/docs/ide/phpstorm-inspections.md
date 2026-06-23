# PhpStorm - Configure inspections

[⬅️ STARTER](../STARTER.md)

---

## About

PHPStorm includes an inspection called **`Missing @throws tag(s)`** that reports any method missing a `@throws` PHPDoc tag when an exception may be thrown. By default, this also covers exceptions forwarded from dependencies, which creates unnecessary noise.

The rule adopted in this project is: **`@throws` is only added when an exception is explicitly thrown in the method body**. Forwarded exceptions from dependencies are not documented.

## Configure PhpStorm

### Unchecked exceptions

* Go to **Settings (Ctrl+Alt+S) → PHP → Analysis**.
* Under **Unchecked Exceptions**, add the following classes:
  * `\Exception`
  * `\LogicException`
  * `\RuntimeException`
  * `\InvalidArgumentException`
* Click on `OK` or `Apply` to validate.

This excludes all exceptions inheriting from these base classes from the `Missing @throws tag(s)` inspection scope, which covers the vast majority of cases in Symfony and third-party libraries.

### Expected result

```php
// ✅ @throws is relevant — exception is explicitly thrown here
public function validateFile(string $path): void
{
    if (!file_exists($path)) {
        throw new \InvalidArgumentException(sprintf('File not found: %s', $path));
    }
}

// ✅ No @throws needed — exception comes from a dependency
private function readCsv(string $filePath): iterable
{
    $csv = Reader::from($filePath, 'r');
    $csv->setHeaderOffset(0);
    $csv->setEscape('');

    return $csv->getRecords();
}
```

## Links

* https://www.jetbrains.com/help/phpstorm/code-inspection.html

---

[⬅️ STARTER](../STARTER.md)
