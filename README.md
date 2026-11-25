# Jenkins: ReadyStack build kit

The offline build kit for the Docker image `readystack/jenkins:2.580.2-CE-ubuntu24.04-r5`. It holds what the image is built from (upstream source, base images, toolchain, pinned dependencies) and the documents, so the image can be rebuilt with no network access (`docker build --network=none`).

- Release: [2.580.2-CE-ubuntu24.04-r5](https://github.com/readystack-dev/jenkins/releases/tag/2.580.2-CE-ubuntu24.04-r5)
- Image: [`docker.io/readystack/jenkins:2.580.2-CE-ubuntu24.04-r5`](https://hub.docker.com/r/readystack/jenkins/tags), manifest digest `sha256:3bf9f435a18b3adf81a8089c291724a5510bcde32ef6060134938787649f75f7`
- Product page: https://readystack.dev/products/jenkins
- Defects: this repository's Issues (defects recorded from 25 November 2026 on) and https://readystack.dev/defects.html?product=jenkins

Jenkins is distributed under its upstream licence (MIT AND CDDL-1.0); the kit contains upstream's source under that licence, and each vendored component under its own.

## Download

From the [2.580.2-CE-ubuntu24.04-r5 release](https://github.com/readystack-dev/jenkins/releases/tag/2.580.2-CE-ubuntu24.04-r5): `ReadyStack-jenkins-2.580.2-CE-ubuntu24.04-r5.tar.gz` (1.4 GB), SHA-256 `a16c06bc66b389b3ee74319b18702d4e7fc5b3868b2bf2ba682cd3ee8c741ea5`.

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

## Verify and rebuild

The rebuild statement is signed with the ReadyStack release key. Check the signature before you rely on it:

```sh
cosign verify-blob --key https://readystack.dev/keys/cosign.pub \
  --bundle ReadyStack-jenkins-2.580.2-CE-ubuntu24.04-r5.rebuild.json.sigstore ReadyStack-jenkins-2.580.2-CE-ubuntu24.04-r5.rebuild.json
```

Unpack with `-p` so file modes are kept, then follow the kit's own README.md and docs/REBUILD.md:

```sh
tar -xpzf ReadyStack-jenkins-2.580.2-CE-ubuntu24.04-r5.tar.gz
cd 2.580.2-CE-ubuntu24.04-r5
less README.md docs/REBUILD.md
```

The build trail (`ReadyStack-jenkins-2.580.2-CE-ubuntu24.04-r5.trail.json`, signed the same way, and its Markdown copy) records how this release was built and checked.

## This repository

`recipe/` holds the kit's recipe files (Dockerfiles, build scripts, pins) as published at https://readystack.dev/products/jenkins/recipe. The complete kit is the release download. Each release is a tag here.
