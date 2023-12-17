# Fossiliser

[![Build Status](https://github.com/pyrmont/fossiliser/workflows/build/badge.svg)](https://github.com/pyrmont/fossiliser/actions?query=workflow%3Abuild)

Fossiliser is a CLI utility written in Janet for archiving statuses from a
Mastodon user to Markdown-formatted text files.

## Installation

Build the `fossil` executable using JPM:

```sh
git clone https://github.com/pyrmont/fossiliser
cd fossiliser
jpm -l run exe-deps
jpm -l build
```

Now copy the `build/fossil` executable to a directory on your PATH.

Fossiliser can also be used as a library. Add the dependency to your `project.janet` file:

```janet
(declare-project
  :dependencies ["https://github.com/pyrmont/fossiliser"])
```

## Usage

The `fossil` executable can be used like this:

```text
Usage: fossil [--ignored-app <name>] [--mentions] [--output-dir <output-dir>] [<path>]

Archive statuses from a user on Mastodon.

Parameters:

 path    The path for the input file. (Default: stdin)

Options:

 -i, --ignored-app <name>         Statuses created by an application with this <name> will be ignored. This option can be used
                                  multiple times.
 -m, --mentions                   Include mentions in archive.
 -o, --output-dir <output-dir>    The directory in which to archive files. (Default: .)

 -h, --help                       Show this help message.
 ```

## Bugs

Found a bug? I'd love to know about it. The best way is to report your bug in
the [Issues][] section on GitHub.

[Issues]: https://github.com/pyrmont/fossiliser/issues

## Licence

fossiliser is licensed under the MIT Licence. See [LICENSE][] for more details.

[LICENSE]: https://github.com/pyrmont/fossiliser/blob/master/LICENSE
