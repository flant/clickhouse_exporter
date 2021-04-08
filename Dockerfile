FROM golang:1.15-alpine3.12 AS BUILD

ENV CLICKHOUSE_EXPORTER_RELEASE master
ENV CLICKHOUSE_EXPORTER_COMMIT feaaedaa072aaed3b776147007a2a8686780b9ce
ENV BUILD_PATH /go/src/github.com/Percona-Lab
ENV GIT_REPO https://github.com/ClickHouse/clickhouse_exporter.git

RUN mkdir -p ${BUILD_PATH} && \
    apk add --no-cache make git && \
    cd ${BUILD_PATH} && \
    git clone ${GIT_REPO} -b ${CLICKHOUSE_EXPORTER_RELEASE} && \
    cd clickhouse_exporter && \
    git checkout ${CLICKHOUSE_EXPORTER_COMMIT} && \
    export GO111MODULE=on && make init && \
    unset GO111MODULE && make build

FROM alpine:3.12

COPY --from=BUILD /go/bin/clickhouse_exporter /usr/local/bin/clickhouse_exporter

ENTRYPOINT ["/usr/local/bin/clickhouse_exporter"]

CMD ["-scrape_uri=http://localhost:8123"]

EXPOSE 9116
