# Structure

⬅️ [README](../README.md)

Before `make generate`:

```
./
├── LICENSE
├── Makefile
└── README.md
```

After `make generate`:

```
./
├──*bin/
├──*config/
├──*docs/
├──*frankenphp/
├──*public/
├──*src/
├──*var/
├──*vendor/
├──*compose.override.yaml
├──*compose.prod.yaml
├──*composer.json
├──*composer.lock
├──*compose.yaml
├──*Dockerfile
├── LICENSE
├── Makefile
├── README.md
└──*symfony.lock 
```

(*) Fresh Symfony application with a Docker configuration

Show structure:

```shell
tree -A -L 1 -F --dirsfirst
```
