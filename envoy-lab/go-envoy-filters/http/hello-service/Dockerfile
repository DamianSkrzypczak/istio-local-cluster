FROM python:3.11.5-slim-bullseye@sha256:9f35f3a6420693c209c11bba63dcf103d88e47ebe0b205336b5168c122967edf as python-base
RUN rm -f /etc/apt/apt.conf.d/docker-clean \
    && echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' | tee /etc/apt/apt.conf.d/keep-cache
ARG PYTHON_REQUIREMENTS_FILE=requirements.txt
ADD "$PYTHON_REQUIREMENTS_FILE" /tmp/requirements.txt

FROM python-base as aiohttp-service
ENV DEBIAN_FRONTEND=noninteractive
ADD "$PYTHON_REQUIREMENTS_FILE" /tmp/requirements.txt
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    pip3 install --require-hashes -qr /tmp/requirements.txt \
    && apt-get -qq update \
    && apt-get -qq install -y --no-install-recommends netcat \
    && mkdir /code
HEALTHCHECK \
    --interval=1s \
    --timeout=1s \
    --start-period=1s \
    --retries=3 \
    CMD nc -zv localhost 8080
ENTRYPOINT ["python3", "/code/service.py"]

FROM aiohttp-service as aiohttp-hello-service
ADD service.py /code/service.py
