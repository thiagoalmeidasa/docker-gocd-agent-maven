# Copyleft (ↄ) 2017 Thiago Almeida <thiagoalmeidasa@gmail.com>
#
# Distributed under terms of the GPLv2 license.

FROM maven:3-jdk-8
LABEL MAINTAINER="Thiago Almeida <thiagoalmeidasa@gmail.com>"
LABEL VERSION="1.0"

# ENVS
ENV LOG4J_PROPERTIES_URL "https://raw.githubusercontent.com/gocd-contrib/docker-elastic-agents/master/contrib/scripts/bootstrap-without-installed-agent/log4j.properties"
ENV GO_AGENT_URL "https://raw.githubusercontent.com/gocd-contrib/docker-elastic-agents/master/contrib/scripts/bootstrap-without-installed-agent/go-agent"


# Download tini to ensure that an init process exists
ADD https://github.com/krallin/tini/releases/download/v0.14.0/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# Add a user to run the go agent
RUN useradd go -m -d /go

# Ensure that the container logs on stdout
ADD $LOG4J_PROPERTIES_URL /go/log4j.properties
ADD $LOG4J_PROPERTIES_URL /go/go-agent-log4j.properties

ADD $GO_AGENT_URL /go/go-agent
RUN chmod 755 /go/go-agent

# Run the bootstrapper as the `go` user
USER go
CMD /go/go-agent
