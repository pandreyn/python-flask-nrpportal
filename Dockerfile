FROM alpine:3.6

RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash \
    && apk add build-base \
    && apk add python3-dev \
    && adduser nrpportal -u 10000 -D
RUN apk add --no-cache python3
RUN apk add --update py-pip
RUN apk add postgresql-dev
RUN pip3 install --upgrade pip
RUN pip3 install psycopg2-binary
RUN chown -R nrpportal:nrpportal /home/nrpportal

WORKDIR /home/nrpportal/
COPY backend/ /home/nrpportal/backend/
COPY ssl /home/nrpportal/ssl
COPY dist /home/nrpportal/dist

RUN pip3 install -r /home/nrpportal/backend/requirements.txt

USER nrpportal

ENV FLASK_APP=app.py
ENV FLASK_DEBUG=1 
ENTRYPOINT ["python"]
CMD ["backend/app.py"]