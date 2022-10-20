FROM alpine:3.15.0

RUN apk add --update --no-cache bash &&\
    apk add --no-cache curl &&\
    apk add --no-cache git &&\
    apk add --no-cache jq

COPY pipe /
COPY LICENSE pipe.yml README.md /
RUN wget -P / https://bitbucket.org/bitbucketpipelines/bitbucket-pipes-toolkit-bash/raw/0.4.0/common.sh

RUN chmod a+x /*.sh

ENTRYPOINT ["/pipe.sh"]
