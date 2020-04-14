#cloud-config

# bootstrap
runcmd:
# copy services and scripts
- mkdir -m 700 -p /var/{cloudlab,${name}}
- docker run --rm -v /var/cloudlab:/tmp -w /tmp gcr.io/cloud-builders/gsutil -m cp -r gs://cloud-lab/services .
- cp /var/cloudlab/services/*.service /etc/systemd/system/

# install gvisor
- systemctl stop docker
- mkdir -m 755 -p /var/lib/runsc
- wget -qO /var/lib/docker/runsc https://storage.googleapis.com/gvisor/releases/nightly/latest/runsc
- wget -qO /var/lib/docker/runsc.sha512 https://storage.googleapis.com/gvisor/releases/nightly/latest/runsc.sha512
- pushd /var/lib/docker && sha512sum -c runsc.sha512 && popd
- chmod a+x /var/lib/docker/runsc
- cp /var/cloudlab/services/docker/daemon.json /etc/docker/daemon.json
- systemctl start docker

# copy ejson keys
- docker run --rm -v /var/cloudlab:/tmp -w /tmp gcr.io/cloud-builders/gsutil -m cp -r gs://cloud-lab/ejson .

# decrypt ejson secrets for containers
# TODO dont do this here
- HOME=/var/cloudlab docker-credential-gcr configure-docker
- HOME=/var/cloudlab docker run --rm -v /var/cloudlab/ejson/keys:/opt/ejson/keys:ro -v /var/cloudlab/services:/tmp -w /tmp gcr.io/trusted-builds/ejson2env -q datadog.ejson > /var/cloudlab/services/datadog.env
- HOME=/var/cloudlab docker run --rm -v /var/${name}/ejson/keys:/opt/ejson/keys:ro -v /var/${name}/services:/tmp -w /tmp gcr.io/trusted-builds/ejson2env -q ${name}.ejson > /var/${name}/services/${name}.env

# create docker networks
- docker network create -d bridge --subnet=172.31.0.0/24 --ip-range=172.31.0.0/28 cloudlab

# enable services
- systemctl daemon-reload
- systemctl enable cloudlab.service
- systemctl enable datadog.service
- systemctl enable ${name}.service
- systemctl start cloudlab.service
