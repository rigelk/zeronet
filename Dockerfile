FROM alpine:3.6

ENV UID=991 GID=991 \
    PROJECT_VER=0.5.6

VOLUME /data
COPY launch /
RUN echo '@testing http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories \
    && apk -U add py-gevent@testing py-msgpack@testing wget ca-certificates python tor@testing su-exec \
    && echo -e "ControlPort 9051\nSocksPort 9050" > /etc/tor/torrc \
    && cd /tmp/ \
    && mkdir -p /ZeroNet/ \
    && wget -q https://github.com/HelloZeroNet/ZeroNet/archive/v$PROJECT_VER.tar.gz -O zeronet.tar.gz \
    && tar xpzf zeronet.tar.gz \
    && mv ZeroNet-$PROJECT_VER/* /ZeroNet/ \
    && rm -f zeronet.tar.gz \
    && apk del wget \
    && rm -rf /var/cache/apk/* /tmp/* /root/.gnupg /root/.cache/ \
    && cd /ZeroNet/ \
    && mkdir log \
    && touch log/error.log \
    && ln -sv /data ./data \
    && chmod +x /launch

EXPOSE 43110 15441
ENTRYPOINT ["/launch"]
CMD ["env", "UIPASSWORD=false", "ENABLE_TOR=true", "python", "/ZeroNet/zeronet.py", "--ui_ip", "0.0.0.0"]
