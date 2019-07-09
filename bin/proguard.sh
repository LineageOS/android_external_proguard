#!/bin/sh
#
# Start-up script for ProGuard -- free class file shrinker, optimizer,
# obfuscator, and preverifier for Java bytecode.
#
# Note: when passing file names containing spaces to this script,
#       you'll have to add escaped quotes around them, e.g.
#       "\"/My Directory/My File.txt\""

# Account for possibly missing/basic readlink.
# POSIX conformant (dash/ksh/zsh/bash).
PROGUARD=`readlink -f "$0" 2>/dev/null`
if test "$PROGUARD" = ''
then
  PROGUARD=`readlink "$0" 2>/dev/null`
  if test "$PROGUARD" = ''
  then
    PROGUARD="$0"
  fi
fi

PROGUARD_HOME=`dirname "$PROGUARD"`/..

# By default, give dx a max heap size of 2 gig. This can be overridden
# by using a "-J" option (see below).
defaultMx="-Xmx2G"

# The following will extract any initial parameters of the form
# "-J<stuff>" from the command line and pass them to the Java
# invocation (instead of to dx). This makes it possible for you to add
# a command-line parameter such as "-JXmx256M" in your scripts, for
# example. "java" (with no args) and "java -X" give a summary of
# available options.

declare -a javaOpts=()

while expr "x$1" : 'x-J' >/dev/null; do
    opt=`expr "x$1" : 'x-J\(.*\)'`
    javaOpts+=("-${opt}")
    if expr "x${opt}" : "xXmx[0-9]" >/dev/null; then
        defaultMx="no"
    fi
    shift
done

if [ "${defaultMx}" != "no" ]; then
    javaOpts+=("${defaultMx}")
fi

exec java "${javaOpts[@]}" -jar "$PROGUARD_HOME/lib/proguard.jar" "$@"
