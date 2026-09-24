# Running tests

Neotest supports Python (pytest, or unittest when pytest is unavailable) and
Java/Kotlin JUnit tests through Gradle. Open Neovim in the project/module root.
Python uses the project's virtual environment; provision it with `uv sync` in
uv projects. Gradle uses the project wrapper when present, otherwise `gradle`.

| Keys | Action |
| --- | --- |
| `Space t t` | Run nearest test |
| `Space t f` | Run current file |
| `Space t a` | Run tests under the working directory |
| `Space t l` | Rerun last test |
| `Space t s` | Toggle results tree |
| `Space t o` | Open test output |
| `Space t O` | Toggle accumulated output panel |
| `Space t x` | Stop test |
| `]t` / `[t` | Next/previous failed test in current file |

In the results tree, `i` jumps to a test, `o` shows output, and `r` runs it.
The failed-test motions also participate in `;` / `,` repetition.

The Gradle adapter discovers files ending in `Test.kt` or `Test.java` and uses
the module's `test` task. Custom test tasks and Maven are not configured.
`lua/config/gradle_tests.lua` queries the actual JUnit XML report location for
modern Gradle compatibility and attaches runner output to test results.

Verification: isolated passing/failing pytest, unittest, Kotlin JUnit and Java
JUnit fixtures; Python failure diagnostics, navigation, output and results UI.
The adapter compatibility regression check is:

```sh
nvim --headless -u NONE -l tests/gradle_tests.lua
```
