# Configure a remote PHP interpreter (Docker)

[⬅️ README](../README.md)

---

## About

You can access a PHP interpreter installed in a Docker container. This is the main configuration to be made before any others.

## Configure PhpStorm

* Go on **Settings (Ctrl+Alt+S) > PHP**.
  * In the **PHP** section, click on `…`, next to the **CLI Interpreter** list.
  * In the **CLI Interpreters** dialog, click on `+`.
  * In the **Select CLI Interpreters** dialog, select **From Docker, Vagrant, VM, WSL, Remote…**.
  * In the **Configure Remote PHP Interpreter** dialog, select:

    ```
    Server              : Docker
    Image name          : symfony-starter-app-php:latest
    PHP interpreter path: php
    ```

    * Click on `OK`.
  * In the **CLI Interpreters** dialog:
    * In the **Docker** area, you can see:

      ```
      Server    : Docker
      Image name: symfony-starter-app-php:latest
      ```

    * In the **General** area, you can see:

      ```
      PHP executable    : php
      Configuration file: (empty)
      PHP version       : 8.4.12
      Configuration file: /usr/local/etc/php/php.ini
      ```

    * Click on `OK`.
  * In the **PHP** dialog, you can see:

    ```
    PHP language level: 8.4
    ClI Interpreter   : symfony-starter-app-php:latest
    Path mappings     : <Project root>→/opt/project; /home/user/.config/JetBrains/PhpStorm2025.1/scratches→/opt/scratc...
    Docker container  : -v /home/user/symfony-starter:/opt/project
    ```

  * In the **Settings** dialog, click on `OK` or `Apply` to validate all.

## Resources

* https://www.jetbrains.com/help/phpstorm/configuring-remote-interpreters.html

---

[⬅️ README](../README.md)
