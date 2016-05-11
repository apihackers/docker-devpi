FROM apihackers/python3

RUN apk add --update bash && rm -rf /var/cache/apk/*

COPY requirements.txt /tmp/requirements.txt

RUN pip install -r /tmp/requirements.txt\
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
