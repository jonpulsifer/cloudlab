FROM vault:1.1.3
# uid=100(vault) gid=1000(vault) groups=1000(vault),1000(vault)
ADD --chown=100:1000 docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["vault", "server", "-dev"]
