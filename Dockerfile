FROM ubuntu:20.04 as builder

RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

RUN DEBIAN_FRONTEND=noninteractive \
	apt-get update && apt-get install -y build-essential tzdata pkg-config \
	wget clang git

RUN wget https://go.dev/dl/go1.19.1.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.19.1.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

ADD . /goimagehash
WORKDIR /goimagehash

ADD fuzzers/fuzz_imagehash.go ./fuzzers/
WORKDIR ./fuzzers/
RUN go mod init fuzzimagehash
RUN go get github.com/corona10/goimagehash
RUN go build

FROM ubuntu:20.04
COPY --from=builder /goimagehash/fuzzers/fuzzimagehash /
COPY --from=builder /goimagehash/_examples/*.jpg /testsuite/

ENTRYPOINT []
CMD ["/fuzzimagehash", "@@"]
