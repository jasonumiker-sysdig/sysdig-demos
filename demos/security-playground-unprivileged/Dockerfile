FROM python:3.11.4-bullseye

RUN adduser -D python
USER python
WORKDIR /home/python

RUN pip install --user pipenv

ENV PATH="/home/python/.local/bin:${PATH}"

COPY --chown=python:python Pipfile Pipfile
RUN pipenv lock -r > requirements.txt
RUN pip install --user -r requirements.txt

COPY app.py /app

EXPOSE 8080

CMD ["gunicorn", "-b", ":8080", "--workers", "2", "--threads", "4", "--worker-class", "gthread", "--access-logfile", "-", "--error-logfile", "-", "app:app"]
