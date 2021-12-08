FROM alpine:latest

RUN apk update \
  && apk upgrade \
  && apk add --no-cache --update python3 py3-pip \
  && pip install --no-cache-dir flask \
  && apk del py3-pip \
  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /var/lib/apt/lists/*

WORKDIR /opt/hw5-app
COPY hw5-app /opt/hw5-app

ENV FLASK_APP=/opt/hw5-app/my-app.py
EXPOSE 8080

CMD ["flask", "run", "--host=0.0.0.0", "--port=8080"]
