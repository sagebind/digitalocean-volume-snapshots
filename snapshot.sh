#!/bin/sh
set -eu

MAX_AGE=${MAX_AGE:-7000}
now=$(date '+%s%3N')
max_age_ms=$(expr $MAX_AGE \* 24 \* 60 \* 60 \* 1000)

echo "Creating new snapshots"

doctl compute volume list --format ID,Name --no-header | while read id name; do
    doctl compute volume snapshot $id --snapshot-name "$name-$now"
done

echo "Deleting snapshots older than $MAX_AGE days"

doctl compute snapshot list --resource volume --format ID,Name --no-header | while read id name; do
    timestamp=$(echo $name | sed 's/.*-//')
    age=$(expr $now -  $timestamp)

    if [ $age -gt $max_age_ms ]; then
        doctl compute snapshot delete $id
    fi
done
