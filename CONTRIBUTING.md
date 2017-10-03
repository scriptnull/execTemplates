## Contribute
- Create the following file structure inside `integrations` directory.
    ```
    integrationName/
    `-- cli
        |-- cleanup.sh
        `-- init.sh
    ```
- Populate `init.sh` with the script required to configure the integration.
- Populate `cleanup.sh` with the script required to clean up the integration.
- Reference an existing integration handler for help.
- Lint your scripts using [shellcheck](https://github.com/koalaman/shellcheck).
    ```bash
    make lint
    ```
