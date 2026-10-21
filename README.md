# Jupyter Desktop MATE

[![Build](https://github.com/manics/jupyter-desktop-mate/actions/workflows/build.yaml/badge.svg)](https://github.com/manics/jupyter-desktop-mate/actions/workflows/build.yaml)

Desktop: [![Binder (Desktop)](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/manics/jupyter-desktop-mate/HEAD?urlpath=desktop)

Selkies: [![Binder (Selkies)](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/manics/jupyter-desktop-mate/HEAD?urlpath=selkies)

A container image providing the [MATE Desktop](https://mate-desktop.org/) running in Jupyter, supporting both
[Jupyter Remote Desktop Proxy (VNC)](https://github.com/jupyterhub/jupyter-remote-desktop-proxy/)
and
[Selkies](https://github.com/selkies-project/selkies) (WebRTC/HTML5 video streaming),
using [Jupyter Server Proxy](https://github.com/jupyterhub/jupyter-server-proxy/).

![Screenshot of jupyter-desktop-mate](https://raw.githubusercontent.com/manics/jupyter-desktop-mate/main/tests/reference/desktop.png)

## Usage

```sh
docker pull ghcr.io/manics/jupyter-desktop-mate:latest
docker run -p127.0.0.1:8888:8888 ghcr.io/manics/jupyter-desktop-mate:latest
```

Open the `http://127.0.0.1:8888/lab?token=<TOKEN>` URL shown in the output.
In the JupyterLab Launcher, choose either:

- **Desktop [↗]**: VNC/noVNC desktop via [jupyter-remote-desktop-proxy](https://github.com/jupyterhub/jupyter-remote-desktop-proxy/)
- **Selkies [↗]**: WebRTC/HTML5 desktop streaming via [Selkies](https://github.com/selkies-project/selkies)

## Running without Jupyter

### TigerVNC

```sh
podman run -it --rm -ePASSWORD=secret -p127.0.0.1:5901:5901 ghcr.io/manics/jupyter-desktop-mate:latest start-tigervnc.sh
```

and connect to `127.0.0.1:5901` in your VNC client.
Optionally set `PASSWORD=""` to disable authentication

### Selkies

```sh
podman run -it --rm -ePASSWORD=secret -p127.0.0.1:8080:8080 ghcr.io/manics/jupyter-desktop-mate:latest start-selkies.sh
```

and open `http://127.0.0.1:8080` in your web browser.
Optionally set `PASSWORD=""` to disable authentication
