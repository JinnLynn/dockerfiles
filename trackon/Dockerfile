FROM jinnlynn/python

ADD https://github.com/JinnLynn/newtrackon.git /app/opt

WORKDIR /app/opt

RUN set -ex && \
    apk add --no-cache curl && \
    pip install --no-cache-dir -r requirements.txt && \
    xinfo python --clean-cache

VOLUME /app/opt/data

EXPOSE 8080

ENTRYPOINT [ "python", "run.py" ]
