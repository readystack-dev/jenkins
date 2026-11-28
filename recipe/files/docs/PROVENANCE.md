# Provenance — Jenkins (`2.580.3-CE-ubuntu24.04-r1`)

Every item below is copied from a record in this archive; the record is named in brackets.

## Source

- Upstream repository: https://github.com/jenkinsci/jenkins
- Revision built: `jenkins-2.580.3` (commit `134a68096eb24391de1d12108606f268c7a95645`)
- Source tree: `2da58d3f9f824d6abe5561b5d8ffba34ef4f65ba11d9e55e3a5a6c77f8280a37` over 12436 files [`docs/provenance/SOURCE_TREE_HASH.json`]
- Community Edition only: enterprise code is removed or refused before the build (CE audit at acquire).

## Build

- Method: `source-rebuild-java`; base image `scratch + a chiselled Ubuntu 24.04 runtime (vendored/chisel/slices.txt, packages.tsv)`
- Compiled with `--network=none` from vendored source, dependencies and base images; BuildKit pinned to `moby/buildkit:v0.31.2` (shipped in `toolchain/`).
- Not compiled here, shipped as upstream's prebuilt files: the 63 bundled plugins are upstream's prebuilt releases, unmodified
- SOURCE_DATE_EPOCH: `1795634558` [`SOURCE_DATE_EPOCH.txt`]
- Frozen inputs: [`docs/provenance/FREEZE_MANIFEST.json`], build recipe: [`docs/provenance/BUILD_RECIPE.json`].

## Output

- Published image: `readystack/jenkins:2.580.3-CE-ubuntu24.04-r1` — index digest `sha256:05125966cf5c2c660694398af3d7641964aebdac641adc9ba2e09e342d172d31` [`docs/provenance/LOCKED_DIGEST.txt`]
- linux/amd64 image digest `sha256:a2a9014c201e36fe45ada15f148244b4045d29be50c119b3be5acba49d089c1a` — reproduced from this archive before publishing [`docs/provenance/REPRO_VERIFICATION.json`].

## Attestations and signature

- SBOM + SLSA provenance attached to the image: attached: an SPDX SBOM and SLSA v1 provenance [`docs/provenance/SCOUT_VERDICT.json`]
- cosign signature by the ReadyStack release key: verified before publishing. Check it: `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/jenkins:2.580.3-CE-ubuntu24.04-r1`

## Pinned inputs, and why

- 99 pinned inputs, each with where it came from, why this one, how it was checked and when it was decided: `docs/PINS.md` [`docs/provenance/PINS.json`] (upstream source 2, base and build images 2, image digests 4, language runtimes and toolchains 2, dependency versions readystack sets 4, files the vendor stage downloads 6, pins in the kit's dockerfiles 71, readystack's build engine 7, dependencies upstream chose 1).

## Build trail

- How this release passed through the ReadyStack harness, record by record (every chain, drive, stage, review round, defect and check, each naming the record it is copied from): `ReadyStack-jenkins-2.580.3-CE-ubuntu24.04-r1.trail.json`, published beside this archive and signed with the release key (`ReadyStack-jenkins-2.580.3-CE-ubuntu24.04-r1.trail.json.sigstore`), and readable at https://readystack.dev/products/jenkins/trail/2.580.3-CE-ubuntu24.04-r1.

