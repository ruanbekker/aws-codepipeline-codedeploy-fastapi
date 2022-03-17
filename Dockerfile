FROM python:3.8-alpine

ENV ADMIN_EMAIL "root@localhost"

RUN adduser -D app
WORKDIR /home/app

RUN apk --no-cache add curl
ADD dependencies/requirements.pip /src/requirements.pip
RUN pip3 install -r /src/requirements.pip

ADD src/main.py src/models.py src/config.py /home/app/
ADD src/tests/__init__.py src/tests/test_main.py /home/app/tests/
ADD configs/hypercorn.toml /home/app/configs/hypercorn.toml
ADD configs/sample.env /home/app/.env
RUN chown -R app:app /home/app

USER app

RUN set -ex; pytest

CMD ["hypercorn", "--config", "configs/hypercorn.toml", "main:app"]
