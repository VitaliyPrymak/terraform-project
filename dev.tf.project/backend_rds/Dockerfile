FROM python:3.9-slim

WORKDIR /app

RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && apt-get clean

COPY requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt


COPY . /app/

EXPOSE 4000

CMD ["sh", "-c", "sleep 10 && python manage.py runserver 0.0.0.0:4000"]