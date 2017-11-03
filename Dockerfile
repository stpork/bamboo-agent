FROM stpork/bamboo-centos-base

MAINTAINER stpork from Mordor team

ENV BAMBOO_AGENT_VERSION 	6.2.2
ENV BAMBOO_AGENT_INSTALL 	/opt/atlassian/bamboo-agent
ENV BAMBOO_AGENT_HOME 		/var/atlassian/application-data/bamboo-agent
ENV BAMBOO_AGENT_USER       daemon
ENV BAMBOO_AGENT_GROUP		daemon

ARG BAMBOO_AGENT_URL=https://bitbucket.org/stpork/bamboo-agent/downloads/atlassian-bamboo-agent-installer-${BAMBOO_AGENT_VERSION}.jar

# Set the labels that are used for OpenShift to describe the builder image.
LABEL io.k8s.description="Atlassian Bamboo Agent"
LABEL io.k8s.display-name="Bamboo Agent 6.2.2"

USER root

RUN mkdir -p ${BAMBOO_AGENT_INSTALL} \
	&& curl -o ${BAMBOO_AGENT_INSTALL}/bamboo-agent-installer.jar -L --silent ${BAMBOO_AGENT_URL} \
	&& mkdir -p ${BAMBOO_AGENT_INSTALL} \
    && mkdir -p ${BAMBOO_AGENT_HOME}  \
	&& chown -R ${BAMBOO_USER}:${BAMBOO_GROUP} ${BAMBOO_AGENT_INSTALL} \
	&& chown -R ${BAMBOO_USER}:${BAMBOO_GROUP} ${BAMBOO_AGENT_HOME}

USER ${BAMBOO_USER}:${BAMBOO_GROUP}

EXPOSE 8085
EXPOSE 54663

VOLUME ["${BAMBOO_AGENT_HOME}"]

WORKDIR ${BAMBOO_AGENT_HOME}

COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
ENTRYPOINT ["/usr/bin/tini", "--"]