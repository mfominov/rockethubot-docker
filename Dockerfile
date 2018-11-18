FROM node:8.12-alpine

LABEL maintainer="MAFominov" emain="maxfominov@gmail.com"

ENV HUBOT_USER="hubot" \
    HUBOT_HOME="/home/hubot" \
    NPM_CONFIG_LOGLEVEL="info" \
    NPM_CONFIG_REGISTRY="https://registry.npmjs.org/" \
    BOT_NAME="rocketbot" \
    BOT_OWNER="rocketbot own it self" \
    HUBOT_VERSION=2.0.0

RUN addgroup -g 1001 hubot  && \
        adduser -u 1001 -G hubot -D -h $HUBOT_HOME -s /sbin/nologin hubot && \
    chmod 755 $HUBOT_HOME && \
    apk add -U --no-cache git

RUN npm install -g yo generator-hubot hubot-rocketchat@$HUBOT_VERSION

USER $HUBOT_USER

WORKDIR $HUBOT_HOME

RUN yo hubot --owner=$BOT_OWNER --name=$BOT_NAME --adapter=rocketchat@$HUBOT_VERSION --defaults

CMD node -e "console.log(JSON.stringify('$EXTERNAL_SCRIPTS'.split(',')))" > external-scripts.json && \
    npm set registry $NPM_CONFIG_REGISTRY && \
    npm install $(node -e "console.log('$EXTERNAL_SCRIPTS'.split(',').join(' '))") && \
    node -e "console.log(JSON.stringify('$HUBOT_SCRIPTS'.split(',')))" > hubot-scripts.json && \
    bin/hubot -a rocketchat -n $BOT_NAME --alias $HUBOT_ALIAS
