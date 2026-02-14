FROM pgvector/pgvector:0.8.1-pg16-bookworm

LABEL maintainer="Heekang Park <park.heekang33@gmail.com>"
LABEL org.opencontainers.image.source="https://github.com/HeekangPark/pkg"
LABEL org.opencontainers.image.description="pkg (PostgreSQL Knowledge Graph) : arm64 + Debian 12(bookworm) + PostgreSQL 16 + pg_search 0.21.6 + pgvector 0.8.1 + Apache AGE 1.6"
LABEL org.opencontainers.image.licenses="MIT"

SHELL ["/bin/bash", "-c"]

# Install dependencies
RUN apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends curl build-essential libreadline-dev zlib1g-dev flex bison postgresql-server-dev-16 tzdata ca-certificates &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set locale to ko_KR.UTF-8
RUN localedef -i ko_KR -c -f UTF-8 -A /usr/share/locale/locale.alias ko_KR.UTF-8
ENV LANG=ko_KR.utf8

# Set timezone to Asia/Seoul
RUN ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime &&\
    dpkg-reconfigure -f noninteractive tzdata
ENV TZ=Asia/Seoul

# Install pg_search 0.21.6
RUN curl -L "https://github.com/paradedb/paradedb/releases/download/v0.21.6/postgresql-16-pg-search_0.21.6-1PARADEDB-bookworm_arm64.deb" -o /tmp/pg_search.deb &&\
    DEBIAN_FRONTEND=noninteractive apt-get install -y /tmp/pg_search.deb &&\
    rm -f /tmp/pg_search.deb &&\
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Apache AGE 1.6
RUN curl -L "https://github.com/apache/age/releases/download/PG16%2Fv1.6.0-rc0/apache-age-1.6.0-src.tar.gz" -o /tmp/apache-age.tar.gz && \
    tar -xzf /tmp/apache-age.tar.gz -C /tmp && \
    cd /tmp/apache-age-1.6.0 && \
    make install PG_CONFIG=/usr/lib/postgresql/16/bin/pg_config && \
    rm -rf /tmp/apache-age.tar.gz /tmp/apache-age-1.6.0

# Clean up build dependencies
RUN apt-get purge -y build-essential postgresql-server-dev-16 flex bison && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy entrypoint script to configure shared_preload_libraries
COPY --chmod=755 00-configure-shared-preload-libraries.sh /docker-entrypoint-initdb.d/