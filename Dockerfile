FROM quay.io/jupyter/base-notebook:latest

USER root

RUN apt-get update -y -q \
 && apt-get install -y -q \
        tigervnc-standalone-server \
        ubuntu-mate-desktop \
        vim \
 && add-apt-repository -y ppa:mozillateam/ppa \
 && printf 'Package: firefox*\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001\n' > /etc/apt/preferences.d/firefox \
 && apt-get install -y -q --allow-downgrades firefox \
 && apt-get purge -y -q \
        blueman \
        mate-screensaver \
 && apt-get autoremove -y -q \
    # chown $HOME to workaround that the xorg installation creates a
    # /home/jovyan/.cache directory owned by root
    # Create /opt/install to ensure it's writable by pip
 && mkdir -p /opt/install $HOME/.vnc \
 && chown -R $NB_UID:$NB_GID $HOME /opt/install \
 && rm -rf /var/lib/apt/lists/*

USER $NB_USER

COPY --chown=$NB_UID:$NB_GID requirements.txt /tmp
RUN . /opt/conda/bin/activate && \
    pip install --no-cache-dir -r /tmp/requirements.txt

COPY --chown=$NB_UID:$NB_GID start-mate.sh $HOME/.vnc/xstartup

# Add some shortcuts to the desktop
RUN mkdir -p $HOME/Desktop && \
    ln -s \
        /usr/share/applications/mate-terminal.desktop \
        /usr/share/applications/firefox.desktop \
        $HOME/Desktop
