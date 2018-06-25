FROM alpine:3.6

RUN apk update \
    && apk upgrade \
    && apk add --no-cache bash \
    && adduser nrpportal -u 10000 -D
RUN apk add --no-cache python3
RUN apk add --update py-pip
RUN pip install --upgrade pip
RUN chown -R nrpportal:nrpportal /home/nrpportal

WORKDIR /home/nrpportal/
COPY backend/ /home/nrpportal/backend/
COPY ssl /home/nrpportal/ssl
COPY dist /home/nrpportal/dist

RUN pip install -r /home/nrpportal/backend/requirements.txt

USER nrpportal

ENV FLASK_APP=app.py
ENV FLASK_DEBUG=1 
ENTRYPOINT ["python"]
CMD ["backend/app.py"]