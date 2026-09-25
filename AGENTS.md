# Working on this nvim config

## No migration code

Keep configuration files focused on the current desired state. Do not add
migration, compatibility, or cleanup code for bindings and settings from older
versions of this repository. In particular, do not add `unmap` or `unlet`
commands to `ideavimrc` just to remove a former binding when Alan sources it.

## Prefer the nvim-community "meta" over what's closest to IntelliJ

When recommending or adding plugins/workflows, default to whatever the nvim community
currently converges on, not whatever most closely replicates an IntelliJ feature. These
often diverge — e.g. a persistent IntelliJ-style Project view sidebar (nvim-tree/neo-tree)
is not the current community favorite; buffer-based/floating explorers like `oil.nvim` and
`mini.files` are, precisely because they reject the always-on-sidebar IDE paradigm.

If a request is basically "give me the IntelliJ version of X," call it out and name the
current nvim-native/community-preferred alternative before implementing the IntelliJ-alike,
even if that alternative looks less familiar coming from an IDE.

## Plugin lockfile

Let lazy.nvim manage `lazy-lock.json`. Plugin installs or updates may naturally bump
other plugin versions; review and commit the generated lockfile rather than hand-editing
entries to keep the diff limited to one plugin. Verify Neovim starts with the recorded
versions.
