ARG ARCH=
FROM bayrell/alpine:3.11-1${ARCH}

RUN cd ~; \
	apk update; \
	apk add nodejs; \
	rm -rf /var/cache/apk/*; \
	addgroup -g 800 -S www; \
	adduser -D -H -S -G www -u 800 www; \
	echo 'Ok'
