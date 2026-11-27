# Provenance — Jenkins (`2.580.2-CE-ubuntu24.04-r6`)

Every item below is copied from a record in this archive; the record is named in brackets.

## Source

- Upstream repository: https://github.com/jenkinsci/jenkins
- Revision built: `jenkins-2.580.2` (commit `ea3f958268fe87ed86a5d1c2d90c5a99426b97ce`)
- Source tree: `2da58d3f9f824d6abe5561b5d8ffba34ef4f65ba11d9e55e3a5a6c77f8280a37` over 12436 files [`docs/provenance/SOURCE_TREE_HASH.json`]
- Community Edition only: enterprise code is removed or refused before the build (CE audit at acquire).

## Build

- Method: `source-rebuild-java`; base image `scratch + a chiselled Ubuntu 24.04 runtime (vendored/chisel/slices.txt, packages.tsv)`
- Compiled with `--network=none` from vendored source, dependencies and base images; BuildKit pinned to `moby/buildkit:v0.31.2` (shipped in `toolchain/`).
- Not compiled here, shipped as upstream's prebuilt files: the 63 bundled plugins are upstream's prebuilt releases, unmodified
- SOURCE_DATE_EPOCH: `1795533721` [`SOURCE_DATE_EPOCH.txt`]
- Frozen inputs: [`docs/provenance/FREEZE_MANIFEST.json`], build recipe: [`docs/provenance/BUILD_RECIPE.json`].

## Output

- Published image: `readystack/jenkins:2.580.2-CE-ubuntu24.04-r6` — index digest `sha256:9323ebede4eaca95d12cb0892bff2f7bcd45827227b2b59adf2b765c086cf8be` [`docs/provenance/LOCKED_DIGEST.txt`]
- linux/amd64 image digest `sha256:0a47b8492231f46d0faeb661bd81f74924276f20078ed7d292f9c182663c5f64` — reproduced from this archive before publishing [`docs/provenance/REPRO_VERIFICATION.json`].

## Attestations and signature

- SBOM + SLSA provenance attached to the image: attached: an SPDX SBOM and SLSA v1 provenance [`docs/provenance/SCOUT_VERDICT.json`]
- cosign signature by the ReadyStack release key: verified before publishing. Check it: `cosign verify --key https://readystack.dev/keys/cosign.pub readystack/jenkins:2.580.2-CE-ubuntu24.04-r6`

## Pinned inputs, and why

- 98 pinned inputs, each with where it came from, why this one, how it was checked and when it was decided: `docs/PINS.md` [`docs/provenance/PINS.json`] (upstream source 2, base and build images 2, image digests 4, language runtimes and toolchains 2, dependency versions readystack sets 3, files the vendor stage downloads 6, pins in the kit's dockerfiles 71, readystack's build engine 7, dependencies upstream chose 1).

## Build trail

- How this release passed through the ReadyStack harness, record by record (every chain, drive, stage, review round, defect and check, each naming the record it is copied from): `ReadyStack-jenkins-2.580.2-CE-ubuntu24.04-r6.trail.json`, published beside this archive and signed with the release key (`ReadyStack-jenkins-2.580.2-CE-ubuntu24.04-r6.trail.json.sigstore`), and readable at https://readystack.dev/products/jenkins/trail/2.580.2-CE-ubuntu24.04-r6.

