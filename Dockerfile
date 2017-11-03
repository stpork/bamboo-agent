FROM stpork/bamboo-centos-base

MAINTAINER stpork from Mordor team

ENV BAMBOO_AGENT_VERSION	6.2.2
ENV BAMBOO_AGENT_INSTALL	${BAMBOO_HOME}/bamboo-agent
ENV BAMBOO_AGENT_USER		daemon
ENV BAMBOO_AGENT_GROUP		daemon

ARG BAMBOO_AGENT_URL=https://bitbucket.org/stpork/bamboo-agent/downloads/atlassian-bamboo-agent-installer-${BAMBOO_AGENT_VERSION}.jar
ARG M2_URL=https://bitbucket.org/stpork/bamboo-agent/downloads/settings.xml

# Set the labels that are used for OpenShift to describe the builder image.
LABEL io.k8s.description="Atlassian Bamboo Agent"
LABEL io.k8s.display-name="Bamboo Agent 6.2.2"

USER root

RUN mkdir -p ${BAMBOO_AGENT_INSTALL} \
    && curl -o ${BAMBOO_AGENT_INSTALL}/bamboo-agent-installer.jar -L --silent ${BAMBOO_AGENT_URL} \
    && mkdir -p ${BAMBOO_AGENT_INSTALL} \
    && mkdir -p ${HOME}/.m2 \
    && curl -o ${HOME}/.m2/settings.xml -L --silent ${M2_URL} \
    && chown -R ${BAMBOO_USER}:${BAMBOO_GROUP} ${BAMBOO_AGENT_INSTALL} \
    && chmod -R 777 ${BAMBOO_AGENT_INSTALL} 

USER ${BAMBOO_USER}:${BAMBOO_GROUP}

COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
ENTRYPOINT ["/usr/bin/tini", "--"]