# This is a fluentd container that will watch all files in a given directory recursively

FROM ubuntu:14.04
MAINTAINER david.siaw@mobingi.com

RUN apt-get update
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

COPY sysctl.conf /etc/sysctl.conf

RUN apt-get install -y ruby ruby-dev build-essential git

RUN gem install bundler --no-ri --no-rdoc
RUN gem install fluentd --no-ri --no-rdoc
RUN fluentd --setup /fluent
RUN mkdir -p /var/log/fluentd
COPY fluent.conf /fluent/fluent.conf

RUN gem install fluent-plugin-cloudwatch-logs --no-ri --no-rdoc

ENV AWS_REGION us-west-2
ENV AWS_ACCESS_KEY_ID loggingaccesskey
ENV AWS_SECRET_ACCESS_KEY loggingsecretaccesskey
ENV MOCLOUD_LOG_GROUP test-group-name
ENV MOCLOUD_LOG_STREAM test-stream-name

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
