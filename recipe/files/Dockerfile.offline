# GENERATED L-009 hermetic Java build (--network=none, SBOM+SLSA-attestation-producing).
# Pinned bases; vendored source + maven cache(s) + toolchain/runtime debs from Dockerfile.vendor.
FROM maven:3.9.8-eclipse-temurin-21@sha256:de18e4e51396ad9266f76669779ed6d6b49fbb0f45ed6f39169d87378d548d7d AS jbuild
# dpkg-install the vendored build toolchain (git/unzip) — no apt, fully offline.
RUN --mount=type=bind,source=vendored/build-debs,target=/tmp/bdebs \
    set --; for f in /tmp/bdebs/*.deb; do [ -e "$f" ] && set -- "$@" "$f"; done; \
    for pass in 1 2 3 4 5; do [ $# -eq 0 ] || dpkg -i --skip-same-version "$@" >/dev/null 2>&1 && break; done; \
    dpkg --configure -a && bad= && for d in "$@"; do p=$(dpkg-deb -f "$d" Package) v=$(dpkg-deb -f "$d" Version); \
      case "$(dpkg-query -W -f='${Version} ${db:Status-Abbrev}' "$p" 2>/dev/null)" in "$v ii"*) ;; *) bad="$bad $p=$v" ;; esac; done && \
    { [ -z "$bad" ] || { echo "vendored debs not installed at their vendored version:$bad" >&2; false; }; }
WORKDIR /src
COPY vendored/jenkins-src/ .
COPY vendored/caches/m2/ /m2/
COPY vendored/caches/corepack/ /corepack/
COPY vendored/caches/plugins/ /plugins/
ENV MAVEN_OPTS="-Xmx4g"
ENV COREPACK_HOME="/corepack"
ENV MAVEN_ARGS="-Dproject.build.outputTimestamp=2026-11-25T19:22:38Z -Dmaven.buildNumber.revisionOnScmFailure=134a68096eb24391de1d12108606f268c7a95645"
RUN cd /src && COREPACK_ENABLE_NETWORK=0 YARN_ENABLE_OFFLINE_MODE=1 mvn -o -B -am -pl war,bom -Pquick-build -Dmaven.repo.local=/m2 install
RUN mkdir -p /usr/share/jenkins/ref/plugins && cp /src/war/target/jenkins.war /usr/share/jenkins/jenkins.war && cp -a /plugins/. /usr/share/jenkins/ref/plugins/ 2>/dev/null || true
RUN test -s /usr/share/jenkins/jenkins.war && echo "war staged: $(du -h /usr/share/jenkins/jenkins.war | cut -f1)"
# the release's JRE (eclipse-temurin:21-jre-noble: /opt/java/openjdk) with the application tree, the commands that
# need a JRE, and what the two load (this image has ldd, not readelf)
FROM eclipse-temurin:21-jre-noble@sha256:ac595159aa2209f07a2331efa8a8ce4278b77a7b76a9365a0f173786d5067a9e AS japp
ARG SOURCE_DATE_EPOCH=1795634558
COPY --from=jbuild /usr/share/jenkins /usr/share/jenkins
RUN set -eu; find /opt/java/openjdk /usr/share/jenkins -type f | LC_ALL=C sort | while read -r f; do \
      [ "$(od -An -c -N4 "$f" | tr -d ' ')" = 177ELF ] || continue; \
      ldd "$f" 2>/dev/null | sed -n 's/^[[:space:]]*\([^[:space:]]*\) => \/.*/\1/p; s/^[[:space:]]*\(\/[^[:space:]]*\) (0x.*/\1/p; s/^[[:space:]]*\([^[:space:]]*\) => not found.*/absent \1/p'; \
    done | LC_ALL=C sort -u > /tmp/ldd.all; \
    grep '^absent ' /tmp/ldd.all | cut -d' ' -f2 | tr '\n' ' ' | sed 's/^./not in the release image either (not required): &/'; echo; \
    grep -v '^absent ' /tmp/ldd.all | while read -r lib; do case "$lib" in \
      /*) echo "$lib" ;; *) [ -n "$(find /opt/java/openjdk /usr/share/jenkins -name "$lib" -print -quit)" ] || echo "$lib" ;; esac; \
    done > /kitforge.needs && rm -f /tmp/ldd.all && \
    echo "the JRE and the application load: $(tr '\n' ' ' < /kitforge.needs)"
# rs-probe: the HEALTHCHECK helper (standard library only, from the kit's rs-probe.go)
FROM golang:1.27.3-bookworm@sha256:972b4110ba0f47539a975c31e52c64765e1ff19f2d74469ae4a595c6676e80a5 AS build_rs_probe
WORKDIR /probe
COPY rs-probe.go main.go
COPY rs-probe.mod go.mod
ENV CGO_ENABLED=0 GOTOOLCHAIN=local GOFLAGS="-buildvcs=false" GOPROXY=off SOURCE_DATE_EPOCH=1795634558
RUN go build -trimpath -ldflags='-s -w' -o /rs-probe .
# the chiselled rootfs (vendored/chisel, cut by Dockerfile.vendor), the service user, the binaries
FROM ubuntu:24.04@sha256:9c7f200c07e3d4a03e7249d2c16bf66a51120fb876aa2242cf31451412543289 AS rootfs
ARG SOURCE_DATE_EPOCH=1795634558
ADD vendored/chisel/rootfs.tar /rootfs/
RUN printf 'jenkins:x:999:999::/var/jenkins_home:/bin/sh\n' >> /rootfs/etc/passwd && printf 'jenkins:x:999:\n' >> /rootfs/etc/group && \
    mkdir -p /rootfs/var/jenkins_home && chown -R 999:999 /rootfs/var/jenkins_home
COPY --from=build_rs_probe /rs-probe /rootfs/usr/local/bin/rs-probe
COPY security.groovy /rootfs/usr/share/jenkins/ref/init.groovy.d/security.groovy
COPY entrypoint.sh /rootfs/usr/local/bin/entrypoint.sh
COPY --from=japp /opt/java/openjdk /rootfs/opt/java/openjdk
COPY --from=japp /usr/share/jenkins /rootfs/usr/share/jenkins
COPY --from=japp /kitforge.needs /tmp/needs/jenkins
RUN chmod 755 /rootfs/usr/local/bin/rs-probe && \
    chown -R 999:999 /rootfs/var/jenkins_home && \
    chmod 0644 /rootfs/usr/share/jenkins/ref/init.groovy.d/security.groovy && \
    chmod 0755 /rootfs/usr/local/bin/entrypoint.sh
RUN --mount=type=bind,source=vendored/chisel,target=/chisel set -eu; \
    for n in /tmp/needs/*; do while read -r lib; do [ -n "$lib" ] || continue; \
      case "$lib" in /*) [ -e "/rootfs$lib" ] ;; *) [ -n "$(find /rootfs/usr/lib /rootfs/usr/lib64 -name "$lib" 2>/dev/null | head -1)" ] ;; esac || \
      { echo "$(basename "$n") needs $lib, which the chiselled rootfs does not have: add its slice to runtime_base.slices" >&2; exit 1; }; \
    done < "$n"; done; rm -rf /tmp/needs; \
    [ -e /rootfs/etc/os-release ] || { echo "no /etc/os-release: base-files_release-info is missing" >&2; exit 1; }; \
    [ "$(grep -c '^Package: ' /rootfs/var/lib/dpkg/status)" = "$(wc -l < /chisel/packages.tsv)" ] || \
      { echo "/var/lib/dpkg/status does not list every package of vendored/chisel/packages.tsv" >&2; exit 1; }; \
    rm -rf /rootfs/var/log/dpkg.log /rootfs/var/log/alternatives.log /rootfs/var/log/apt /rootfs/var/cache/ldconfig/aux-cache /rootfs/var/cache/fontconfig
FROM scratch
ARG SOURCE_DATE_EPOCH=1795634558
COPY --from=rootfs /rootfs/ /
ENV PATH=/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin JAVA_HOME=/opt/java/openjdk JENKINS_HOME=/var/jenkins_home JAVA_OPTS=-Djava.awt.headless=true JENKINS_OPTS=--httpPort=8080 LANG=C.UTF-8
LABEL org.opencontainers.image.title="Jenkins"
LABEL org.opencontainers.image.version="2.580.3-CE-ubuntu24.04-r1"
LABEL org.opencontainers.image.licenses="MIT AND CDDL-1.0"
LABEL org.opencontainers.image.source="https://github.com/readystack-dev/jenkins"
LABEL org.opencontainers.image.description="Automation server — Jenkins LTS built from source"
LABEL org.opencontainers.image.vendor="ReadyStack.dev"
LABEL readystack.product="jenkins"
LABEL readystack.edition="CE"
LABEL readystack.build_method="source-rebuild-java"
LABEL readystack.license.notice="MIT core; bundled Winstone dual LGPL/CDDL, CDDL elected"
LABEL org.opencontainers.image.revision="134a68096eb24391de1d12108606f268c7a95645"
LABEL readystack.upstream.source="https://github.com/jenkinsci/jenkins"
LABEL org.opencontainers.image.url="https://readystack.dev/products/jenkins"
LABEL org.opencontainers.image.documentation="https://github.com/readystack-dev/jenkins#readme"
LABEL org.opencontainers.image.authors="ReadyStack <contact@readystack.dev>"
HEALTHCHECK --interval=5s --timeout=30s --start-period=120s \
  CMD /usr/local/bin/rs-probe http://127.0.0.1:8080/health/ || exit 1
WORKDIR /var/jenkins_home
USER jenkins
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
