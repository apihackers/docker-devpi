FROM apihackers/python3

RUN apk add --update bash && rm -rf /var/cache/apk/*

ENV DEVPI_SERVER_VERSION=3.1.0 \
    DEVPI_WEB_VERSION=3.1.0 \
    DEVPI_CLIENT_VERSION=2.6.2 \
    DEVPI_CLEANER_VERSION=0.2.0

RUN pip install devpi-server==$DEVPI_SERVER_VERSION \
                devpi-web==$DEVPI_WEB_VERSION \
                devpi-client==$DEVPI_CLIENT_VERSION \
                devpi-cleaner==$DEVPI_CLEANER_VERSION \
                && rm -r /root/.cache

ENV DEVPI_SERVERDIR /devpi

RUN mkdir -p $DEVPI_SERVERDIR

ENV DEVPI_CLIENTDIR /clientdir

RUN mkdir -p $DEVPI_CLIENTDIR

VOLUME $DEVPI_SERVERDIR $DEVPI_CLIENTDIR

ENV DEVPI_PORT 3141

EXPOSE $DEVPI_PORT

COPY serve.sh /

CMD ["/serve.sh"]
