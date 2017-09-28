# execTemplates

This repository will (eventually) contain all the scripts that are pieced together to execute a build on Shippable.

## Integrations

Under the integrations folder, you'll find the scripts that get executed when a particular integration gets used in a build.

#### Contribute
- create following file structure inside `integrations` directory
```
integrationName/
`-- cli
    |-- cleanup.sh
    `-- init.sh
```
- Write `init.sh` and `cleanup.sh`
- Lint your scripts using [shellcheck](https://github.com/koalaman/shellcheck)
```bash
make lint
```
