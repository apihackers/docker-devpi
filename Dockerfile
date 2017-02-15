FROM alpine:3.5

# RUN apk add --update --no-cache bash ca-certificates && update-ca-certificates
RUN apk add --update --no-cache bash ca-certificates python3 \
    && python3 -m ensurepip \
    && rm -r /usr/lib/python*/ensurepip \
    && pip3 install --upgrade pip setuptools \
    && update-ca-certificates \
    && rm -r /root/.cache

ENV DEVPI_SERVER_VERSION=4.2.1 \
    DEVPI_WEB_VERSION=3.1.1 \
    DEVPI_CLIENT_VERSION=2.7.0 \
    DEVPI_CLEANER_VERSION=0.2.0 \
    DEVPI_SEMANTIC_UI_VERSION=0.2.2 \
    DEVPI_THEME=semantic-ui

RUN apk add --no-cache --virtual .build-deps gcc python3-dev libffi-dev musl-dev \
    && pip install devpi-server==$DEVPI_SERVER_VERSION \
        devpi-web==$DEVPI_WEB_VERSION \
        devpi-client==$DEVPI_CLIENT_VERSION \
        devpi-cleaner==$DEVPI_CLEANER_VERSION \
        devpi-semantic-ui==$DEVPI_SEMANTIC_UI_VERSION \
    && apk del .build-deps \
    && rm -r /root/.cache


ENV DEVPI_SERVERDIR /devpi/server

RUN mkdir -p $DEVPI_SERVERDIR

ENV DEVPI_CLIENTDIR /devpi/client

RUN mkdir -p $DEVPI_CLIENTDIR

VOLUME $DEVPI_SERVERDIR $DEVPI_CLIENTDIR

ENV DEVPI_PORT 3141

EXPOSE $DEVPI_PORT

COPY serve.sh /

CMD ["/serve.sh"]
