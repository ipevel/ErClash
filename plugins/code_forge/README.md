# code_forge

The code editor behind ErClash's profile, script and config editors
(`lib/pages/editor.dart`). The package is based on
[code_forge](https://github.com/heckmon/code_forge) 10.14.0 by Athul A S, distributed
under the MIT license (see `LICENSE`). ErClash is its only user, so it carries only
what ErClash needs.

## What this package contains

- The Rust backend (rope buffer, fold ranges, bracket matching, indent guides,
  completion words) is the `editor/` module of `plugins/rust_api`, loaded through
  the app's single `RustLib`; this package has no native build of its own.
- Vertical layout goes through one row-based `ViewLineLayout` (prefix sums over
  per-line row counts, folded lines take no rows), so scrolling and jumping stay
  logarithmic in large documents.
- Left out: the language server client (hover, diagnostics, semantic tokens, code
  actions, signature help, snippets), AI completion and ghost text, git diff and
  line/gutter decorations, document colors and the color picker, inlay hints,
  occurrence highlights, right-to-left layout, multiple cursors, folding and
  indent guides for XML tags, and the built-in context menu, suggestion popup
  and scrollbar with the options that styled them.
- Present for ErClash: `suggestionPopupBuilder`, `onContextMenu` and
  `scrollbarBuilder` hooks, a `completionSource` the app fills the popup from,
  with Tab-stop snippets as what a suggestion inserts, platform keyboard shortcuts
  (`CodeForgeKeyboardShortcuts.forPlatform`), whole-line copy and cut with no
  selection, line selection from the gutter, and Material from `material_ui`.

Regression tests live in `test/plugins/code_forge/` at the repository root.
