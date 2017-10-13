# link: https://github.com/kartoza/docker-postgis/blob/develop/Dockerfile
FROM kartoza/postgis
RUN apt-get -qqy update && apt-get -qqy --no-install-recommends install \
	screen \
	reptyr \
	&& rm -rf /var/lib/apt/lists/* /var/cache/apt/*
ADD sql /sql
#WORKDIR /sql
RUN chmod 0755 /sql/restore_backup.sh
# link: http://goinbigdata.com/docker-run-vs-cmd-vs-entrypoint/
CMD /sql/restore_backup.sh