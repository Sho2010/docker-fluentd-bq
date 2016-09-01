FROM fluent/fluentd:v0.12.26

MAINTAINER Sho2010 "sho20100@gmail.com"

# install bigdecimal native extension and bigquery plugin
USER root
RUN apk --no-cache --update add \
                            git \
                            build-base \
                            ruby-dev && \
    gem install bigdecimal && \
    gem install specific_install && \
    gem specific_install https://github.com/kaizenplatform/fluent-plugin-bigquery.git && \
    apk del build-base ruby-dev git && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

RUN mkdir /var/log/fluentd && chown fluent:fluent /var/log/fluentd/

USER fluent
WORKDIR /home/fluent

ENV PATH /home/fluent/.gem/ruby/2.3.0/bin:$PATH
RUN gem install fluent-plugin-secure-forward

COPY fluent.conf /fluentd/etc/
COPY plugins/. /fluentd/plugins/


EXPOSE 24284
CMD fluentd -c /fluentd/etc/$FLUENTD_CONF -p /fluentd/plugins $FLUENTD_OPT

