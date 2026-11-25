# Jenkins 2.580.2 — ReadyStack release `2.580.2-CE-ubuntu24.04-r5`

Generated 2026-11-22 from this release's build records and strategy. Statements that come from a single record name it in brackets; the others come from this release's strategy and build log.

## Release

- **Image:** `readystack/jenkins:2.580.2-CE-ubuntu24.04-r5` (linux/amd64). Index digest `sha256:d62f7478e30d4bb20ef51db4fec7e9d5ff8b60eec1cdd9b0e79bfe0f554a4f21` [`docs/provenance/LOCKED_DIGEST.txt`].
- **Image manifest digest:** `sha256:3bf9f435a18b3adf81a8089c291724a5510bcde32ef6060134938787649f75f7` [`TARGET_DIGEST.txt`].
- **Upstream:** Jenkins 2.580.2 built from source at `jenkins-2.580.2` of https://github.com/jenkinsci/jenkins (the 63 bundled plugins are upstream's prebuilt releases, unmodified) — upstream notes: https://github.com/jenkinsci/jenkins/releases/tag/jenkins-2.580.2 [`docs/provenance/BUILD_RECIPE.json`].
- **Base image:** none (`FROM scratch`): a chiselled Ubuntu 24.04 runtime, the files Canonical's chisel cut from Ubuntu's own packages (`vendored/chisel/slices.txt`, `vendored/chisel/packages.tsv`); runtime user `jenkins`.
- **Build:** `source-rebuild-java`, compiled offline with `--network=none`.
- **Supersedes:** ReadyStack release `2.580.2-CE-ubuntu24.04-r4`.

## What changed in this release

- Upstream version unchanged (2.580.2); ReadyStack rebuild.
- Jenkins 2.580.2 is unchanged from the release this supersedes (2.580.2-CE-ubuntu24.04-r4); this release rebuilds it. Changes: the image is rebuilt on the current eclipse-temurin:21-jre-noble image (sha256:ac595159aa22…), which its maintainers updated after 2.580.2-CE-ubuntu24.04-r4 was built on sha256:b4f9d2a0bc27…. Settings, ports and data volumes are those of 2.580.2-CE-ubuntu24.04-r4: replace the container with this image on the same volumes.

## Security status at release (measured 2026-11-22)

- **Docker Scout:** 0 fixable critical/high vulnerabilities; runs as `jenkins` (non-root); SBOM + provenance attestations present (SPDX SBOM + SLSA v1) [`docs/provenance/SCOUT_VERDICT.json`].
- **OSV cross-check:** no fixable critical/high vulnerability beyond Docker Scout's findings.
- **Signature:** cosign signature verified by ReadyStack's release gate before publishing; check it yourself with `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/jenkins:2.580.2-CE-ubuntu24.04-r5` (signatures are recorded in the public Sigstore transparency log).
- **ReadyStack release check at release:** passed (ReadyStack's own test, not a Docker Scout grade). Vulnerabilities are disclosed every day and the image never changes, so it is re-checked daily, beside Docker Scout's own dated grade, at https://readystack.dev/queue.
- **Before exposing this service:** Set JENKINS_ADMIN_PASSWORD for the first start of a new JENKINS_HOME: without it the container refuses to start (exit code 1) rather than run Jenkins without a security realm. If you ran the superseded release 2.580.1-CE-noble-r1 without that variable, its Jenkins had no security realm and anyone who could reach port 8080 had full administrative rights, including the script console, which runs commands in the container as uid 999: start that JENKINS_HOME on this image with JENKINS_ADMIN_PASSWORD set, then review its users, jobs, credentials and plugins and treat its secrets as exposed.

## Reproducibility

Rebuilds offline from this archive to the identical image digest `sha256:3bf9f435a18b3adf81a8089c291724a5510bcde32ef6060134938787649f75f7`: run `./BUILD_OFFLINE.sh`, then `./VERIFY_OFFLINE.sh` (add `--online` to confirm the Docker Hub tag holds the same digest). Before publishing, ReadyStack rebuilt the kit with `./BUILD_OFFLINE.sh` and compared the result with the published digest [`docs/provenance/REPRO_VERIFICATION.json`], then ran `./BUILD_OFFLINE.sh` and `./VERIFY_OFFLINE.sh` from this archive (without `--online`).

## Validation

- 4 of 4 use cases passed (4 authored) against the running image [`docs/validation/test-results.json`].

## Known issues

- None recorded.

## Defects fixed

- 33 problems found before release and fixed before it shipped (33 by review); each is listed in `docs/defects/defects.json`.

## Verify this archive

```
sha256sum -c CHECKSUMS.sha256
./BUILD_OFFLINE.sh && ./VERIFY_OFFLINE.sh --online
cosign verify --key https://readystack.dev/keys/cosign.pub readystack/jenkins:2.580.2-CE-ubuntu24.04-r5
```

ReadyStack records every signature in the public Sigstore transparency log (Rekor), so the command needs no extra flags.

