FROM pangeo/base-image:master

USER root

RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --prefix=/usr/local --method=standalone && \
    rm -rf "${HOME}/.cache"

RUN pip install --no-cache-dir git+https://github.com/dirkcgrunwald/jupyter_codeserver_proxy-.git

RUN echo "Installing Apt-get  COMPILER packages..." \
    && apt-get update --fix-missing \
    && apt-get install -y build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER $NB_UID

