FROM centos:7
CMD ["bash"]
SHELL ["/bin/bash", "-i", "-c"]
ARG PYTHON_VERSION=3.8.10
ARG PYINSTALLER_VERSION=3.6
ENV PYPI_URL=https://pypi.python.org/
ENV PYPI_INDEX_URL=https://pypi.python.org/simple
ENV PYENV_VERSION=3.8.10
COPY entrypoint-linux.sh /entrypoint.sh
RUN \
    set -x \
    && yum update -y --disableplugin=fastestmirror \
    && yum install -y openssl-devel bzip2-devel libffi-devel \
    && yum groupinstall -y "Development Tools" \
    && yum install -y wget python3 \
    && echo "alias python=/usr/bin/python3.6" >> ~/.bashrc \ 
    && source ~/.bashrc \
    && whereis python \
    && update-alternatives --install /usr/bin/python python /usr/bin/python2 50 \
    && update-alternatives --install /usr/bin/python python /usr/bin/python3 60 \
    # && update-alternatives --set python /usr/bin/python3 \
    && curl -O https://bootstrap.pypa.io/pip/3.6/get-pip.py \
    && python get-pip.py \
    && python -m pip install --upgrade pip \
    && echo "alias pip=/usr/bin/pip3.6" >> ~/.bashrc \
    && source ~/.bashrc \
    # && pip3 install --upgrade pip \
    && pip install pyinstaller==$PYINSTALLER_VERSION \
    && echo "alias pyinstaller=/usr/local/bin/pyinstaller" >> ~/.bashrc \
    && source ~/.bashrc \
    && mkdir /src/ \
    && chmod +x /entrypoint.sh
VOLUME [/src/]
WORKDIR /src/
ENTRYPOINT ["/entrypoint.sh"]
