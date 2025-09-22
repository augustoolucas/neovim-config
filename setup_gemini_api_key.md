# Setup pass and gpg for CodeCompanion Gemini API Key

This guide provides the necessary commands to install `pass` and `gpg` to securely store your Gemini API key for use with `codecompanion.nvim`. These instructions are for Debian/Ubuntu-based systems.

## 1. Install `pass` and `gpg`

First, update your package list and install the necessary packages using your system's package manager.

```sh
sudo apt update
sudo apt install pass gnupg2 -y
```

## 2. Generate a GPG Key

If you don't already have a GPG key, you'll need to create one. `pass` uses it to encrypt your secrets.

```sh
gpg --full-generate-key
```

Follow the on-screen prompts. The default options are usually sufficient. You will be asked for your name, email address, and to create a secure passphrase.

## 3. Initialize `pass`

Next, you need to initialize the `pass` password store using the GPG key you just created.

You can find your GPG key ID and initialize `pass` with the following commands.

```sh
# Find your GPG key ID
gpg --list-secret-keys --keyid-format=long

# Initialize pass with your key ID.
# Replace YOUR_GPG_KEY_ID with the key from the command above.
pass init YOUR_GPG_KEY_ID
```

## 4. Store Your Gemini API Key

Insert your Gemini API key into the password store under the name `gemini_api_key`, which matches the entry in your Lua configuration.

```sh
pass insert gemini_api_key
```

Paste your API key when prompted and press Enter. You will be asked to confirm it.

## 5. Verify the Setup

You can verify that the key was stored correctly by running the same command your Neovim configuration uses:

```sh
pass show gemini_api_key
```

This should print your API key to the terminal. After completing these steps, restart Neovim for the changes to take effect.
