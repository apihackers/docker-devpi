FROM apihackers/python3

RUN apk add --update --no-cache bash ca-certificates && update-ca-certificates

ENV DEVPI_SERVER_VERSION=4.1.0 \
    DEVPI_WEB_VERSION=3.1.1 \
    DEVPI_CLIENT_VERSION=2.6.4 \
    DEVPI_CLEANER_VERSION=0.2.0 \
    DEVPI_SEMANTIC_UI_VERSION=0.1.0 \
    DEVPI_THEME=semantic-ui

RUN pip install devpi-server==$DEVPI_SERVER_VERSION \
                devpi-web==$DEVPI_WEB_VERSION \
                devpi-client==$DEVPI_CLIENT_VERSION \
                devpi-cleaner==$DEVPI_CLEANER_VERSION \
                devpi-semantic-ui==$DEVPI_SEMANTIC_UI_VERSION \
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
