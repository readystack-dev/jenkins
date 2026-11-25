#!/bin/sh
# Refuse an unsecured first start, sync the image's reference files into JENKINS_HOME, run the war.
#
# Plain `java -jar jenkins.war` does NOT copy /usr/share/jenkins/ref into JENKINS_HOME —
# upstream's image does that in its own jenkins.sh via copy_reference_file.sh, which we do not
# use. Without this the vendored plugins and the security bootstrap would sit in the image and
# never be seen.
set -e
: "${JENKINS_HOME:=/var/jenkins_home}"
REF=/usr/share/jenkins/ref

# 1. Never start an unsecured Jenkins. runSetupWizard=false (below) skips the only code that
# creates a security realm, so a JENKINS_HOME without one would come up with anonymous users
# holding full administrative rights. The init.groovy.d bootstrap creates the administrator
# from JENKINS_ADMIN_PASSWORD; without the variable, start only a JENKINS_HOME whose config.xml
# already names a security realm (a restored or already-secured home).
realm=$(sed -n 's/.*<securityRealm class="\([^"]*\)".*/\1/p' "$JENKINS_HOME/config.xml" 2>/dev/null | head -n 1)
if [ -z "${JENKINS_ADMIN_PASSWORD:-}" ] && { [ -z "$realm" ] || [ "$realm" = 'hudson.security.SecurityRealm$None' ]; }; then
  echo "entrypoint: JENKINS_ADMIN_PASSWORD is not set and $JENKINS_HOME has no security realm yet: refusing to start an unsecured Jenkins." >&2
  echo "entrypoint: set JENKINS_ADMIN_PASSWORD (and optionally JENKINS_ADMIN_USER) and start again; the bootstrap then creates that administrator and turns anonymous access off. Once the security realm exists the variable is no longer needed." >&2
  exit 1
fi

mkdir -p "$JENKINS_HOME"

# 2. init.groovy.d holds the image's security bootstrap: kept identical to the image's copy on
# every start, so a newer image's bootstrap reaches an existing JENKINS_HOME. Scripts of your
# own under other names are left alone.
if [ -d "$REF/init.groovy.d" ]; then
  mkdir -p "$JENKINS_HOME/init.groovy.d"
  for f in "$REF/init.groovy.d"/*; do
    [ -f "$f" ] || continue
    t="$JENKINS_HOME/init.groovy.d/${f##*/}"
    cmp -s "$f" "$t" || cp "$f" "$t"
  done
fi

# 3. Shipped plugins. $JENKINS_HOME/.ref-installed/plugins/<file>.sha256 records the image build
# of each plugin this entrypoint last installed (the job upstream's copy_reference_file.sh does):
#  - missing from plugins/, never installed            -> install it
#  - missing from plugins/, installed before           -> uninstalled in Jenkins: leave it out
#  - the image ships the build it last installed       -> leave plugins/ alone (yours if changed)
#  - the image ships a different build, plugins/ holds
#    the build the image last installed                -> replace it with the image's build
#  - ... but plugins/ holds a file you changed (or one
#    the plugin manager updated: a <name>.bak exists)  -> keep yours
# Replacing a plugin also removes its unpacked directory, so Jenkins unpacks the new build.
if [ -d "$REF/plugins" ]; then
  mkdir -p "$JENKINS_HOME/plugins" "$JENKINS_HOME/.ref-installed/plugins"
  added=0; updated=0; kept=0; absent=0
  for f in "$REF/plugins"/*; do
    [ -f "$f" ] || continue
    n=${f##*/}
    case "$n" in *.jpi|*.hpi) b=${n%.?pi} ;; *) continue ;; esac
    [ -n "$b" ] || continue
    t="$JENKINS_HOME/plugins/$n"
    rec="$JENKINS_HOME/.ref-installed/plugins/$n.sha256"
    new=$(sha256sum < "$f" | cut -d ' ' -f 1)
    old=$(cat "$rec" 2>/dev/null || true)
    if [ ! -e "$t" ]; then
      if [ -n "$old" ]; then absent=$((absent + 1)); continue; fi
      cp "$f" "$t"; echo "$new" > "$rec"; added=$((added + 1)); continue
    fi
    [ "$old" = "$new" ] && continue
    cur=$(sha256sum < "$t" | cut -d ' ' -f 1)
    if [ "$cur" = "$new" ]; then echo "$new" > "$rec"; continue; fi
    if { [ -n "$old" ] && [ "$cur" != "$old" ]; } || { [ -z "$old" ] && [ -e "$JENKINS_HOME/plugins/$b.bak" ]; }; then
      echo "entrypoint: keeping plugins/$n: it was changed in JENKINS_HOME; this image ships a different build"
      echo "$new" > "$rec"; kept=$((kept + 1)); continue
    fi
    rm -rf "$JENKINS_HOME/plugins/$b"
    cp "$f" "$t"; echo "$new" > "$rec"
    echo "entrypoint: replaced plugins/$n with this image's build"; updated=$((updated + 1))
  done
  echo "entrypoint: shipped plugins: $added installed, $updated replaced with this image's build, $kept kept as changed in JENKINS_HOME, $absent left out (uninstalled)"
fi

# The setup-wizard and update-centre switches are part of the command line, not of JAVA_OPTS, so
# a JAVA_OPTS you pass adds to them instead of replacing them.
exec java -Djenkins.install.runSetupWizard=false -Dhudson.model.UpdateCenter.never=true \
  -Dhudson.model.DownloadService.never=true $JAVA_OPTS -jar /usr/share/jenkins/jenkins.war $JENKINS_OPTS
