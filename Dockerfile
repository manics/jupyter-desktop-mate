FROM quay.io/jupyter/base-notebook:2026-09-28

USER root

# hadolint ignore=DL3008
RUN apt-get update -y -q \
 && apt-get install -y -q --no-install-recommends \
        # TigerVNC/noVNC dependencies
        tigervnc-standalone-server \
        tigervnc-tools \
        # Selkies dependencies (X11 server, audio, and media encoding)
        dbus-daemon \
        libdrm2 \
        libgbm1 \
        libpixman-1-0 \
        libva2 \
        libxkbcommon0 \
        pulseaudio \
        xvfb \
        # Desktop environment
        ubuntu-mate-desktop \
        # xclip is added so Playwright can test the clipboard
        xclip \
        # Useful command line tools
        curl \
        less \
        rsync \
        tmux \
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
 && rm -rf /var/lib/apt/lists/* \
    # Disable Ubuntu upgrade popup
 && sed -i 's/Prompt=.*/Prompt=never/' /etc/update-manager/release-upgrades \
    # Ensure mate.desktop starts our customized start-mate.sh for Selkies
 && sed -i 's|^Exec=.*|Exec=/usr/local/bin/start-mate.sh|' /usr/share/xsessions/mate.desktop

USER $NB_USER

# requirements.txt can be bumped by dependabot
COPY --chown=$NB_UID:$NB_GID requirements.txt /tmp

# hadolint ignore=SC1091
RUN . /opt/conda/bin/activate && \
    mamba install --no-allow-downgrade \
        "nodejs=24" && \
    pip install --no-cache-dir -r /tmp/requirements.txt && \
    mamba clean --all

COPY start-mate.sh start-selkies.sh start-tigervnc.sh /usr/local/bin/

# $HOME/.vnc/xstartup may be shadowed if the home directory is mounted
# https://github.com/jupyterhub/jupyter-remote-desktop-proxy/pull/134
RUN ln -sf /usr/local/bin/start-mate.sh /opt/conda/lib/python3.13/site-packages/jupyter_remote_desktop_proxy/share/xstartup

# Add some shortcuts to the desktop and make a copy of HOME in case it's shadowed by a mount
ENV HOME_TEMPLATE_DIR=/opt/install/home.template
ENV XDG_CURRENT_DESKTOP=MATE

RUN mkdir "$HOME/Desktop" && \
    ln -s \
        /usr/share/applications/mate-terminal.desktop \
        /usr/share/applications/firefox.desktop \
        "$HOME/Desktop" && \
    rsync -a "$HOME/Desktop" "$HOME_TEMPLATE_DIR/"
