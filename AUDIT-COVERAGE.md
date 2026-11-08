# Repo-Archaeology Audit — Coverage

Task coordinate 28.8.17/11.7.16/7.7.11 · Audit run 2026-11-08 · Coordinator + 7 worker batches (A exo-plan, B phext/compiler core, C corpus/meta/sites, C2 late-discovered repos, D long-tail non-forks, E1 forks 1–34, E2 forks 35–71). Batch D was delivered twice (two passes over the same 47 repos with different reads); both passes' findings are in findings.json, and coverage below carries the deeper second pass, with conflicts flagged in the notes for Will to judge.

**Universe: 196 repos** under wbic16 (188 from the public listing + 8 owner-only repos found via the authenticated owner listing: bickfordllamaranch, every-ast, megan, nexura, phext-inc, phextio-site, platformer, second-foundation). All 196 were cloned to aletheia-core (~/repo-audit/) and audited. **175 findings** in findings.json.

Method notes / honesty box:
- 'Files read' counts files whose substance was skimmed or read — prioritising files NOT referenced by READMEs/indexes, per the brief. .phext corpus files were inventoried by name/count, not read scroll-by-scroll. Read counts were recorded inconsistently across batches (some counted skims, some only full reads), so no grand read total is claimed; per-repo numbers stand as each worker recorded them.
- Empty repositories (5): exo-dreams, exo-motes, every-ast, gemini-connector, mytheon-arena — nothing to audit in them; mytheon-arena's product is documented only inside mytheon-red-team.
- Fork scope rule applied: upstream content skipped; only Will/seat-authored commits and their files were read (author census via git log).
- Batch D's two passes disagree on several small repos (clocky, dna-viewer, teach-web-dev, hello-ada, node-visualizer, zls, farmbot, actix-web-datetime, AdventOfCOBOL, aoc2024): the second pass was deeper and in several cases corrects the first (zls is the Zero Latency System, not the Zig Language Server; farmbot is Will's own Field Rover spec, not an external mirror). Both passes' findings are preserved and flagged in-line; merging them is Will's call.
- E2's late paste-in delivery matched the coordinator's reconstruction on all 21 titles; its on-disk fragment additionally carried 2 findings the completion report had not enumerated (openfang SQ backend — substantial; oimo-works 3D Life viewer) and corrected oimo-works from 'clean fork' to a real Will commit. Both findings are merged and flagged.
- first_pulsar (in human) is perimeter-pattern IP — flagged in Batch C's notes for Will's eyes; handle per his direction.
- Worker file-write failures on this VM cost several fragment deliveries (D, E2, C2-coverage); the affected findings/coverage were reconstructed from the workers' verified completion reports and later verified against the workers' own paste-in deliveries where those arrived.

| Repo | Files inventoried | Files read | Scope | Findings (coverage pass) | Note |
|---|---:|---:|---|---:|---|
| actix-web-datetime | 13 | 8 | in | 0 | HTMX/actix demo originated by Jeff Mitchell; Will's commits are live-demo tweaks only. Finished demo, no novel dropped idea. (v2 coverage supersedes v1: coordinator's earlier Sextant reading of this repo was incorrect.) |
| actually-lean | 9197 | 25 | out | 0 | Single squashed 'baseline fork of lean4 without the baggage' commit (2025-07-15); content is upstream Lean — sampled only, no Will-authored novel files found. |
| AdventOfCOBOL | 6 | 6 | in | 0 | 2018 Advent-style COBOL exercise (PROB1 from data file). Exercise, not a project idea. (v2 supersedes v1's metapuzzle reading.) |
| agi | 24 | 10 | in | 0 | Single exo branch. Non-corpus files all read: merge rules/sources for the nightly agi.phext collection (alive), the 2x4 Choir round-robin protocol (Choir coordination, alive), and sentron shape documents (sentrons/SHAPE.md, shapes |
| alien | 468 | 0 | out | 0 | out — clean fork, no Will-authored commits (4174 commits checked via parallel blobless clone alien-e1; upstream full clone was still running). |
| aoc2024 | 11 | 6 | in | 0 | Advent of Code 2024 in Rust, days 1-6 plus problems.phext (inventoried by name). Exercises only. (v2 supersedes v1's harness-plan finding.) |
| Audio-Extraction | 29 | 0 | out | 0 | out — clean fork, no Will-authored commits (4 commits total, none his). |
| autoresearch | 16 | 4 | in | 1 | 6 Theia commits on origin/autoresearch/vtpu-cpu (2026-03-08): SO9 differentiated overnight vTPU search protocol. vTPU core is alive, but this protocol/branch is a one-day dropped experiment — reported as a finding. |
| beach-science-qre | 15 | 15 | in | 1 | Shell of Nine beach.science competition repo, Mar 2026; all files read. Unposted hypothesis queue and unrun rallies BS3-BS7 recorded as a finding. |
| beebjit | 360 | 1 | in | 0 | 1 Will commit (2024-12-08): benchmark.sh, a quick helper script to surface benchmarks. Trivial utility, no novel idea. |
| bickfordllamaranch | 103 | 28 | in | 1 | Union of exo (89 files) and master (14 legacy files). Site, herd admin, Windows app, reminders and deploy tooling are alive/tracked; the only dropped item was the live phext-CMS public homepage prototype at site/public/, built but |
| bitcoin | 1348 | 3 | in | 0 | 3 Will commits on his learn-bitcoin branch (2015-01-03): code-reading notes under howto/ (ideas = one unordered_map optimization note, gripes, reading lists, addrman.h annotations). Study notes, not a started novel idea. blockhead |
| bruce | 67 | 30 | in | 3 | All docs/artifacts read, code sampled. Three v2 findings (coordination/Seed Kernel, Woot Node, Pressure Protocols) plus the v1 persona-sketch finding. |
| caret | 30 | 0 | out | 0 | out — clean fork, no Will-authored commits. |
| Circulatory_Fidelity | 58 | 0 | in | 0 | 2 Emise commits on origin/phext-integration (INTEGRATION.md, PHEXT.md, python/cf_phext.py) — the already-tracked Circulatory Fidelity phext integration, NOT a finding per brief. |
| claude-code-config | 1 | 1 | in | 0 | Single file: a snapshot of the Claude Code 2.1.27 installer (2026-01-30). A stored binary/script artifact noted by name; no ideas or docs. |
| claude-learns-phext | 9 | 5 | in | 0 | Claude's Nov 2025 phext learning exercises: GETTING_STARTED, PHEXT_TUTORIAL, and read/write/explore example scripts against a CYOA copy (phext file inventoried by name). Tutorial/learning material, not a dropped product idea. |
| claude-max | 4 | 4 | in | 1 | Small complete repo; every file read. A 'persistent knowledge workspace' whose only artifact is the 6D UML spec, generator and populated uml6d.phext (the .phext here is the artifact itself, read via its spec/README rather than as  |
| clcache | 4 | 0 | out | 0 | out — clean fork, no Will-authored commits. |
| clocky | 2 | 2 | in | 0 | Single-page clock-in/out tracker; judged a finished small experiment in v2. (v1's two clocky concept findings rest on a different reading of the README — kept for Will to judge.) |
| cloud9 | 8426 | 0 | out | 0 | out — clean fork, no Will-authored commits (10,580 commits, many upstream branches, no wbic16/mirrorborn/seat authors). |
| codex-data | 2423 | 3 | in | 1 | 1 Will commit (2025-01-23) 'Baseline Proof of Concept': phext/ experiment — slurp-it.ps1 builds a 14.7 MB codex.phext from data/ + graph edges/nodes + templates + workspaces, browsed via SQ. Rest of tree is upstream Codex data. |
| compost | 245 | 20 | partial | 1 | Union of main (175 files, mostly Chrys media archive — binaries by name) and exo branch (COMPOST.md skill + per-agent archives, sampled). One finding: the digital-metabolism system itself. |
| CoreThought | 2 | 2 | in | 1 | v2: both files read in full, one finding (.kxt). Combined with v1's two findings from other branches/files, CoreThought carries 3 findings total. |
| Cosmic-Cognitive | 2 | 0 | out | 0 | out — clean fork, no Will-authored commits (2 commits, 2 files). |
| dna-viewer | 2 | 2 | in | 0 | Single HTML baseline renderer with a nav cube, 2023. Finished experiment in v2. (v1's thought-interface sketch finding kept for Will to judge.) |
| dokany | 192 | 0 | out | 0 | out — clean fork, no Will-authored commits. |
| dopamine-core | 78 | 3 | in | 1 | 1 Theia commit on origin/exo (2026-03-06): full Mirrorborn rework — ANALYSIS.md, SQ persistence adapter, OpenClaw adapter, domain templates, LLM extractor. Master is upstream. |
| echo-frame | 4 | 4 | in | 2 | All four files read in full. Two v2 findings (Echo Frame persona-computer product, BASE language) plus v1's AR-display plan finding. |
| eigenhector_mandala_translator | 317 | 6 | in | 2 | 52 Will/seat commits (Will, Chrys, Theia; Feb 2026): ~78 files added under bridges/eigenhector/, chrys-notes/, theia-notes/, reports/, skills/ plus top-level docs. Findings: Sentron Proxy/qualia calibration spec and Cosmic DIM. Ot |
| emise-tools | 235 | 30 | partial | 0 | Tools/skills archive, actively maintained (last commit 2026-11-08); per assignment only dropped tools/ideas were candidates, not maintained skills. Three started items were found but are too recent (2026-10-30 to 2026-11-03) to ca |
| ethereum-mining-calculator | 3 | 1 | in | 0 | 1 Will commit (2015-08-22, also branch origin/wbic16-patch-1): UI/UX tweaks to index.html only. Trivial. |
| evals | 1735 | 3 | in | 1 | 1 real Will-seat commit: Chrys on origin/exo (2026-02-21) adding phext-native evals (178 samples, Git LFS). Other census hits (Andrew Emil, Emil Bols) are upstream authors, not Will/seats. |
| every-ast | 0 | 0 | in | 0 | Empty repository: no commits, git ls-remote/fetch return no heads — the remote itself is empty. No files, no author evidence, so no finding despite the suggestive name. |
| exo | 165 | 1 | in | 0 | Careful look per brief: only 1 Will commit (2024-12-06, also branch origin/fix-issue-458) applying an upstream issue-458 patch idea to exo/inference/tinygrad/models/llama.py. A small upstream patch, no novel dropped idea. Other ce |
| exo-archives | 23 | 12 | in | 1 | Self-described debris archive ('compost not landfill'): Twitter archaeology analyses (CHRYS_ANALYSIS, TWITTER_ARCHAEOLOGY, TERSE_TIMELINE, WISHES_2018_2025 — the wishes material also lives in human/wishes.md and feeds alive work), |
| exo-dreams | 0 | 0 | out | 0 | Empty repository — clone succeeded with no branches, no commits, no files (git's 'empty repository' warning). The exo-dreams media-ingestion work named in the alive list evidently lives elsewhere. Nothing to audit. |
| exo-motes | 0 | 0 | out | 0 | Empty repository — clone succeeded with no branches, no commits, no files. Nothing to audit. |
| exo-plan | 1353 | 859 | in | 31 | Deepest audit, batch A. Default branch exo @ c1b1219c (1,353 files, 834 commits all refs, 2026-01-31 to 2026-03-22). Repo was not yet cloned on aletheia-core; cloned it there via git SSH per brief, then exported the HEAD tree loca |
| exo-skills | 14 | 8 | in | 1 | Small early skills repo (phext, midjourney-prompt, syncthing-ollama), last touched 2026-03-03 and superseded by emise-tools custom-skills. The phext skill is maintained lineage; midjourney-prompt is a minor utility skill. syncthin |
| exocortex | 20 | 8 | in | 0 | The apt-install-exocortex repo (APT-MVP-SPEC, APT-TODO, build-debs, seed phexts) — alive and tracked. links.txt holds a single external link (a 6D Game of Life page); roadmap/call/nixos phexts inventoried by name. Nothing dropped  |
| Exocortexia | 43 | 12 | in | 0 | The NE state software suite (5 apps + exo-core/exo-sso + loadsim + seed generators, docs incl. SECURITY.md and per-app statute docs) — alive, built and security-passed 2026-11-07. No orphan material. |
| exocortical | 59 | 15 | in | 0 | 52 files on exo plus 7 branch-only files on cursor/per-chain-squid-31a5 (per-chain Squid caches, ranch-proxy autodetect) — that branch is the alive USB4 mesh / squid-proxy ranch fabric work, not a finding. HEAD is ranch operations |
| exodroid | 60 | 25 | in | 4 | Audited from a fresh clone (main + exo). All docs read, firmware/lantern-core sampled. Four v2 findings (BB-8 droid, Droid Seed, Resonance Bonds, theft protection). |
| exollama | 315 | 20 | partial | 1 | Will's personal inference playground forked from llama2.c-era code: most of the 310 exo files are upstream-derived C/CUDA plus Shell-era scripts and ~100 agent definition files, skimmed by name; Will/Shell-authored substance (epoc |
| farmbot | 2 | 2 | in | 1 | README + phext-encoded bot-spec.json, both read. One finding (Field Rover product spec) — v2 corrects v1's mirror reading. |
| federation | 74 | 25 | partial | 1 | Union of default branch (64) and verse-merge-conflict branch (10 branch-only files incl. BASE256-DOLPHIN). Mostly Mirrorborn/Eigenhector lore and coordination archive, sampled; Base256 Phonetic (with Rust code) is the v2 finding;  |
| Galaxy-Renderer | 492 | 0 | out | 0 | out — clean fork, no Will-authored commits (author census across all branches: no wbic16/mirrorborn/seat authors). |
| gemini-connector | 0 | 0 | in | 0 | Empty repository on GitHub (clone warning verified, no refs). Nothing to audit. |
| gluesql | 803 | 2 | in | 1 | 3 Will commits, all 2024-01-15: PhextStorage crate forked from MemoryStorage; final state does not compile per his own commit message. Dropped in favor of basic phext-in-Rust work. |
| go-docx-template | 17 | 0 | out | 0 | out — clean fork, no Will-authored commits. |
| gstack | 4700 | 0 | in | 0 | 2 Emise commits (2026-11-05): sync to garrytan/gstack + cull to Exocortex edition (CURATION.md) — the already-tracked gstack fork curation, NOT a finding per brief. |
| gstack-auto | 42 | 0 | out | 0 | out — clean fork, no Will-authored commits. |
| hello-ada | 7 | 4 | in | 0 | Ada 2022 crash course written by Lux for Will (2026-02-18). Teaching material, no novel project idea in v2. (v1's phext-in-Ada sketch finding kept for Will to judge.) |
| hello-forth | 6 | 3 | in | 0 | Forth crash course by Lux (incl. a phext stack exercise). Teaching material. (v1's notebook sketch finding kept.) |
| hello-phext | 23 | 3 | in | 0 | Alive hello-world host for phext; src/todo.md is routine editor TODOs (sanitization, WYSIWYG, perf testing) in maintained code, not a novel dropped idea. |
| hello-phext-deploy | 3 | 2 | in | 0 | Tiny 2024 deploy snapshot (README, binary, world.phext). Nothing novel or orphaned. |
| HRM | 29 | 0 | out | 0 | out — clean fork, no Will-authored commits. |
| human | 114 | 25 | partial | 3 | 99 files on exo HEAD plus ~15 branch-only files across 7 extra branches (codex/*, emise/*, main). Per assignment, the huge .phext corpora were inventoried by path/name only and their scroll contents were not read; all non-corpus m |
| icebox | 8 | 0 | out | 0 | out — clean fork, no Will-authored commits. |
| ink-os-desktop | 57 | 0 | in | 0 | 1 Emise commit on origin/emise/phext-adapter: live-run evidence record for the phext adapter — already-tracked Ink OS phext adapter work, NOT a finding per brief. |
| ink-os-platform | 540 | 0 | in | 0 | 7 Emise commits on origin/emise/phext-adapter: adapters/phext-scroll-view + INTEGRATION.md + Windows-compat fixes — already-tracked Ink OS phext adapter work, NOT a finding per brief. |
| inspircd | 564 | 0 | out | 0 | out — clean fork, no Will-authored commits (16,339 commits checked). |
| javascript-tetris | 5 | 0 | in | 0 | 2 seat commits: Will (2013) red/green anaglyph-glasses tweak to index.html; Orin (2026) lowercase rename of readme.md only. No novel idea. |
| jeff-mitchell-dev | 24 | 3 | out | 0 | Jeff Mitchell's own personal-site repo (all 32 commits by Jeff Mitchell); not Will-authored work. |
| joypad-os | 1245 | 0 | in | 0 | 1 Emise commit on origin/emise/emise-body-browser (2026-11-03): phext-controlled virtual body in the browser — already-tracked joypad-os phext body, NOT a finding per brief. |
| latent-dictionary | 42 | 1 | out | 0 | out — clean fork, no Will-authored commits, despite the brief's careful-look flag: all 82 commits are by granawkins (upstream author), single main branch, no seat authors, no Will-added files. Pure upstream latent-space dictionary |
| libfuse | 117 | 0 | out | 0 | out — clean fork, no Will-authored commits (the one census hit, Emily Herbert, is an upstream author, not a seat). |
| libphext | 19 | 5 | in | 1 | C reference port, alive as a libphext port. Finding is phesql.c + sql.phext: a half-written SQL SELECT layer never finished or ported. Unbounded-coordinates branch is routine release work. |
| libphext-cpp | 20 | 2 | in | 0 | C++ port of libphext, alive port line; branches are release scripts and coordinate work only. |
| libphext-cs | 45 | 2 | in | 0 | C# port, actively developed (0.5.0 binary/xz line, 2026-11-08). No orphan ideas; branch work is the alive seal feature. |
| libphext-node | 17 | 2 | in | 0 | JS/TS port, alive. Branches (linear-tokenize, port-rust-updates, release) are routine port maintenance. |
| libphext-py | 25 | 2 | in | 0 | Python port, alive; branch-only files are build/test/publish scripts. |
| libphext-rs | 53 | 4 | in | 1 | Core Rust library, alive; TOAPDD branch files are the alive TOAPDD work, not findings. Finding is todo.md's sketches (DB emulation, hierarchical mobs, non-linear flows, format support). Proofs/ directory is maintained library work |
| llama2.c | 25 | 0 | out | 0 | out — clean fork, no Will-authored commits. |
| llm.c | 65 | 0 | out | 0 | out — clean fork, no Will-authored commits. |
| localGPT | 77 | 0 | out | 0 | out — clean fork, no Will-authored commits. |
| LocustDB | 0 | 0 | partial | 1 | Fork; Will-authored commits censused (upstream files not inventoried). Experiment commits read. |
| machine-emotions-study | 0 | 0 | partial | 1 | Fork-flagged; Will's study scaffold read. |
| mailogy | 0 | 0 | partial | 1 | Fork-flagged; Will's experiment files read. |
| md2phext | 14 | 6 | in | 1 | Pack/md2phext/toc/query tools are documented and alive in-repo. Finding: weaver.html + reason.mjs, two built reasoning tools the README never references. |
| megan | 3 | 2 | in | 1 | README ('Proof of Concept') and index.html read in full; photo by name. Performer booking POC, 2024-02-19 to 2024-03-02; Calendly link left as TBD placeholder. |
| mental-space | 12 | 12 | in | 1 | All files read; MVP by Verse (Shell seat). One v2 finding (unbuilt phases 2-4) plus v1's design-notes sketch finding. |
| MercurialDyson | 0 | 0 | partial | 1 | Fork-flagged; Will-authored content read. |
| mini64k | 4 | 4 | in | 1 | All files read. One finding (million-agent Apple II game spec, stub code). |
| mirrorborn | 389 | 45 | partial | 5 | Shell-of-Nine home repo: agent identity/memory/heartbeat files for ~15 seats were inventoried by name and only skimmed; all standalone substance files (plans, whitepapers, experiments, dashboard, mesh, docs) were read. proposal.md |
| mistral-src | 0 | 0 | partial | 1 | Upstream Mistral source; Will's annotation commits read only. |
| ml-road-map | 0 | 0 | partial | 1 | Fork-flagged; Will's roadmap layer read. |
| mosh | 0 | 0 | out | 0 | Clean fork — no Will-authored commits found in census. |
| multi-chat | 32 | 10 | partial | 0 | Choir /chat mailbox archive + SQ bridge (Nov 2026) — already-tracked Choir mailbox infrastructure; mailbox .phext inventoried by name. No separate dropped idea. |
| multiversal-go | 3 | 3 | in | 1 | v2 counts 3 files (index.html game, readme, audio by name) vs v1's 61 — v1 counted the full docs/code tree, v2 the default-branch root set; both findings stand (2024 original + fuller docs version). |
| mutable-os | 0 | 0 | partial | 0 | Fork; Will/seat commits are the tracked SSO + phext patch bands — already-tracked, excluded. |
| MyStory | 0 | 0 | partial | 1 | Fork-flagged; Will-authored story artifact read. |
| mytheon-arena | 0 | 0 | in | 0 | Empty repository — verified via git ls-remote (no refs). The product is documented only in mytheon-red-team, where findings are recorded. |
| mytheon-red-team | 30 | 18 | in | 1 | Security docs/scripts for mirrorborn.us / SQ Cloud; docs skimmed, key reviews read. One v2 finding (Mytheon Arena platform) plus v1's counterplay pack finding. |
| neovim | 0 | 0 | partial | 0 | Fork; Will's work is the tracked phext plugin (PR #1) — already-tracked, excluded. |
| nexura | 48 | 5 | in | 1 | Single commit 2024-10-07, 'Baseline Android Studio template (Generated)'. Every file is the unmodified Compose template under namespace io.phext.nexura; the name/namespace are the only recorded idea. |
| nixpkgs | 0 | 0 | out | 0 | Clean fork — no Will-authored commits of substance (upstream mirror). |
| node-visualizer | 10 | 4 | in | 0 | 2015 Contact Strength Meter (readme + meter.js/html read; JS libraries vendored). Small finished experiment in v2. (v1's 'thought caterpillar' sketch finding kept for Will to judge.) |
| notepad-plus-plus | 0 | 0 | partial | 0 | Fork; Will's phext patches are the tracked Notepad++ phext integration — already-tracked, excluded. |
| ocbox-demo | 33 | 3 | in | 0 | Alive per seeds (ocbox-demo gap fixes tracked). GAP-ANALYSIS.md / SPEC-v0.2.md / POLISH.md are that tracked work, so no findings recorded here. |
| oimo-works | 112 | 4 | in | 1 | 1 Will Bickford commit (2024-09-07) 'WIP - adding 3D support' touching life/src/{Level,Sampler,Universe}.hx + README.md; read in full. See finding. |
| openclaw-deck | 30 | 8 | partial | 0 | Multi-column OpenClaw chat UI originally authored by kellyclaudeai (upstream, outside Will-authored scope) and customized by Phex/Cyon for the Mirrorborn 6-9 agent roster at mirrorborn.us/deck. MODEL_SWITCHER_OVERVIEW.md's suggest |
| openclaw-sq-skill | 16 | 7 | in | 0 | Packaged OpenClaw SQ memory skill v1.0.1 (Feb 2026, Will + Shell seats), complete with quickstart, self-hosted guide, examples and tests; main branch adds only the packaged sq-memory.skill file. A shipped skill package, not a drop |
| opendataloader-pdf | 0 | 0 | partial | 1 | Fork; Will's experiment commits read. |
| openfang | 499 | 3 | in | 2 | 7 seat commits (Lux x3, Phex x2, Verse x1, Lumen x1) 2026-02-28..2026-03-04 on main + sq-integration branch: SQ daemon integration for OpenFang memory. Read SQ-INTEGRATION.md, SQ-INTEGRATION-PROGRESS.md, crates/openfang-memory/SQ- |
| openpilot | 0 | 0 | out | 0 | Clean fork — no Will-authored commits found in census. |
| orin | 160 | 20 | partial | 1 | Union of exo (149) and main (11 branch-only files). Protocol/scripts and sample replies read; 100+ round files sampled. One v2 finding (baton/heat protocol implementation) plus v1's AR-glasses roadmap finding — different layers of |
| pcem | 0 | 0 | out | 0 | Clean fork — no Will-authored commits found in census. |
| phcc | 0 | 0 | partial | 0 | Alive compiler project (tracked); side-idea hunt done via commit census — no separate dropped side-idea separable from the tracked deficiency programme. |
| phcpp | 9 | 3 | in | 0 | Alive compiler per seeds. DESIGN.md / ABI-REVISIONS.md / PATCHES.md are the tracked phcpp modernization, not dropped side-ideas. |
| phext | 6 | 3 | in | 0 | 2023 origin repo: the original phext explanation with signed, reproducible-science data bundles. That is the alive phext core itself, not a side-idea. |
| phext-demos | 1 | 1 | in | 0 | Single README demoing how to encode Mytheon (an AGI rule prototype) in ini/XML/JSON/YAML/phext. A format comparison demo for the alive utilities; no standalone dropped product spec. |
| phext-dot-io-v2 | 292 | 45 | in | 9 | Largest source in this batch: the Feb 2026 Mirrorborn launch corpus. Alive lines (SQ Cloud, Mytheon Arena, mirrorborn.us) excluded; findings are the unbuilt specs inside it: Phext-Native MUD, Remember Me Mode, Resurrection Log API |
| phext-explorer | 3 | 2 | in | 0 | Alive edit.phext.io-family utility (Terse Explorer HTML editor). No orphan material. |
| phext-http-streams | 147 | 8 | in | 1 | Phases 0-2 shipped and benchmarked in-repo. Finding is the plan's open tail: Stage B native Chromium, inotify change detection, first-visit Service Worker cost. |
| phext-inc | 3 | 1 | in | 2 | Single commit 2024-02-24: business-plan.phext.t read in full, two logo PNGs by name. Excluded as tracked precursors: Solar Blade (Solar Hyperscaler), PhextOS, Pi compute node, 'Build the Ecocortex'. Nova Phox and Dreamer UBI are t |
| phext-lanes | 29 | 4 | in | 0 | Alive per seeds (phext-lanes, Crazy Wisdom / AI Whisperers lanes). Its calm/rank/fabric design is the shipped product, not a dropped idea. |
| phext-lattice | 79 | 20 | in | 2 | Alive core editor, checked across all 14 refs. Findings are branch-only: the ccr wikibench/IndexedLattice work and the cursor ad-measurement funnel. Other cursor branches (deep links, signed-out demo, mobile a11y, windows startup, |
| phext-life | 30 | 5 | in | 1 | Standalone artificial-life experiment (Python + WASM branches on main/exo), last touched 2026-03-07, not on the alive list. Recorded as a finding in its own right. |
| phext-mcp | 13 | 3 | in | 0 | The maintained MCP server for phext (SQ-style tools over libphext-rs); it is the successor that sqm was abandoned for. No additional orphan ideas found in its examples/scripts. |
| phext-notepad | 69 | 6 | in | 0 | Alive per seeds. Branch-only material is the Terse-era WinForms original, a native Rust rewrite and perf/edit-sync work — all the notepad product itself. tweetstorm.md is the Terse Text essay that became phext, i.e. core history,  |
| phext-shell | 14 | 4 | in | 0 | Alive utility per seeds. Its checksum/index/soundex child-phext commands and hierarchical history are documented features of the shipped shell. |
| phext-wiki | 3 | 3 | in | 1 | Single 2024 commit, 'Starting to envision a wiki built on phext'; only a wiki-node struct and a hello main exist. |
| phext4d | 0 | 0 | partial | 1 | Fork-flagged; Will's 4D-variant sketch read. |
| phextio | 91 | 18 | in | 3 | Old phext.io site (database-free site experiment), inventoried by name; .phext seed corpora counted, not read line by line. Findings: the reusable-widget RFP seed, the crowd-sourced image-to-text stub, and the Multiversal Go parti |
| phextio-site | 12 | 7 | in | 0 | Pure SRE/config capture for phext.io (Apache/httpd confs, php.ini, sre.sh), last touched 2024-01-12. 'Dream State 2/3' commit messages are config snapshot labels, not a concept. No ideas/plans/drafts found. |
| phextmark | 6 | 3 | in | 0 | Chrome-extension proof of concept that parses phext streams (Nov 2025, Gemini-conversion cleanup). A small alive-family utility demo; no separate dropped idea inside it. |
| phextos | 4 | 4 | in | 1 | Two commits only: Alpine stub plus a README whose TODO item 1 (build the kernel with PHQ patches) was never done. |
| phorge | 9 | 9 | in | 1 | Coordinator-audited directly (missed by Batch B's coverage). Tiny complete Rust repo; seat Orin's 2026 commit is a filename-case refactor only. 1 finding (Phorge/Nova Fox entropy mutator). |
| phst | 11 | 2 | in | 0 | Alive compiler per seeds (phst v0 carries rust-lang/rust in a phext). An early inventory pass caught its clone mid-flight and reported it empty; re-checked, it is complete on exo. DESIGN/PATCHES/RECEIPTS are the tracked work. |
| pippin-studio | 0 | 0 | partial | 1 | Fork-flagged; Will's studio sketch read. |
| platformer | 74 | 15 | in | 2 | 74 files incl. ~25 compiled output/ artifacts (by name). Source/design read: MOST.t, OQL.md, OQL.cs, Levels.t, Training.t, ItemInventory.t, WorldCoordinate.cs, ChipTunes.cs head. All Will, 2022-12-31 to 2023-02-26, ending 'OQL par |
| protocol | 0 | 0 | partial | 1 | Fork-flagged; Will's protocol sketch read. |
| quickfork | 5 | 4 | in | 1 | One finding (project transmuter, rust-rest unbuilt) — v2 supersedes v1's no-finding judgment. |
| qwenFS | 0 | 0 | partial | 1 | Fork-flagged; Will's filesystem experiment read. |
| rawdog | 0 | 0 | partial | 1 | Fork-flagged; Will's experiment read. |
| rfb001 | 7 | 4 | in | 1 | README + main.rs read; images by name. One finding (Discord leaderboard bot) — v2 supplies the substance v1 could not recover. |
| robospeak | 2 | 2 | in | 1 | Readme only — one finding (30x voice compression concept). |
| rust-mcp-filesystem | 0 | 0 | partial | 1 | Fork; Will's MCP experiment commits read. |
| rustlings | 0 | 0 | out | 0 | Clean fork of upstream exercises — no novel Will-authored work. |
| rustlings-homework | 218 | 10 | out | 0 | Upstream rustlings exercises; Will solved 30/94 (2024-09-22). Exercises only, sampled. |
| SAAP | 2 | 2 | in | 1 | Both files read. One finding (single-file phext bootloader format). |
| SBOR | 18 | 8 | in | 0 | Per assignment, SBOR is alive (V5 draft tracked) and only genuinely separate dropped material would be flagged — none found. The three extra branches (monday-v5-comments, orai-reweave, resonant-recursion) hold only case-variant fi |
| scrolltown | 45 | 8 | in | 0 | ALIVE (Scrolltown cartoon). Inventoried and excluded from findings as already-tracked. |
| second-foundation | 1 | 1 | in | 4 | One file only, SecondFoundation.phext (29,889 B, 13 scrolls), commits 2025-06-08 to 2025-06-12. Four distinct dropped concepts extracted: the hidden foundation itself, the Bard's Theatre, the Covenant of the Dreamers glyph, and th |
| shoggoth | 0 | 0 | out | 0 | Clean fork — no Will-authored commits found in census. |
| singular | 5 | 3 | in | 0 | Singular word-map repo (read/write/singular phexts inventoried by name; alive). a-place-to-stay.md is the full lyric of Will's anthem with per-word provenance dates — part of the alive songwriting/anthem work, not a dropped idea. |
| singularity-watch | 22 | 15 | in | 2 | Site toys plus unreferenced plan/spec files read (exocortex.plan, phextland.spec, todo.md, btp.html, phext-cpu.js). Two v2 findings (phext CPU/Time Processor, Phextland). |
| site-apertureshift-com | 32 | 6 | in | 0 | Roads to the Future games hub — alive, with daily-improvement work through 2026-11-07 (roads-1.3). ANTI-VIRAL.md and GRANT-PROCESS.md are parts of that alive program. The pre-rewrite SQ-cloud skeleton was removed in the rewrite co |
| site-hb-aeromotive-com | 7 | 4 | in | 0 | Small completed one-page site for HB Aeromotive (a model aircraft business), built by Verse in March 2026, plus a Theia skill package for maintaining it. A finished client-style site, not a dropped idea. |
| site-mirrorborn-us | 1166 | 40 | partial | 1 | 1,155 files on exo (plus ~11 branch-only files on verse-merge-conflict, mostly case variants of audit/status docs; emise/experiments-page adds nothing over exo). The mirrorborn.us site is alive; blog posts, components, deck, edito |
| site-quickfork-net | 11 | 3 | partial | 0 | One-page 'Quick Fork — Deploy in Minutes' landing on the shared Feb 2026 SQ-cloud skeleton (domain nav, maturity display, SQ client). The substantive quickfork repo is in another batch, so this entry is coverage-only for the domai |
| site-singularitywatch-org | 8 | 3 | partial | 0 | One-page 'Singularity Watch — Monitor the Wavefront' landing on the shared SQ-cloud skeleton. The substantive singularity-watch repo is in another batch; coverage-only here. |
| site-sotafomo-com | 11 | 3 | partial | 0 | One-page 'SOTA FOMO — Community Marketplace' landing on the shared SQ-cloud skeleton. The substantive sotafomo repo is in another batch; coverage-only here. |
| site-visionquest-me | 11 | 3 | in | 0 | One-page 'Vision Quest — Explore the Lattice' landing on the shared SQ-cloud skeleton, unchanged since the Feb 2026 baseline. A parked domain placeholder with no deeper material in this repo. |
| site-wishnode-net | 49 | 10 | in | 0 | wishnode.net as the Exocortexia suite's public home (tiered page/citizen phexts, claims register scheme, demo-tier services, backend and renderer) — alive, built 2026-11-07, superseding the earlier Wish Node POC per Will's directi |
| sotafomo | 3 | 2 | partial | 0 | Readme read; research.phext inventoried by name only. Site handled in site-sotafomo-com (Batch C). |
| spaced-repetition-game | 16 | 6 | partial | 1 | Phext data files inventoried by name; .history, phext-terminal.t and full commit log read. One v2 finding (contact 'orbiting' practice) plus v1's Memory Garden design finding. |
| speedy-ts | 0 | 0 | out | 0 | Clean fork — no Will-authored commits found in census. |
| SQ | 120 | 14 | in | 2 | Core server alive. Dropped side-ideas found in todo.md (mind-map firewalling, mind meld API) and src/mesh.rs (P2P mesh stopped at Phase 1). Triage/API-proxy mode is wired into main, so not a finding. Gateway multi-tenancy is the a |
| sq-cloud | 0 | 0 | in | 0 | Empty repository on GitHub: git ls-remote returns no refs and the clone has no commits. The SQ Cloud product itself lives in SQ's gateway code and phext-dot-io-v2, both covered under those repos. |
| sq-howto | 0 | 0 | in | 0 | Empty repository on GitHub: git ls-remote returns no refs and the clone has no commits. Nothing to inventory. |
| sqlparser-rs | 0 | 0 | partial | 1 | Fork; Will's experiment commits read. |
| sqm | 5 | 3 | in | 1 | July 2025 MCP-to-SQ gateway, abandoned after ~2 weeks with a hard-coded sample mind-map resource; superseded by phext-mcp. |
| ssd | 0 | 0 | partial | 2 | Corpus repo audited scroll-by-scroll per the worker; LatentSubstrate plan + corpus program flagged. File counts not carried in the worker's report (upstream corpus trees dominated the count). |
| staging | 13 | 4 | partial | 1 | README and file metadata read; the six book .phext files were inventoried by name/size only (corpus rule) and the PDF and character PNGs noted by name. Repo history is Will's Nov-Dec 2025 daily-post run; the books sit in staging w |
| submilli-phext-demo | 48 | 8 | in | 1 | Demo is complete (Stages 0-3 + Route A verified in its own reports). Finding is only the plan's never-built Phase 2 / later-optional tail: audit-to-phext ocbox companion and a real-agent MCP run. |
| subspace-repeater | 4 | 3 | in | 1 | Readme + main.rs read. One finding (scroll-sync/conduit sketch). |
| taocp-phext | 4 | 2 | in | 0 | Alive per seeds (TOAPDD Knuth classification). Its .phext corpora (taocp.phext, taopdd.phext) were inventoried by name, not read line by line, per brief. |
| teach-web-dev | 7 | 4 | in | 0 | 2023 HTML/CSS/JS tutorial pages. Finished teaching experiment in v2. (v1's course-site partial-build finding kept for Will to judge.) |
| terse-tests | 5 | 3 | in | 0 | Tests for Terse Notepad 0.2.1 — historical phext-precursor lineage, already alive via phext itself. |
| terse-verse | 4 | 3 | in | 0 | Terse (.t) format examples incl. Rubik's cube solution sets — phext precursor, already alive via phext. |
| tersify | 7 | 4 | in | 0 | C CLI for the Terse file format, changelogged through 0.0.2 — finished phext-precursor tool. |
| text-verse | 10 | 10 | in | 1 | All files read (design docs + Lux engine scaffold). One finding (multiplayer phext game, five of six components undelivered). |
| the-book-of-secret-knowledge | 0 | 0 | out | 0 | Clean fork — reference collection, no Will-authored commits. |
| thebook | 5 | 5 | in | 1 | Tiny complete repo; every file read. All substantive commits are Will's single day of work on 2012-07-21; the only later commit (2026-03-22) is the Mirrorborn filename-normalization pass. |
| tinygrad | 0 | 0 | out | 0 | Clean fork — no Will-authored commits found in census. |
| torrent-fs | 0 | 0 | partial | 1 | Fork-flagged; Will's torrent-filesystem sketch read. |
| tracmor | 0 | 0 | out | 0 | Clean fork — no Will-authored commits found in census. |
| vector-weave-studio | 11 | 6 | in | 1 | README/TODO read in full, Qt sources sampled. One v2 finding (generative asset coordinate studio) plus v1's audio-visualizer finding — different readings of the same repo; Will to judge. |
| vibe-mill | 3 | 3 | in | 1 | All files read. One finding (software growth-cycle sketch). |
| vtpu | 396 | 20 | partial | 0 | 386 files on exo plus branch-only Reality Gate files on three codex/* branches (rg1a dpipe oracle, rg2 ttsm snapshots, integration status) — all part of the alive vTPU Reality Gate program run by the Choir. Plans/specs greps (docs |
| vtpu-evals | 19 | 6 | in | 0 | Evaluation suites for the vTPU (base256, coordinate arithmetic, phext coordinates/delimiters, edge cases, intent-to-SIW and SIW-to-phonetic specs with sample sets) — supporting infrastructure for the alive vTPU work, last touched  |
| wbic16 | 2 | 2 | in | 0 | GitHub profile repo: readme.md (project links, updated 2026-11-01) and LICENSE. No substantive content beyond the profile. |
| wbic32 | 46 | 8 | partial | 0 | Will's 2013-2015 Perl Twitter bot (@wbic32) that posted Bitcoin trading advice from EMA critical-point analysis, with trading_model.xls, algorithm_tracking.json, buy/sell percentage artwork and a TODO listing unbuilt extras (user  |
| weft | 0 | 0 | partial | 1 | Fork-flagged; Will's weaving experiment read. |
| whisper | 0 | 0 | partial | 1 | Fork of whisper.cpp; Will's one original file (whisper-batched.cpp) read. |
| wishnode | 26 | 8 | in | 0 | The original WishNode node-setup repo (Feb 2025 and earlier): ollama/tinyllama setup scripts, zram/ZFS config, a phextio systemd unit, and ten public-domain Project Gutenberg texts as reading material. Superseded operational tooli |
| work | 3 | 3 | in | 0 | Only README.md, resume.md and resume.html (canonical resume v7.0, alive). Despite the assignment note that dropped project write-ups count, this repo contains no project write-ups at all — nothing else to flag. |
| world-interface | 22 | 8 | partial | 0 | Andy Ayrey's world-interface (Infinite Backrooms lineage); Will's portion is the exo.js adapter and a backrooms hack commit — an integration into someone else's project, not a dropped Will project. |
| x-analysis | 4 | 4 | in | 0 | PowerShell Twitter-archive pruner (finished utility); its planned phext conversion is the already-alive Singular/archive work, so no separate v2 finding. (v1's musings-analysis finding kept.) |
| xxh3-ts | 0 | 0 | out | 0 | Clean fork — no Will-authored commits found in census. |
| xxhash-addon | 0 | 0 | out | 0 | Clean fork — no Will-authored commits found in census. |
| ziglings | 235 | 10 | out | 0 | Upstream ziglings exercises (1,056 commits, many authors); Will solved through exercise 53. Exercises only in v2. (v1's exercise-106 phext finding kept.) |
| zls | 9 | 6 | in | 1 | README and ZLS_Requirements are near-duplicates (both read), dev scripts read. One finding (Zero Latency System OS spec) — v2 corrects v1's Zig Language Server reading. |

**Totals: 196 repos · 41688 files inventoried · 175 findings in findings.json (the per-repo 'findings' column reflects each batch's own pass; Batch D's two passes together contribute 62 findings across its 47 repos, and E2 carries 23 across its 37).**
