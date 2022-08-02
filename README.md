<img src="https://github.com/maggie0002/balena-apps-logo/raw/main/logo.png" width="75" />

# Balena CLI GitHub Action

This is a community built GitHub action that allows you to use the balena CLI. You can use it to deploy to your fleet, or combine multiple CLI commands together to download an OS and preload it with your app ready for publishing as a release.

## Usage

### Deploy

Here is an example workflow.yml file that deploys to a fleet. Workflow files should be added to the `.github/workflows/` directory within your project.

```
# Full list of options available at:
# https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions

name: Balena Deploy

on:
  push

jobs:
  balena-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: balena CLI Action
        uses: balena-community/community-cli-action@1.0.0
        with:
          balena_token: ${{secrets.BALENA_TOKEN}}
          balena_cli_commands: >
            push username/your-production-fleet;
          balena_cli_version: 13.7.1
```

### Preload

If you would like to use the balena Preload functionality you can use the workflow below. Your preloaded image file will be available in the default workspace directory (./) of the GitHub workflow and can then be used to upload the preloaded image to your GitHub releases, a website or anything else you choose (consider compressing the image first).

Here is an example for creating a preloaded image and pushing as a GitHub release on your repository:

```
# Full list of options available at:
# https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions

name: Balena Deploy

on:
  # On push of a tag
  push:
    tags:
      - "*"

jobs:
  balena-deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: balena CLI Action
        uses: balena-community/community-cli-action@1.0.0
        with:
          balena_token: ${{secrets.BALENA_TOKEN}}
          balena_cli_commands: >
            push my-production-repo;
            os download raspberrypi4-64 --version v2.99.27 -o ./rpi-4.img;
            preload rpi-4.img --fleet my-app --commit latest;
            os configure rpi-4.img --config-network=ethernet --fleet my-app
          balena_cli_version: 13.7.1

      - name: Publish release
        uses: "marvinpinto/action-automatic-releases@v1.2.1"
        with:
          repo_token: "${{ secrets.GITHUB_TOKEN }}"
          prerelease: false
          automatic_release_tag: "latest"
          files: |
            rpi-4.img
```

### Anything else

The action is simply a wrapper for the CLI so you could pass any of the CLI commands through the action and in any order to create anything you like.

## Inputs

Inputs are provided using the `with:` section of your workflow YML file.

| Key                 | Description                                                                                                                                                                                                                                                                                                                                | Required | Default |
| ------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------- | ------- |
| balena_token        | API key to balena Cloud available from the [Balena Dashboard](https://dashboard.balena-cloud.com/preferences/access-tokens). Tokens need to be stored in GitHub as an [encrypted secret](https://docs.github.com/en/actions/security-guides/encrypted-secrets#creating-encrypted-secrets-for-a-repository) that GitHub Actions can access. | true     |         |
| balena_cli_commands | CLI commands you would like to execute. Separate multiple commands with a `;`. There is an example workflow in this README.                                                                                                                                                                                                                | true     |         |
| balena_cli_version  | CLI version to use (example: `13.7.1`)                                                                                                                                                                                                                                                                                                     | true     |         |
| application_path    | Provide a sub-path to the location for application being deployed to BalenaCloud. Defaults to the workspace root.                                                                                                                                                                                                                          | false    | './'    |
| balena_secrets      | Provide the contents of a balena secrets.json file for authenticating against private registries.                                                                                                                                                                                                                                          | false    |         |

## Example Balena Secrets

```
registry_secrets: |
  {
    "ghcr.io": {
      "username": "${{ secrets.REGISTRY_USER }}",
      "password": "${{ secrets.REGISTRY_PASS }}"
    }
  }
```
