# Troubleshooting

⬅️ [README](../README.md)

This section covers common issues you might encounter and how to resolve them.

## Error "address already in use" or "port is already allocated"

When running `make up_detached` or `docker compose up`, you might see errors like these:

> Error response from daemon: driver failed programming external connectivity on endpoint symfony-starter-php-1 (...): Error starting userland proxy: listen tcp4 0.0.0.0:80: bind: address already in use

> Error response from daemon: driver failed programming external connectivity on endpoint symfony-starter-php-1 (...): Bind for 0.0.0.0:443 failed: port is already allocated

These errors indicate that another process or container is already using the required ports (80 or 443).

### Solution 1 - Custom HTTP ports (Recommended for persistent issues)

This method allows you to change the ports your Symfony application uses, which is useful if you frequently have other services occupying default ports.

> See https://github.com/dunglas/symfony-docker/blob/main/docs/options.md#using-custom-http-ports.

- **Method A: In the command line**

```shell
HTTP_PORT=8000 HTTPS_PORT=4443 HTTP3_PORT=4443 make generate
# or, if the project is already generated:
HTTP_PORT=8000 HTTPS_PORT=4443 HTTP3_PORT=4443 make up_detached
````

- **Method B: Using `.env.local` for a permanent setting**

Add these lines to your `.env.local` file:

```dotenv
# .env.local
HTTP_PORT=8000
HTTPS_PORT=4443
HTTP3_PORT=4443
```

Then, run your `make` command:

```shell
make generate
# or
make up_detached
```

### Solution 2 - Find and stop the **container** using the port

If another Docker container is occupying the port, you can find and stop it.

- List containers using, for example, port `443`:

<!-- end list -->

```shell
docker ps | grep :443
# Example output:
# c91d77c0994e   app-php   "docker-entrypoint f…"   15 hours ago   Up 15 hours (healthy)   0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp, 0.0.0.0:443->443/udp, :::443->443/udp, 2019/tcp   other-container-php-1
```

- Stop the container using its `ID` or `NAME`:

<!-- end list -->

```shell
docker stop c91d77c0994e       # Stop by ID
docker stop other-container-php-1 # Stop by NAME
```

- Alternatively, you can stop all running Docker containers at once (use with caution\!):

<!-- end list -->

```shell
docker stop $(docker ps -a -q)
```

### Solution 3 - Find and stop the **service** using the port (Linux)

If a non-Docker service (like Apache, Nginx, or another local web server) is using the port, you need to stop that service.

- See the network statistics and identify the process using the port (e.g., `:80`):

<!-- end list -->

```shell
sudo netstat -pna | grep :80
# Example output:
# tcp6        0      0 :::80       :::* LISTEN      4321/apache2
```

- In the example above, `4321/apache2` indicates Apache is running. You can stop it (command varies by service and Linux distribution):

<!-- end list -->

```shell
sudo service apache2 stop # For Apache on systems using 'service' command
# sudo systemctl stop apache2 # For Apache on systems using 'systemctl'
```

## Editing permissions on Linux

When working on Linux, you might encounter permission errors after the initial project setup, preventing you from editing certain files. This usually happens because files created by the Docker container are owned by the `root` user (or a different user ID) within the container, not your host user.

To fix this, you can run the following command in your project directory:

```shell
make permissions
```

This command will change the ownership of the project files to your current host user, allowing you to edit them freely.

> See https://github.com/dunglas/symfony-docker/blob/main/docs/troubleshooting.md for more details on `dunglas/symfony-docker` troubleshooting.

## "Git is not recognizing my project as a repository" after `make generate`

On Linux systems, you might encounter an issue where Git no longer recognizes your project as a repository, or you see permission errors after running `make generate`. This usually happens because files created inside the Docker containers (like your Symfony application files installed by Composer) are owned by a different user within the container (often `root`). When these files are written to your local filesystem via Docker volumes, they retain these permissions, which can prevent your host user (and thus Git) from properly accessing or modifying them.

This specific problem is solved by the `make permissions` command. This command ensures that all project files are owned by your current user on the host system, allowing Git and other tools to operate without issues.

**Solution:**

If you face this problem, simply run:

```shell
make permissions
```

This command automatically adjusts the file ownership to match your host user, resolving any Git-related permission issues. Note that this command is conditional and only executes the ownership change on Linux environments where it's typically needed.

## Git "dubious ownership" Error in Docker Container

You might encounter this error when running Git or Composer commands inside your Docker PHP container:

```
fatal: detected dubious ownership in repository at '/app'
To add an exception for this directory, call:

        git config --global --add safe.directory /app
```

**Problem:** Git detects that the `/app` directory inside the container is owned by a different user (e.g., `root`) than the one executing the Git command, which is a security measure.

**Solution:** You need to tell Git within the container that `/app` is a safe directory. We have a Makefile command to do this easily.

**Action:**
From your host machine's terminal, in your project's root directory, run:

```bash
make git_safe_dir
```

This will execute the necessary `git config` command inside your `php` Docker service. After this, you should be able to run Git and Composer commands (like `composer require`) without this error.
