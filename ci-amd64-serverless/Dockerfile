FROM python:3.7-buster

WORKDIR /usr/src/ci-serverless

COPY Pipfile* ./

RUN pip install pipenv awscli && \
  pipenv install --deploy --system --dev && \
  aws configure set default.region us-east-1

RUN curl -o terraform.zip https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip && \
  unzip terraform.zip && \
  mv terraform /bin/ && \
  rm terraform.zip

ENV LC_ALL C.UTF-8

