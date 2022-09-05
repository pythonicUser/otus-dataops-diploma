FROM redash/redash:latest

ADD start.sh /
USER root
RUN chmod u+x /start.sh

ENTRYPOINT [ "/start.sh" ]