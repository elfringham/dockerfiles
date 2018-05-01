FROM arm64v8/golang:1.9

RUN mkdir -p /go/src/github.com/coreos \
  && git clone -b release-3.2 https://github.com/coreos/etcd.git /go/src/github.com/coreos/etcd \
  && cp -r /go/src/github.com/coreos/etcd/cmd/vendor /go/src/github.com/coreos/etcd/vendor

ENV ETCD_UNSUPPORTED_ARCH=arm64
RUN go install github.com/coreos/etcd

EXPOSE 2379 2380

CMD ["etcd"]
