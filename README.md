[![ReadyStack](https://readystack.dev/logo.svg)](https://readystack.dev)

**Stable, Open-source Releases, Automated** · [readystack.dev](https://readystack.dev)

[![Docker Hub](https://img.shields.io/badge/Docker%20Hub-readystack%2Fjenkins-2496ED?logo=docker&logoColor=white)](https://hub.docker.com/r/readystack/jenkins) [![Docker pulls](https://img.shields.io/docker/pulls/readystack/jenkins)](https://hub.docker.com/r/readystack/jenkins) [![Grade at release](https://img.shields.io/badge/grade%20at%20release-A%20%2894%25%29-2ea44f)](https://readystack.dev/products/jenkins) [![Signed: cosign](https://img.shields.io/badge/signed-cosign-2ea44f)](https://readystack.dev/keys/cosign.pub) ![SBOM: SPDX](https://img.shields.io/badge/SBOM-SPDX-2ea44f) ![Provenance: SLSA v1](https://img.shields.io/badge/provenance-SLSA%20v1-2ea44f) ![Offline rebuild: verified](https://img.shields.io/badge/offline%20rebuild-verified-2ea44f)

# Jenkins: ReadyStack build kit

The offline build kit for the Docker image `readystack/jenkins:2.580.2-CE-ubuntu24.04-r6`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [2.580.2-CE-ubuntu24.04-r6](https://github.com/readystack-dev/jenkins/releases/tag/2.580.2-CE-ubuntu24.04-r6)
- Image: [`docker.io/readystack/jenkins:2.580.2-CE-ubuntu24.04-r6`](https://hub.docker.com/r/readystack/jenkins/tags), manifest digest `sha256:0a47b8492231f46d0faeb661bd81f74924276f20078ed7d292f9c182663c5f64`
- Product page: https://readystack.dev/products/jenkins
- Source and build recipe: https://readystack.dev/products/jenkins/recipe
- Build trail: https://readystack.dev/products/jenkins/trail/2.580.2-CE-ubuntu24.04-r6
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=jenkins

## The image

Single container running jenkins.war on its embedded Winstone/Jetty container, with state under JENKINS_HOME. No external database.

## Who uses Jenkins and why

Development and DevOps teams who automate building, testing and deploying their software.

Jenkins is an open-source automation server. With its plugins it runs the repetitive parts of the development workflow: builds, tests, static code analysis and deployments.

A typical use: Each time a developer pushes code, Jenkins checks it out, builds it and runs the test suite, so a bug is caught as soon as it is introduced. When the tests pass on the main branch, the same pipeline deploys the build to a test environment.

From the upstream project's own description: https://github.com/jenkinsci/jenkins, https://www.jenkins.io/.

## This release

- Docker Scout policy grade at release: **A** (94%), graded 2026-11-25 with `docker scout policy` (CLI 1.26.0, docker-default configuration).
  - Docker Scout counts 49 packages with copyleft licences (CDDL, EPL, GPL, LGPL, MPL), 47 of them operating-system packages (it counts only packages whose licence it can read; the SBOM lists every component).
- Signed with ReadyStack's release key (fingerprint `04daa92344a52dbc`): https://readystack.dev/keys/cosign.pub.
- Runs as a non-root user (`jenkins`).
- Attestations on the image: an SPDX SBOM and SLSA provenance v1.
- Rebuilt from this kit with network egress blocked on 2026-11-25; the rebuilt image digest is the published one.
- Base: Ubuntu 24.04.

The current grade, measured again every day, is on https://readystack.dev/products/jenkins.

Jenkins is distributed under its upstream licence (MIT AND CDDL-1.0); the kit contains upstream's source under that licence, and each vendored component under its own.

## Download

From the [2.580.2-CE-ubuntu24.04-r6 release](https://github.com/readystack-dev/jenkins/releases/tag/2.580.2-CE-ubuntu24.04-r6): `ReadyStack-jenkins-2.580.2-CE-ubuntu24.04-r6.tar.gz` (1.4 GB), SHA-256 `a0f88bc43ba25a30d3625e768fb0670bac94405af26bc30f96e2fd08190c3e1a`.

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

## Verify and rebuild

The rebuild statement is signed with the ReadyStack release key. Check the signature before you rely on it:

```sh
cosign verify-blob --key https://readystack.dev/keys/cosign.pub \
  --bundle ReadyStack-jenkins-2.580.2-CE-ubuntu24.04-r6.rebuild.json.sigstore ReadyStack-jenkins-2.580.2-CE-ubuntu24.04-r6.rebuild.json
```

Unpack with `-p` so file modes are kept, then follow the kit's own README.md and docs/REBUILD.md:

```sh
tar -xpzf ReadyStack-jenkins-2.580.2-CE-ubuntu24.04-r6.tar.gz
cd 2.580.2-CE-ubuntu24.04-r6
less README.md docs/REBUILD.md
```

The build trail (`ReadyStack-jenkins-2.580.2-CE-ubuntu24.04-r6.trail.json`, signed the same way, and its Markdown copy) records how this release was built and checked.

## This repository

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/jenkins/recipe. The complete kit is the release download. Each release is a tag here. How to report a vulnerability: [SECURITY.md](SECURITY.md).

## About ReadyStack

**Stable, Open-source Releases, Automated.** ReadyStack releases popular open-source apps every week with every available critical and high security fix applied, plus full documentation, reference data, tests and a build recipe that recreates each release bit-for-bit. Each release is rebuilt from its pinned inputs with the network off, checked against its published digest, signed, and scanned and graded again every day. The images and build kits are free, and ReadyStack is soon to be a nonprofit.

[readystack.dev](https://readystack.dev) · [All products](https://readystack.dev/products.html) · [Build kits on GitHub](https://github.com/readystack-dev) · [Defect log](https://readystack.dev/defects.html) · contact@readystack.dev

— ReadyStack · https://readystack.dev
