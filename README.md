---
display_name: Docker Containers
description: Provision Docker containers as Coder workspaces
icon: ../../../site/static/icon/docker.png
maintainer_github: coder
verified: true
tags: [docker, container]
---

# Remote Development on Docker Containers

Provision Docker containers as [Coder workspaces](https://coder.com/docs/workspaces) with this example template.

<!-- TODO: Add screenshot -->

## Prerequisites

### Infrastructure

The VM you run Coder on must have a running Docker socket and the `coder` user must be added to the Docker group:

```sh
# Add coder user to Docker group
sudo adduser coder docker

# Restart Coder server
sudo systemctl restart coder

# Test Docker
sudo -u coder docker ps
```

## Architecture

This template provisions the following resources:

- Docker image (built by Docker socket and kept locally)
- Docker container pod (ephemeral)
- Docker volume (persistent on `/home/coder`)

This means, when the workspace restarts, any tools or files outside of the home directory are not persisted. To pre-bake tools into the workspace (e.g. `python3`), modify the container image. Alternatively, individual developers can [personalize](https://coder.com/docs/dotfiles) their workspaces with dotfiles.

> **Note**
> This template is designed to be a starting point! Edit the Terraform to extend the template to support your use case.

## Android, Java, Node, And Yarn For Expo

This template now builds a custom Docker image from `Dockerfile` and includes:

- Node.js 20
- Yarn via Corepack
- OpenJDK 17
- Android SDK command-line tools
- Android platform tools
- Android SDK Platform 35
- Android Build Tools 35.0.0

The workspace exports `JAVA_HOME`, `ANDROID_HOME`, and `ANDROID_SDK_ROOT`, and creates `~/Android/Sdk` as a symlink to the installed SDK so Expo, Yarn, and Gradle can find the Android toolchain without extra setup.

This is sufficient for React Native Expo development and generating Android development builds inside the workspace. It does not include an Android emulator; this setup is for building, not running a local emulator inside the container.

### Editing the image

Edit the `Dockerfile` and run `coder templates push` to update workspaces.
