#!/usr/bin/env bash
# check-tables.sh — referential-integrity validator for breadboard affordance tables.
#
# Enforces the "Before moving to Step 5, confirm" checklist mechanically:
#   - every Wires Out / Returns To reference resolves to a defined row (P#/U#/N#/S#)
#   - every N# has a Wires Out or a Returns To (dead code affordance otherwise)
#   - every S# is read or written by some affordance (orphan store otherwise)
#   - every U#/N# participates in at least one wire (isolated affordance otherwise)
#   - Wires Out targeting a U# is flagged (navigation should target its Place, P#)
#   - every P# is the home of at least one affordance
#
# It parses markdown tables only; content inside ``` fences (the Mermaid diagram)
# is ignored. Rows are classified by their first cell's ID (P#/U#/N#/S#), so the
# requirements and fit-check tables (R#, CURRENT/A/B) are skipped automatically.
#
# Usage:  check-tables.sh path/to/shape.md
# Exit:   0 = no errors (warnings allowed) · 1 = one or more errors · 2 = usage error
#
# Judgment stays with the LLM and the domain expert — this only checks what is
# mechanical. A clean run does not mean the breadboard is right, only wired-up.

set -euo pipefail

file="${1:-}"
if [ -z "$file" ]; then
  echo "usage: check-tables.sh path/to/shape.md" >&2
  exit 2
fi
if [ ! -f "$file" ]; then
  echo "error: no such file: $file" >&2
  exit 2
fi

awk '
function trim(s){ gsub(/^[ \t]+|[ \t]+$/,"",s); return s }
function isempty(s){ s=trim(s); gsub(/[-—–.]/,"",s); s=trim(s); return (length(s)==0) }

BEGIN{ infence=0; nids=0; errs=0; warns=0 }

# toggle code fences (```mermaid ... ```) and skip their contents
/^[ \t]*```/ { infence = !infence; next }
infence { next }

# markdown table rows only
/^[ \t]*\|/ {
  n=split($0, f, "|")
  for(i=1;i<=n;i++) f[i]=trim(f[i])
  id=f[2]; gsub(/[`*~ ]/,"",id)
  if (id !~ /^[PUNS][0-9]+$/) next          # header/separator/R#/other → skip

  defined[id]=1
  ids[++nids]=id
  t=substr(id,1,1)
  if (t=="U" || t=="N") {
    placeof[id]=f[3]; wout[id]=f[7]; ret[id]=f[8]
  } else if (t=="S") {
    splace[id]=f[3]
  }
  next
}

END{
  # gather referenced tokens across all Wires Out / Returns To cells
  for (k=1;k<=nids;k++){
    id=ids[k]; t=substr(id,1,1)
    if (t!="U" && t!="N") continue
    for (col=1; col<=2; col++){
      cell=(col==1)?wout[id]:ret[id]
      tmp=cell
      while (match(tmp, /[PUNS][0-9]+/)){
        tok=substr(tmp,RSTART,RLENGTH)
        targeted[tok]=1
        # remember an example source for nice messages
        if (!(tok in refby)) refby[tok]=id
        if (col==1 && tok ~ /^U[0-9]+$/)
          navwarn[id]=navwarn[id] " " tok           # Wires Out → U# (suspicious)
        if (col==2 && tok ~ /^S[0-9]+$/) sread[tok]=1
        if (tok ~ /^S[0-9]+$/) sused[tok]=1
        # dangling reference
        if (!(tok in defined)){
          printf("ERROR  %s: %s references %s, which is not a defined row\n",
                 id, (col==1?"Wires Out":"Returns To"), tok); errs++
        }
        tmp=substr(tmp, RSTART+RLENGTH)
      }
    }
    # place membership
    ptmp=placeof[id]
    while (match(ptmp, /P[0-9]+/)){ hashome[substr(ptmp,RSTART,RLENGTH)]=1; ptmp=substr(ptmp,RSTART+RLENGTH) }
  }

  for (k=1;k<=nids;k++){
    id=ids[k]; t=substr(id,1,1)

    # dead code affordance: N# with neither Wires Out nor Returns To
    if (t=="N" && isempty(wout[id]) && isempty(ret[id])){
      printf("ERROR  %s: code affordance has no Wires Out and no Returns To (dead)\n", id); errs++
    }

    # isolated UI affordance: no out and nothing pointing in
    # (an isolated N# is already caught by the stronger "dead" error above)
    if (t=="U" && isempty(wout[id]) && isempty(ret[id]) && !(id in targeted)){
      printf("WARN   %s: isolated — no wires in or out\n", id); warns++
    }

    # navigation should target the Place, not an inner UI affordance
    if ((t=="U"||t=="N") && (id in navwarn)){
      printf("WARN   %s: Wires Out targets UI affordance(s)%s — navigation should target its Place (P#)\n",
             id, navwarn[id]); warns++
    }

    # data store must be read or written by something
    if (t=="S" && !(id in sused)){
      printf("ERROR  %s: data store is never read or written by any affordance\n", id); errs++
    }

    # place must own at least one affordance
    if (t=="P" && !(id in hashome)){
      printf("WARN   %s: place has no affordances\n", id); warns++
    }
  }

  npu=0; for(k=1;k<=nids;k++){ } # no-op keep structure
  printf("\n%d affordance/place/store rows checked · %d error(s), %d warning(s)\n", nids, errs, warns)
  if (nids==0) printf("(no P#/U#/N#/S# rows found — is this the breadboard section?)\n")
  exit (errs>0 ? 1 : 0)
}
' "$file"
