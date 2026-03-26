#!/bin/sh
# Custom git merge driver for quiz2.html
# Resolves VERSION line conflicts by always taking the feature branch (theirs) version.
#
# Git passes: %O=ancestor %A=current(ours) %B=other(theirs)
# The driver must write the resolved result into %A and exit 0 for success.

BASE="$1"   # ancestor
OURS="$2"   # current branch file (the file git will use as result)
THEIRS="$3" # incoming branch file

python3 - "$OURS" "$THEIRS" <<'PYEOF'
import re, sys

ours_path = sys.argv[1]
theirs_path = sys.argv[2]

ours = open(ours_path, encoding='utf-8').read()
theirs = open(theirs_path, encoding='utf-8').read()

# Extract VERSION value from theirs (feature branch)
m = re.search(r"const VERSION\s*=\s*'([^']*)'", theirs)
if m:
    version = m.group(1)
    # Replace VERSION line in ours with theirs version
    ours = re.sub(r"(const VERSION\s*=\s*)'[^']*'", r"\g<1>'" + version + "'", ours)

open(ours_path, 'w', encoding='utf-8').write(ours)
PYEOF
