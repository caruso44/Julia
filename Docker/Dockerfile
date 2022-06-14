FROM ubuntu:latest

RUN apt update
RUN apt-get update
RUN apt install wget -y
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.7/julia-1.7.2-linux-x86_64.tar.gz
RUN tar -zxvf julia-1.7.2-linux-x86_64.tar.gz
ENV PATH="$PATH:/julia-1.7.2/bin"

WORKDIR /home/orgcomp

ADD Projeto .

