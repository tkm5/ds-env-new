FROM ubuntu:latest

# update
RUN apt -y update && apt install -y \
libsm6 \
libxext6 \
libxrender-dev \
libglib2.0-0 \
sudo \
wget \
vim

#install anaconda3
WORKDIR /opt
# download anaconda package and install anaconda
# archive -> https://repo.anaconda.com/archive
RUN wget https://repo.anaconda.com/archive/Anaconda3-2021.11-Linux-x86_64.sh && \
bash /opt/Anaconda3-2021.11-Linux-x86_64.sh -b -p /opt/anaconda3 && \
rm -f Anaconda3-2021.11-Linux-x86_64.sh
# set path
ENV PATH /opt/anaconda3/bin:$PATH

# update pip and conda and install packages
RUN pip install --upgrade pip && \
    pip install tensorflow && \
    # optional pkgs
    pip install kaggle && \
    pip install jupyterlab_vim && \
    apt install zip unzip

WORKDIR /
RUN mkdir /work && \
    mkdir /root/.kaggle && \
    mkdir -p /root/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/ && \
    mkdir -p /root/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/

# black theme and line number display settings
COPY settings/themes.jupyterlab-settings /root/.jupyter/lab/user-settings/@jupyterlab/apputils-extension/
COPY settings/tracker.jupyterlab-settings /root/.jupyter/lab/user-settings/@jupyterlab/notebook-extension/
# kaggle json file settings
COPY settings/kaggle.json /root/.kaggle/

# execute jupyterlab as a default command
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--allow-root", "--LabApp.token=''"]