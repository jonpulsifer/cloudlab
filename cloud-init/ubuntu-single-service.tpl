#cloud-config
apt:
  preserve_sources_list: true
  sources:
    datadog.list:
      source: "deb http://apt.datadoghq.com/ stable 7"
      keyid: A2923DFF56EDA6E76E55E492D3A80E30382E94DE
    os-config.list:
      source: "deb http://packages.cloud.google.com/apt google-osconfig-agent-stable main"
      key: | # 54A647F9048D5688D7DA2ABE6A030B21BA07F4FB
          -----BEGIN PGP PUBLIC KEY BLOCK-----

          mQENBFrBaNsBCADrF18KCbsZlo4NjAvVecTBCnp6WcBQJ5oSh7+E98jX9YznUCrN
          rgmeCcCMUvTDRDxfTaDJybaHugfba43nqhkbNpJ47YXsIa+YL6eEE9emSmQtjrSW
          IiY+2YJYwsDgsgckF3duqkb02OdBQlh6IbHPoXB6H//b1PgZYsomB+841XW1LSJP
          YlYbIrWfwDfQvtkFQI90r6NknVTQlpqQh5GLNWNYqRNrGQPmsB+NrUYrkl1nUt1L
          RGu+rCe4bSaSmNbwKMQKkROE4kTiB72DPk7zH4Lm0uo0YFFWG4qsMIuqEihJ/9KN
          X8GYBr+tWgyLooLlsdK3l+4dVqd8cjkJM1ExABEBAAG0QEdvb2dsZSBDbG91ZCBQ
          YWNrYWdlcyBBdXRvbWF0aWMgU2lnbmluZyBLZXkgPGdjLXRlYW1AZ29vZ2xlLmNv
          bT6JATgEEwECACwFAlrBaNsJEGoDCyG6B/T7AhsPBQkFo5qABgsJCAcDAgYVCAIJ
          CgsEFgIDAQAAJr4IAM5lgJ2CTkTRu2iw+tFwb90viLR6W0N1CiSPUwi1gjEKMr5r
          0aimBi6FXiHTuX7RIldSNynkypkZrNAmTMM8SU+sri7R68CFTpSgAvW8qlnlv2iw
          rEApd/UxxzjYaq8ANcpWAOpDsHeDGYLCEmXOhu8LmmpY4QqBuOCM40kuTDRd52PC
          JE6b0V1t5zUqdKeKZCPQPhsS/9rdYP9yEEGdsx0V/Vt3C8hjv4Uwgl8Fa3s/4ag6
          lgIf+4SlkBAdfl/MTuXu/aOhAWQih444igB+rvFaDYIhYosVhCxP4EUAfGZk+qfo
          2mCY3w1pte31My+vVNceEZSUpMetSfwit3QA8EE=
          =csu4
          -----END PGP PUBLIC KEY BLOCK-----
package_update: true
package_upgrade: true
packages:
 - apt-transport-https
 - datadog-agent
 - dirmngr
 - google-osconfig-agent
 - iptables
 - wireguard

write_files:
 - path: /etc/modules-load.d/wireguard.conf
   content: wireguard
 - path: /etc/sysctl.d/ip-forwarding.conf
   content: net.ipv4.ip_forward=1

runcmd:
- mkdir -m 700 -p /var/cloudlab
- gsutil -m cp -r gs://cloud-lab/services /var/cloudlab

# datadog agent
- cp /var/cloudlab/services/datadog.service /etc/systemd/system/
- cp -v /var/cloudlab/services/datadog.yaml /etc/datadog-agent/datadog.yaml
- chown dd-agent:dd-agent /etc/datadog-agent/datadog.yaml
- systemctl daemon-reload
- systemctl enable datadog-agent

# wireguard
- cp /var/cloudlab/services/wireguard/server.conf /etc/wireguard/wg0.conf
- chmod 600 /etc/wireguard/wg0.conf
- systemctl daemon-reload
- systemctl enable wg-quick@wg0

# ejson2env
- wget -qO /usr/bin/ejson2env https://github.com/Shopify/ejson2env/releases/download/v2.0.0/linux-amd64
- chmod +x /usr/bin/ejson2env
- mkdir -m 700 -p /opt/ejson
- gsutil -m cp -r gs://cloud-lab/ejson /var/cloudlab
- ln -sf /var/cloudlab/ejson/keys /opt/ejson/keys

# - ejson2env -q /var/${name}/services/${name}.ejson > /var/${name}/services/${name}.env
# - systemctl enable cloudlab.service
# - systemctl enable ${name}.service
# - systemctl start cloudlab.service

power_state:
 delay: "now"
 mode: reboot
 message: Cloud Init Complete
 timeout: 1
 condition: True
