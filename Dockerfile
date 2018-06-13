FROM python:3.6

RUN mkdir /app
WORKDIR /app
COPY backend/requirements.txt /app/backend/
COPY ssl /app/ssl
COPY dist /app/dist
COPY app.py /app/

RUN pwd
RUN ls -l 
RUN pip install -r /app/backend/requirements.txt
RUN ls -l 

#WORKDIR /app
ENV FLASK_APP=app.py
ENV FLASK_DEBUG=1 
ENTRYPOINT ["python"]
CMD ["app.py"]