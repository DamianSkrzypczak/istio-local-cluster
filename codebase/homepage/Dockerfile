FROM python:3.11-slim

ENV PIP_ROOT_USER_ACTION=ignore

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .