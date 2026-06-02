# Security Policy

## Reporting a vulnerability

If you believe you have found a security issue in CVBuilder, please report it
privately. Do not open a public issue for security problems.

Email **mihaelamj@me.com** with:

- A description of the issue and its impact.
- Steps to reproduce, or a proof of concept.
- The affected version or commit.

You can expect an acknowledgement within a few days. Once the issue is confirmed,
a fix will be prepared and a release cut, after which the issue can be disclosed
publicly with credit to the reporter if desired.

## Supported versions

CVBuilder follows Semantic Versioning. Security fixes are applied to the `main`
branch and ship in the next patch release of the current `1.x` line. The latest
`1.x` release and `main` are supported.

## Scope

CVBuilder decodes structured CV JSON and writes Markdown. Reports about malformed
input that causes crashes, excessive resource use, unsafe file access, or unsafe
Markdown output are in scope.
