# TicTacToeTalk

A console TicTacToe game in Logtalk, which you play against the computer.

![workflow](https://github.com/PaulBrownMagic/tictactoetalk/workflows/Workflow/badge.svg)

This repo [workflow](https://github.com/PaulBrownMagic/TicTacToeTalk/blob/master/.github/workflows/workflow.yml) automatically runs (on commit events) tests, publishes a
[code coverage report](https://PaulBrownMagic.github.io/TicTacToeTalk/coverage_report.html), and makes available as build artifacts the TAP report, the code coverage report, the API documentation, the source code diagrams, and the SWI-Prolog 8.1.x QLF files with the precompiled game.

## How to play

Launch Logtalk and load the game:

```logtalk
?- {loader}.
```

Then you have a choice of difficulties:

```logtalk
?- game(easy)::play.
```
or
```logtalk
?- game(hard)::play.
```
or you can play against another human:
```logtalk
?- game('2p')::play.
```

In an easy game the computer makes random moves. In the hard game it
uses a smart strategy to actively try and win, but not so smart that
it's impossible to win!

## Portability

Due to the use of non-ASCII characters to draw the board, the current
version requires a backend that supports UTF-8 encoding. The game can
currently be played on CxProlog, SICStus Prolog, SWI-Prolog, and YAP.

## Design

We've tried to keep this a relatively simple but comprehensive example.
So for the OO we're only using objects, parametric objects, and a couple
of extensions. A high-level view of the design:

![object model](design/ord.png)

However, we've also made an effort to include documentation and unit
tests to demonstrate the utility of the Logtalk ecosystem, hence the
workflow badge and information above.
