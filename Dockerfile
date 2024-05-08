ARG BASE
FROM $BASE
RUN apk add --update tcpdump && rm -rf /var/cache/apk/*
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
CMD ["tcpdump"]