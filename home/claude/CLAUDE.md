@./RTK.md

# General

- Be concise. No filler, no preamble, no summaries of what you just did.
- Go straight to the point. Try the simplest approach first.
- Do not add comments, docstrings, or type annotations to code you didn't change.
- Do not over-engineer. Only make changes that are directly requested.
- Do not create files unless absolutely necessary.
- Read code before modifying it.

# Git

- Never amend commits unless explicitly asked.
- Write commit messages in imperative mood, concise, focused on the "why".
- Do not commit .env, credentials, or secrets. Warn if asked to.
- Do not push unless explicitly asked.

# Security

- Never hardcode secrets, tokens, API keys, or passwords.
- Validate all external input at system boundaries.
- Never use shell interpolation with untrusted input — use proper escaping or argument arrays.
- Prefer parameterized queries over string concatenation for any database access.
- Do not disable TLS verification, certificate checks, or security features.
- Flag any code that introduces OWASP top 10 vulnerabilities.

# Performance

- Use dedicated tools (Read, Grep, Glob, Edit) instead of shell equivalents.
- Parallelize independent tool calls in a single response.
- Use the Explore agent for broad codebase searches, direct Grep/Glob for targeted ones.
- Avoid redundant file reads — remember what you already read in this conversation.
- Keep context lean: don't dump entire files when you only need a section.
