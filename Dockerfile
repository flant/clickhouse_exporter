FROM golang:1.16-alpine3.14 AS BUILD

ENV CLICKHOUSE_EXPORTER_RELEASE master
ENV CLICKHOUSE_EXPORTER_COMMIT abefd8b7803076a713daec4fb369fca5fc261942
ENV BUILD_PATH /go/src/github.com/ClickHouse
ENV GIT_REPO https://github.com/ClickHouse/clickhouse_exporter.git

RUN mkdir -p ${BUILD_PATH} && \
    apk add --no-cache make git && \
    cd ${BUILD_PATH} && \
    git clone ${GIT_REPO} -b ${CLICKHOUSE_EXPORTER_RELEASE} && \
    cd clickhouse_exporter && \
    git checkout ${CLICKHOUSE_EXPORTER_COMMIT} && \
    make init && \
    make build

FROM alpine:3.14

COPY --from=BUILD /go/bin/clickhouse_exporter /usr/local/bin/clickhouse_exporter

ENTRYPOINT ["/usr/local/bin/clickhouse_exporter"]

CMD ["-scrape_uri=http://localhost:8123"]

EXPOSE 9116
