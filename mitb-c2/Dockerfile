FROM python:3.9-slim

WORKDIR /app

COPY c2-server.py .

RUN pip install flask

EXPOSE 5001

CMD ["python", "c2-server.py"]

