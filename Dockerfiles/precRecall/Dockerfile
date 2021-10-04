FROM rocker/tidyverse:4.1.0
MAINTAINER Jeremy Leipzig <leipzig@gmail.com>

#https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.created="2021-08-10T18:50:32Z"
LABEL org.opencontainers.image.version="0.1.0"
LABEL org.opencontainers.image.title = "intervene"
LABEL org.opencontainers.image.authors = "Jeremy Leipzig<leipzig@gmail.com>"
LABEL org.opencontainers.image.description = "precRecall"
LABEL org.opencontainers.image.revision = "7f6e0dd99e1b2f9f05833a4fecf02c1518badf05"
LABEL org.opencontainers.image.url = "https://bitbucket.org/xdbio/bfx-docker-files"


RUN install2.r ggforce
RUN install2.r reshape2