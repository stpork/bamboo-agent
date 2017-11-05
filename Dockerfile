FROM stpork/bamboo-centos-base

MAINTAINER stpork from Mordor team

ENV BAMBOO_VERSION=6.2.2 \
BAMBOO_AGENT_INSTALL=/opt/atlassian/bamboo-agent \
BAMBOO_SERVER_URL=http://bamboo:8085/agentServer/

ENV BAMBOO_AGENT_JAR=atlassian-bamboo-agent-installer-${BAMBOO_VERSION}.jar

LABEL io.k8s.description="Atlassian Bamboo Agent"
LABEL io.k8s.display-name="Bamboo Agent ${BAMBOO_VERSION}"

USER root

RUN BAMBOO_AGENT_URL=https://bitbucket.org/stpork/bamboo-agent/downloads/${BAMBOO_AGENT_JAR} \
&& M2_URL=https://bitbucket.org/stpork/bamboo-agent/downloads/settings.xml \
&& mkdir -p ${BAMBOO_AGENT_INSTALL} \
&& curl -o ${BAMBOO_AGENT_INSTALL}/${BAMBOO_AGENT_JAR} -fsSL ${BAMBOO_AGENT_URL} \
&& mkdir -p ${BAMBOO_AGENT_INSTALL} \
&& curl -o ${HOME}/.m2/settings.xml -fsSL ${M2_URL} \
&& chown -R ${RUN_USER}:${RUN_GROUP} ${BAMBOO_AGENT_INSTALL} \
&& chmod -R 777 ${BAMBOO_AGENT_INSTALL} 

USER ${RUN_USER}:${RUN_GROUP}

COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]
ENTRYPOINT ["/usr/bin/tini", "--"]
