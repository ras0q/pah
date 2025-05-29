# https://docs.astral.sh/uv/guides/integration/docker/#intermediate-layers

FROM python:3.13-slim-bookworm
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy

# For dynamic versioning
RUN apt-get update \
  && apt-get install -y --no-install-recommends git \
  && git init

WORKDIR /app

ADD . /app

RUN --mount=type=cache,target=/root/.cache/uv \
  uv sync --locked --no-install-project --all-extras

RUN --mount=type=cache,target=/root/.cache/uv \
  uv sync --locked --all-extras
