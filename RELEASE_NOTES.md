# Jenkins 2.580.3 — ReadyStack release `2.580.3-CE-ubuntu24.04-r1`

Generated 2026-11-28 from this release's build records and strategy. Statements that come from a single record name it in brackets; the others come from this release's strategy and build log.

## Release

- **Image:** `readystack/jenkins:2.580.3-CE-ubuntu24.04-r1` (linux/amd64). Index digest `sha256:05125966cf5c2c660694398af3d7641964aebdac641adc9ba2e09e342d172d31` [`docs/provenance/LOCKED_DIGEST.txt`].
- **Image manifest digest:** `sha256:a2a9014c201e36fe45ada15f148244b4045d29be50c119b3be5acba49d089c1a` [`TARGET_DIGEST.txt`].
- **Upstream:** Jenkins 2.580.3 built from source at `jenkins-2.580.3` of https://github.com/jenkinsci/jenkins (the 63 bundled plugins are upstream's prebuilt releases, unmodified) — upstream notes: https://github.com/jenkinsci/jenkins/releases/tag/jenkins-2.580.3 [`docs/provenance/BUILD_RECIPE.json`].
- **Base image:** none (`FROM scratch`): a chiselled Ubuntu 24.04 runtime, the files Canonical's chisel cut from Ubuntu's own packages (`vendored/chisel/slices.txt`, `vendored/chisel/packages.tsv`); runtime user `jenkins`.
- **Build:** `source-rebuild-java`, compiled offline with `--network=none`.
- **Supersedes:** ReadyStack release `2.580.2-CE-ubuntu24.04-r6`.

## What changed in this release

- Upstream version 2.580.2 → 2.580.3.
- This release moves Jenkins from 2.580.2 to 2.580.3, a newer release of upstream's 2.580.x line. Upstream's release notes list what changed: https://github.com/jenkinsci/jenkins/releases/tag/jenkins-2.580.3

## Security status at release (measured 2026-11-28)

- **Docker Scout:** 0 fixable critical/high vulnerabilities; runs as `jenkins` (non-root); SBOM + provenance attestations present (SPDX SBOM + SLSA v1) [`docs/provenance/SCOUT_VERDICT.json`].
- **OSV cross-check:** no fixable critical/high vulnerability beyond Docker Scout's findings.
- **Signature:** cosign signature verified by ReadyStack's release gate before publishing; check it yourself with `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/jenkins:2.580.3-CE-ubuntu24.04-r1` (signatures are recorded in the public Sigstore transparency log).
- **ReadyStack release check at release:** passed (ReadyStack's own test, not a Docker Scout grade). Vulnerabilities are disclosed every day and the image never changes, so it is re-checked daily, beside Docker Scout's own dated grade, at https://readystack.dev/queue.
- **Before exposing this service:** Set JENKINS_ADMIN_PASSWORD for the first start of a new JENKINS_HOME: without it the container refuses to start (exit code 1) rather than run Jenkins without a security realm. If you ran the superseded release 2.580.1-CE-noble-r1 without that variable, its Jenkins had no security realm and anyone who could reach port 8080 had full administrative rights, including the script console, which runs commands in the container as uid 999: start that JENKINS_HOME on this image with JENKINS_ADMIN_PASSWORD set, then review its users, jobs, credentials and plugins and treat its secrets as exposed.

## Reproducibility

Rebuilds offline from this archive to the identical image digest `sha256:a2a9014c201e36fe45ada15f148244b4045d29be50c119b3be5acba49d089c1a`: run `./BUILD_OFFLINE.sh`, then `./VERIFY_OFFLINE.sh` (add `--online` to confirm the Docker Hub tag holds the same digest). Before publishing, ReadyStack rebuilt the kit with `./BUILD_OFFLINE.sh` and compared the result with the published digest [`docs/provenance/REPRO_VERIFICATION.json`], then ran `./BUILD_OFFLINE.sh` and `./VERIFY_OFFLINE.sh` from this archive (without `--online`).

## Validation

- 4 of 4 use cases passed (4 authored) against the running image [`docs/validation/test-results.json`].

## Known issues

- None recorded.

## Defects fixed

- 18 problems found before release and fixed before it shipped (18 by review); each is listed in `docs/defects/defects.json`.

## Verify this archive

```
sha256sum -c CHECKSUMS.sha256
./BUILD_OFFLINE.sh && ./VERIFY_OFFLINE.sh --online
cosign verify --key https://readystack.dev/keys/cosign.pub readystack/jenkins:2.580.3-CE-ubuntu24.04-r1
```

ReadyStack records every signature in the public Sigstore transparency log (Rekor), so the command needs no extra flags.

