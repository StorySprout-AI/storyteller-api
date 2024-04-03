# StorySprout API

<!-- TOC -->
* [StorySprout API](#storysprout-api)
  * [Development](#development)
    * [Setup](#setup-)
    * [Managing application secrets](#managing-application-secrets)
    * [Using NGROK](#using-ngrok)
  * [Operations](#operations)
    * [Using logs](#using-logs)
  * [Future reading](#future-reading)
<!-- TOC -->

> The rails auto-generated README has been moved [here](docs/RAILS.md)

## Development

### Setup 

To setup your local environment, run the following commands in your console:

```shell
# List dependencies that are installed
brew bundle list 
# Check if dependencies are satisfied. If your installed versions are behind, this will "fail" the check 
brew bundle check 
# Install dependencies that are not installed
brew bundle
```

### Using the `direnv` plugin for `asdf` 

To install the `direnv` plugin for `asdf`, run the following command in your console:

```shell
# Add the plugin
asdf plugin add direnv

# Install a version of direnv (match the version in the .tool-versions file)
asdf install direnv 2.33.0
```

If you are installing the `direnv` plugin for the first time, you will need to run the following command in your console to set it up:

```shell
# Edit the shell argument to match your environment
 asdf direnv setup --shell <zsh|bash> --version latest
```

### Managing application secrets

To edit credentials in your IDE, run the following command in your console:

```shell
thor story-cli:secrets:edit
```

To view help information about managing application credentials, run the following command in your console:

```shell
bin/rails credentials:help
```

To edit the credentials file for your development environment using the rails credentials scripts 
and your command line, run the following code in your console:

```shell
EDITOR=nano bin/rails credentials:edit --environment ${RAILS_ENV:-development}
```

### Using NGROK

Follow these steps to setup `ngrok` for your local environment:

- Ensure you have updated your `.envrc` file with the `NGROK_AUTH_TOKEN`. You can get this from KeePass
- Run the following script to export the token to your local `ngrok.yml` config file:

  ```shell
  ngrok config add-authtoken ${NGROK_AUTH_TOKEN}
  ```
Then you can open a tunnel to your local environment by running:
```shell
thor story-cli:tunnel:open_all
```

## Operations

### Connecting to your local psql console 

```shell
docker compose exec db psql -h db.storysprout.local -U storysprout_user
```

### Using logs

Application logs are captured by [the Google Cloud Logging service](https://cloud.google.com/logging/docs?_ga=2.7398139.-852036619.1641716250).

## Future reading

- [The Rails guide (v7.0.x)](https://guides.rubyonrails.org/v7.0/index.html)
- [Testing flipper feature flags](https://www.flippercloud.io/docs/testing)
