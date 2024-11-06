# Latest is broken https://github.com/jupyter/docker-stacks/issues/2170
FROM quay.io/jupyter/base-notebook:2024-10-28

USER root

# hadolint ignore=DL3008
RUN apt-get update -y -q \
 && apt-get install -y -q --no-install-recommends \
        # xclip is added so Playwright can test the clipboard
        xclip \
        tigervnc-standalone-server \
        ubuntu-mate-desktop \
        vim \
        # Selected recommends
        fonts-liberation2 \
        mate-applet-brisk-menu \
        mate-calc \
        mate-hud \
        mate-optimus \
        mate-sensors-applet \
        mate-system-monitor \
        mate-tweak \
        mate-user-admin \
        mate-window-buttons-applet \
        mate-window-menu-applet \
        mate-window-title-applet \
        tigervnc-tools \
        ubuntu-mate-artwork \
        xdg-desktop-portal-gtk \
 && add-apt-repository -y ppa:mozillateam/ppa \
 && printf 'Package: firefox*\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001\n' > /etc/apt/preferences.d/firefox \
 && apt-get install -y -q --no-install-recommends --allow-downgrades firefox \
 && apt-get purge -y -q \
        blueman \
        mate-screensaver \
 && apt-get autoremove -y -q \
    # chown $HOME to workaround that the xorg installation creates a
    # /home/jovyan/.cache directory owned by root
    # Create /opt/install to ensure it's writable by pip
 && mkdir -p /opt/install "$HOME/.vnc" \
 && chown -R "$NB_UID:$NB_GID" "$HOME" /opt/install \
 && rm -rf /var/lib/apt/lists/*

USER $NB_USER

COPY --chown=$NB_UID:$NB_GID requirements.txt /tmp

# hadolint ignore=SC1091
RUN . /opt/conda/bin/activate && \
    pip install --no-cache-dir -r /tmp/requirements.txt

# $HOME/.vnc/xstartup may be shadowed if the home directory is mounted
# https://github.com/jupyterhub/jupyter-remote-desktop-proxy/pull/134
COPY start-mate.sh /opt/conda/lib/python3.12/site-packages/jupyter_remote_desktop_proxy/share/xstartup

# Add some shortcuts to the desktop
RUN mkdir -p "$HOME/Desktop" && \
    ln -s \
        /usr/share/applications/mate-terminal.desktop \
        /usr/share/applications/firefox.desktop \
        "$HOME/Desktop"
