# Use Alpine to install LibreSSL packages by Orion
FROM docker.io/library/alpine:edge AS base
# Create user, install LibreSSL and certificates
RUN adduser -u 1000 -HDs /bin/false cryptoguy && \
    apk add libressl \
            libressl3.8-libcrypto \
            libressl3.8-libssl \
            libressl3.8-libtls \
            ca-certificates && \
    ln -s /usr/bin/libressl-openssl /usr/bin/openssl

# Use empty image as base
FROM scratch

# Copy needed stuff from base stage
COPY --from=base /usr/bin/libressl /usr/bin/libressl
COPY --from=base /usr/bin/libressl-ocspcheck /usr/bin/libressl-ocspcheck
COPY --from=base /usr/bin/libressl-openssl /usr/bin/libressl-openssl
COPY --from=base /usr/bin/ocspcheck /usr/bin/ocspcheck
COPY --from=base /usr/bin/openssl /usr/bin/openssl
COPY --from=base /etc/ssl /etc/ssl
COPY --from=base /usr/lib/libcrypto.so.52 /usr/lib/libcrypto.so.52
COPY --from=base /usr/lib/libcrypto.so.52.0.0 /usr/lib/libcrypto.so.52.0.0
COPY --from=base /usr/lib/libssl.so.55 /usr/lib/libssl.so.55
COPY --from=base /usr/lib/libssl.so.55.0.0 /usr/lib/libssl.so.55.0.0
COPY --from=base /usr/lib/libtls.so.28 /usr/lib/libtls.so.28
COPY --from=base /usr/lib/libtls.so.28.0.0 /usr/lib/libtls.so.28.0.0
COPY --from=base /usr/share/ca-certificates /usr/share/ca-certificates
COPY --from=base /etc/ca-certificates.conf /etc/ca-certificates.conf
COPY --from=base /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=base /etc/passwd /etc/passwd

WORKDIR /workdir
USER cryptoguy
ENTRYPOINT [ "openssl" ]
