FROM kartoza/postgis
ADD sql /sql
#WORKDIR /sql
RUN chmod 0755 /sql/restore_backup.sh
CMD /sql/restore_backup.sh