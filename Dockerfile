ARG ARSVERSION="latest"
ARG GITHUBOWNER="bestnaf"
ARG GITHUBREPO="ARS"
ARG GBINSTALLLOC="/opt/gunbot"
ARG GBMOUNT="/mnt/gunbot"
ARG ARS="ARS_lin.zip"
ARG GUNBOTVERSION
ARG GBPORT=5000
ARG MAINTAINER="computeronix"
ARG WEBSITE="https://hub.docker.com/r/computeronix/ars"
ARG DESCRIPTION="(Unofficial) ARS Docker Container - ${GUNBOTVERSION} - ${ARSVERSION}

#SCRATCH WORKSPACE FOR BUILDING IMAGE
FROM --platform="linux/amd64" debian:bullseye AS ars-builder
ARG ARSVERSION
ARG GITHUBOWNER
ARG GITHUBREPO
ARG GBINSTALLLOC
ARG GBMOUNT

WORKDIR /tmp

#BUILDING IMAGE
#update mirrors and install packages
RUN apt-get update && apt-get install -y wget jq unzip \
  #remove mirrors
  && rm -rf /var/lib/apt/lists/* \
  #pull ${ARSVERSION} from official GitHub and extract linux client
  && wget -q -nv -O ars.zip $(wget -q -nv -O- https://api.github.com/repos/${GITHUBOWNER}/${GITHUBREPO}/releases/${ARSVERSION} 2>/dev/null |  jq -r '.assets[] | select(.browser_download_url | contains("lin.zip")) | .browser_download_url') \
  && unzip -d . ars.zip \
  && mkdir -p gunbot/ARS \
  && mv Lin/* gunbot/ARS \
  #injecting into custom.sh
  #check for ARS directory BUT don't link it for persistence
  && printf "if [ ! -d ${GBMOUNT}/ARS ]; then \n" >> gunbot/custom.sh \
  && printf "	mkdir ${GBMOUNT}/ARS\n" >> gunbot/custom.sh \
  && printf "fi\n" >> gunbot/custom.sh \
  #check for USR_VARS.ini file
  && printf "if [ ! -f ${GBMOUNT}/ARS/USR_VARS.ini ]; then \n" >> gunbot/custom.sh \
  && printf "cp ${GBINSTALLLOC}/ARS/USR_VARS_example.ini ${GBMOUNT}/ARS/USR_VARS.ini\n" >> gunbot/custom.sh \
  && printf "fi\n" >> gunbot/custom.sh \
  && printf "ln -sf ${GBMOUNT}/ARS/USR_VARS.ini ${GBINSTALLLOC}/ARS/USR_VARS.ini\n" >> gunbot/custom.sh \
  #check for config.py file
  && printf "if [ ! -f ${GBMOUNT}/ARS/config.py ]; then \n" >> gunbot/custom.sh \
  && printf "wget -q -nv -O /tmp/config.py https://raw.githubusercontent.com/computeronix/docker-ars/master/config_example.py \n" >> gunbot/custom.sh \
  && printf "cp /tmp/config.py ${GBMOUNT}/ARS/config.py\n" >> gunbot/custom.sh \
  && printf "fi\n" >> gunbot/custom.sh \
  && printf "ln -sf ${GBMOUNT}/ARS/config.py ${GBINSTALLLOC}/ARS/config.py\n" >> gunbot/custom.sh \
  #check for gunbot_console.log file
  && printf "ln -sf ${GBMOUNT}/gunbot_console.log ${GBINSTALLLOC}/gunbot_console.log\n" >> gunbot/custom.sh \
  #inject config -> MM_PATH -> gunbot location
  && printf "input=\"${GBINSTALLLOC}/ARS/USR_VARS.ini\"\n" >> gunbot/custom.sh \
  && printf "while IFS= read -r line\n" >> gunbot/custom.sh \
  && printf "do\n" >> gunbot/custom.sh \
  && printf "if [[ \"\${line}\" == *\"MM_PATH\"* ]]; then\n" >> gunbot/custom.sh \
  && printf "  line=\"MM_PATH = ${GBINSTALLLOC}\"\n" >> gunbot/custom.sh \
  && printf "fi\n" >> gunbot/custom.sh \
  && printf "echo \"\${line}\" >> /tmp/USR_VARS_tmp.ini\n" >> gunbot/custom.sh \
  && printf "done < \"\${input}\"\n" >> gunbot/custom.sh \
  && printf "cat /tmp/USR_VARS_tmp.ini > ${GBINSTALLLOC}/ARS/USR_VARS.ini\n" >> gunbot/custom.sh \
  #overwrite runner.sh bash script
  && printf "#!/bin/bash\n" > gunbot/runner.sh \
  #run gunbot
  && printf "${GBINSTALLLOC}/gunthy-linux > gunbot_console.log 2>&1 &" >> gunbot/runner.sh \
  #change working directory to ars
  && printf "cd ${GBINSTALLLOC}/ARS\n" >> gunbot/runner.sh \
  #run ars
  && printf "${GBINSTALLLOC}/ARS/mm_anti_rekt\n" >> gunbot/runner.sh

#BUILD THE RUN IMAGE
FROM --platform="linux/amd64" computeronix/gunbot:${GUNBOTVERSION}
ARG MAINTAINER
ARG WEBSITE
ARG DESCRIPTION
ARG GBINSTALLLOC
ARG GBPORT
ENV GUNBOTLOCATION=${GBINSTALLLOC}

LABEL \
  maintainer="${MAINTAINER}" \
  website="${WEBSITE}" \
  description="${DESCRIPTION}"

COPY --from=ars-builder /tmp/gunbot ${GBINSTALLLOC}

WORKDIR ${GBINSTALLLOC}

RUN apt-get update && apt-get install -y wget python \
  && rm -rf /var/lib/apt/lists/* \
  && chmod +x "${GBINSTALLLOC}/custom.sh" \
  && chmod +x "${GBINSTALLLOC}/runner.sh" \
  && chmod +x "${GBINSTALLLOC}/ARS/mm_anti_rekt"

EXPOSE ${GBPORT}
CMD ["bash","-c","${GUNBOTLOCATION}/startup.sh"]
