# LazyVim Offline

## Overview

This repository contains a Dockerfile to create a self-contained, offline-ready Neovim environment with the LazyVim framework. The image is based on Debian `bookworm-slim` and includes all the necessary dependencies for a full-featured Neovim experience.

## Building the Image

To build the Docker image, run the following command in the root of the repository:

```bash
docker build -t lazyvim-offline .
```

## Usage

To run Neovim from the Docker image and edit files on your local machine, use the following command:

```bash
docker run -it --rm -v "$(pwd)":/work -w /work lazyvim-offline nvim .
```

This command will open Neovim in your current working directory. You can replace `.` with a specific file or directory.

### Shell Alias

For a more seamless experience, you can add the following alias to your shell configuration file (e.g., `.bashrc`, `.zshrc`):

```bash
alias nvim='docker run -it --rm -v "$(pwd)":/work -w /work lazyvim-offline nvim'
```

After adding the alias, you can simply use `nvim` to open files in the Dockerized Neovim environment.

## Offline Usage

To use the Docker image on an offline computer, you need to save the image to a file, transfer it, and then load it on the offline machine.

**1. Save the Image**

```bash
docker save -o lazyvim-offline.tar lazyvim-offline
```

**2. Transfer the File**

Copy the `lazyvim-offline.tar` file to your offline computer using a USB drive or any other method.

**3. Load the Image**

On the offline computer, run the following command:

```bash
docker load -i lazyvim-offline.tar
