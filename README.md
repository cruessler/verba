# verba

verba is a simple browser-based vocabulary learning tool.

verba presents its users vocabulary questions one at a time. The user can then
reveal the correct answer and rate their own answer on a scale from 1 to 6.
Words that get worse ratings will be shown more often in the future. verba uses
the SuperMemo 2 algorithm to determine when to show new questions. A
description of this algorithm can be found at
https://www.supermemo.com/english/ol/sm2.htm.

The interactive parts of the frontend are written in Elm while the backend is
written using Ruby on Rails. The UI is optimized for use on mobile devices.
