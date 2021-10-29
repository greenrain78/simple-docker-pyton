# syntax=docker/dockerfile:1
FROM python:3.8
ENV PYTHONUNBUFFERED=1

# install ssh
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y openssh-server

# install vim
RUN apt-get install -y vim

# install google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install -y google-chrome-stable

# install chromedriver
RUN apt-get install -yqq unzip
RUN wget -O /tmp/chromedriver.zip http://chromedriver.storage.googleapis.com/`curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE`/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d /usr/local/bin/

# 작업 폴더 설정
WORKDIR /home
RUN mkdir "model"
WORKDIR /home/model

# 파이썬 라이브러리 설치
COPY requirements.txt /home/model
RUN pip install -r requirements.txt
#RUN pip install scikit-learn
#RUN pip install joblib

# 개발용으로 entrypoint.sh 파일를 연결
ENTRYPOINT ["sh", "/home/model/entrypoint.sh", "collect"]