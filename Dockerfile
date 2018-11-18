FROM node:8.12-alpine

LABEL maintainer="MAFominov" emain="maxfominov@gmail.com"

ENV HUBOT_USER hubot
ENV HUBOT_HOME /home/hubot
ENV NPM_REGISTRY https://registry.npmjs.org/
ENV BOT_NAME rocketbot
ENV BOT_OWNER rocketbot own it self
ENV HUBOT_VERSION 2.0.0

RUN groupadd -r hubot -g 1001 && \
        useradd -u 1001 -r -g hubot -m -d $HUBOT_HOME -s /sbin/nologin -c "Hubot user" hubot && \
    chmod 755 $HUBOT_HOME

RUN npm set registry $NPM_REGISTRY

RUN npm install -g yo generator-hubot hubot-rocketchat@$HUBOT_VERSION

USER $HUBOT_USER

RUN cd $HUBOT_HOME ; yo hubot --owner=$BOT_OWNER --name=$BOT_NAME --adapter=rocketchat@1.0.8 --defaults

WORKDIR $HUBOT_HOME

CMD node -e "console.log(JSON.stringify('$EXTERNAL_SCRIPTS'.split(',')))" > external-scripts.json && \
    npm set registry $NPM_REGISTRY && \
    npm install $(node -e "console.log('$EXTERNAL_SCRIPTS'.split(',').join(' '))") && \
    node -e "console.log(JSON.stringify('$HUBOT_SCRIPTS'.split(',')))" > hubot-scripts.json && \
    bin/hubot -a rocketchat -n $BOT_NAME --alias $HUBOT_ALIAS
