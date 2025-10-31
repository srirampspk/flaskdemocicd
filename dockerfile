FROM  python:3.11-slim

COPY . /cicddemo

EXPOSE  5000

WORKDIR /cicddemo

RUN pip install --no-cache-dir -r requriments.txt

CMD ["python","app.py"]
