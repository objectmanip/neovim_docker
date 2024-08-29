# Configure .env

A .env-file is required. The contents should be as follows:

```env
USERNAME=<username>
PASSWORD=<password>
```
This configures the user account for connecting to the container using ssh.

# Configure neovim

For a persistent neovim config, bind to the following container paths:

| Container Path | Contents |
|----------------|----------|
|/home/\<username>/.config/nvim|NeoVim configuratoin (init.lua, etc)|
|/home/\<username>/.local/|Storage for downloaded files|

