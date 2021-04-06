FROM golang:1.15-alpine3.12 AS BUILD

ENV CLICKHOUSE_EXPORTER_RELEASE master
ENV BUILD_PATH /go/src/github.com/Percona-Lab
ENV GIT_REPO https://github.com/ClickHouse/clickhouse_exporter.git

RUN mkdir -p ${BUILD_PATH} && \
    apk add --no-cache make git && \
    cd ${BUILD_PATH} && \
    git clone ${GIT_REPO} -b ${CLICKHOUSE_EXPORTER_RELEASE} && \
    cd clickhouse_exporter && \
    export GO111MODULE=on && make init && \
    unset GO111MODULE && make build

FROM alpine:3.12

COPY --from=BUILD /go/bin/clickhouse_exporter /usr/local/bin/clickhouse_exporter

ENTRYPOINT ["/usr/local/bin/clickhouse_exporter"]

CMD ["-scrape_uri=http://localhost:8123"]

EXPOSE 9116
