# Docker Frappe (Multi-container)

This code was originally forked from [donysukardi/docker-frappe](https://github.com/donysukardi/docker-frappe).

This is the base image containing Frappe.

If you are looking to start an instance of ERPNext, please see the [ianneub/docker-erpnext](https://github.com/ianneub/docker-erpnext) repository.

## Build the image using the docker build command

1. Run: `docker build -t ianneub/frappe .`.

## Environment Variables

The image is configuring using environment variables. Bellow is a list of variables and their default settings. These variables will be set in the `site_config.json` file.

* `ADMIN_PASSWORD`=`frappe`
* `DB_HOST`=`db`
* `DB_NAME`=`frappe`
* `DB_PASSWORD`=`frappe`
* `DB_USER`=`frappe`
* `MAIL_LOGIN`=``
* `MAIL_PASSWORD`=``
* `MAIL_PORT`=``
* `MAIL_SERVER`=``
* `REDIS_CACHE_URL`=`redis-cache`
* `REDIS_QUEUE_URL`=`redis-queue`
* `REDIS_SOCKETIO_URL`=`redis-socketio`
* `ROOT_PASSWORD`=`root`
* `USE_SSL`=`false`
