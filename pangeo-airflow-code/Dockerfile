FROM pangeo/base-image:master

USER root
 
RUN curl -fsSL https://code-server.dev/install.sh | sh -s -- --prefix=/usr/local --method=standalone && \
    rm -rf "${HOME}/.cache"

RUN pip install --no-cache-dir git+https://github.com/dirkcgrunwald/jupyter_codeserver_proxy-.git

USER $NB_UID

