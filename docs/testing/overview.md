# Overview

[⬅️ Testing](../testing.md)

---

## Types of Tests

| Types       | Description                                                                                                                                                                                                                                                                                                                                             | Extends                                         |
|-------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------|
| Unit        | These tests ensure that **individual units** of source code (e.g. a single class) behave as intended, **isolated from the rest of the application**. This involves mocking or stubbing dependencies.                                                                                                                                                    | `TestCase`                                      |
| Functional  | Functional tests ensure the **behavior of a feature or a user story** works as intended. This can involve testing the interaction between several components or a complete feature, often without simulating the full HTTP request/response cycle. Functional tests are a broader category that can overlap with both integration and end-to-end tests. | `KernelTestCase`                                |
| Integration | These tests verify that **two or more components work together** as a single module. They test the interaction between your code and external dependencies, such as a database, a cache service, or a third-party API. They commonly interact with **Symfony's service container**.                                                                     | `KernelTestCase`                                |
| Application | Application tests, also known as **end-to-end (E2E) tests**, verify that the **complete application works as a whole**, from the user interface to the database. They simulate a user's behavior, making **HTTP requests** and asserting that the response is as expected.                                                                              | `WebTestCase`, `ApiTestCase`, `PantherTestCase` |

## Create a test with Symfony

```
php bin/console make:test

 Which test type would you like?:
  [TestCase       ] basic PHPUnit tests
  [KernelTestCase ] basic tests that have access to Symfony services
  [WebTestCase    ] to run browser-like scenarios, but that don't execute JavaScript code
  [ApiTestCase    ] to run API-oriented scenarios
  [PantherTestCase] to run e2e scenarios, using a real-browser or HTTP client and a real web server
  >
```

## The Arrange-Act-Assert (AAA) pattern

```php
class MyTest ... {
    function test() {
        // 1. ARRANGE all necessary preconditions and inputs

        // 2. ACT on the object or method under test

        // 3. ASSERT that the expected results have occurred
    }
}
```

## Smoke testing

In software engineering, [smoke testing](https://en.wikipedia.org/wiki/Smoke_testing_(software)) consists of "_preliminary testing to reveal simple failures severe enough to reject a prospective software release_". Using [PHPUnit data providers](https://docs.phpunit.de/en/9.6/writing-tests-for-phpunit.html#data-providers) you can define a functional test that checks that all application URLs load successfully.

Example:

```php
class SmokeTest extends WebTestCase
{
    /**
     * @dataProvider getPublicUrl
     */
    public function testPublicPageIsSuccessful(string $url): void
    {
        $client = static::createClient();
        $client->request(Request::METHOD_GET, $url);
        $this->assertResponseIsSuccessful();
    }

    public static function getPublicUrl(): \Generator
    {
        yield ['/'];
        yield ['/about'];
        yield ['/blog/'];
        yield ['/blog/lorem-ipsum-dolor-sit-amet-consectetur-adipiscing-elit'];
        yield ['/posts/'];
        yield ['/projects'];
        yield ['/tags'];
        yield ['/login'];
    }
}
```

## Resources

* https://symfony.com/doc/current/testing.html
* https://symfonycasts.com/screencast/phpunit-integration/integration-test
* https://github.com/dunglas/symfony-docker/blob/main/docs/xdebug.md
* https://pguso.medium.com/how-to-write-unit-tests-in-symfony-0a3cf12bcfd2
* https://stackoverflow.com/questions/9470795/using-the-arrange-act-assert-pattern-with-integration-tests
* https://symfony.com/doc/current/best_practices.html#smoke-test-your-urls
* https://github.com/shopsys/http-smoke-testing

---

[⬅️ Testing](../testing.md)
