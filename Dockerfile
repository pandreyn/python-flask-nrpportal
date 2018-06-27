FROM alpine:3.7

RUN apk add --update build-base 

RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

RUN pip install virtualenv \
  && rm -rf /var/cache/apk/*

RUN adduser nrpportal -u 10000 -D
RUN chown -R nrpportal:nrpportal /home/nrpportal

WORKDIR /home/nrpportal/
COPY backend/ /home/nrpportal/backend/
COPY ssl /home/nrpportal/ssl
COPY dist /home/nrpportal/dist

RUN pip install -r /home/nrpportal/backend/requirements.txt

USER nrpportal

ENV FLASK_APP=app.py
ENV FLASK_DEBUG=1
ENV APP_SETTINGS="config.DevelopmentConfig"
ENV DATABASE_URL="postgres://flaskapp:pass2@localhost:5432/pgdb"
ENTRYPOINT ["python"]
CMD ["backend/app.py"]