FROM python:3.10-alpine as build
COPY requirements.txt .
RUN pip3 install -r requirements.txt

FROM scratch
COPY --from=build / /
