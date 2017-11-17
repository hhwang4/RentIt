FROM mysql:5.6.26
ADD example-schema.sql /docker-entrypoint-initdb.d/
ADD team033_p2_schema.sql /docker-entrypoint-initdb.d/
ADD y-storedProcs.sql /docker-entrypoint-initdb.d/
ADD tool_storedProcs.sql /docker-entrypoint-initdb.d/
ADD zseed.sql /docker-entrypoint-initdb.d/