FROM redis:7-alpine

RUN apk add --no-cache openssl bash

COPY --link --chmod=755 start.sh /usr/bin/start.sh

# Give root a random password
RUN echo "root:$(openssl rand -base64 12)" | chpasswd

USER redis
ENTRYPOINT ["start.sh"]
