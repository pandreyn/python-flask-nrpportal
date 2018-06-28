FROM python:3-alpine3.7

RUN adduser nrpportal -u 10000 -D
RUN chown -R nrpportal:nrpportal /home/nrpportal

WORKDIR /home/nrpportal/
COPY backend/ /home/nrpportal/backend/
COPY ssl /home/nrpportal/ssl
COPY dist /home/nrpportal/dist

RUN apk update && \
    apk add postgresql-libs && \
    apk add --virtual .build-deps gcc musl-dev postgresql-dev && \
    python3 -m pip install -r /home/nrpportal/backend/requirements.txt --no-cache-dir && \
    apk --purge del .build-deps

USER nrpportal

ENV FLASK_APP=app.py
ENV FLASK_DEBUG=1
ENV APP_SETTINGS="config.DevelopmentConfig"
ENV DATABASE_URL="postgres://flaskapp:pass2@localhost:5432/pgdb"
ENTRYPOINT ["python"]
CMD ["backend/app.py"]