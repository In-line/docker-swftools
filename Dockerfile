FROM ubuntu:trusty as builder

RUN apt-get update && apt-get install -y make g++ patch zlib1g-dev libgif-dev

ADD swftools swftools

WORKDIR swftools

RUN find | grep "\.o$"  | xargs rm || true

RUN ./configure --enable-optimizations --prefix=/build 

# Little kostil for faster and not failing builds, because autotools seems to not support multiprocess builds
RUN make -j4 || make
RUN make prefix=/build install

FROM debian:buster as runtime

COPY --from=builder /build /usr/

ENTRYPOINT ["swfrender"]
