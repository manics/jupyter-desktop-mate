# Jupyter Desktop MATE

[![Build](https://github.com/manics/jupyter-desktop-mate/actions/workflows/build.yaml/badge.svg)](https://github.com/manics/jupyter-desktop-mate/actions/workflows/build.yaml)

A container image providing the [MATE Desktop](https://mate-desktop.org/) running in Jupyter, using [Jupyter Remote Desktop Proxy](https://github.com/jupyterhub/jupyter-remote-desktop-proxy/).

## Usage

```
docker pull ghcr.io/manics/jupyter-desktop-mate:latest
docker run -p8888:8888 ghcr.io/manics/jupyter-desktop-mate:latest
```

Open the `http://127.0.0.1:8888/lab?token=<TOKEN>` URL shown in the output.
