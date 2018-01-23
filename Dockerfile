FROM xaerdna/modelsim

RUN apt purge python -y
RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:neovim-ppa/unstable
RUN apt update
RUN apt install -y \
	fish \
	tree \
	neovim \
	python3-dev \
	python3-pip \
	curl

ENV PATH $PATH:/root/altera/15.0/modelsim_ase/bin
RUN ln -s /root/altera/15.0/modelsim_ase/linuxaloem /root/altera/15.0/modelsim_ase/linux_rh60

CMD ["bash"]
