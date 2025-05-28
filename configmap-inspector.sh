#!/bin/bash

OUTPUT_FILE="output.txt"
IGNORED_NAMESPACES=("kube-system" "kube-public" "kube-node-lease")

echo "🔍 Searching..." > "$OUTPUT_FILE"

for ns in $(kubectl get ns -o jsonpath='{.items[*].metadata.name}'); do
  if [[ " ${IGNORED_NAMESPACES[@]} " =~ " ${ns} " ]]; then
    continue
  fi

  echo "Namespace: $ns" >> "$OUTPUT_FILE"
  echo "----------------------------" >> "$OUTPUT_FILE"

  for deploy in $(kubectl get deploy -n "$ns" -o jsonpath='{.items[*].metadata.name}'); do
    deploy_yaml=$(kubectl get deploy "$deploy" -n "$ns" -o yaml)

    mount_cms=$(echo "$deploy_yaml" | yq e '.spec.template.spec.volumes[]?.configMap.name' - 2>/dev/null | grep -v null)

    env_cms=$(echo "$deploy_yaml" | yq e '.. | select(has("configMapKeyRef")) | .configMapKeyRef.name' - 2>/dev/null | grep -v null)

    used_cms=$(echo -e "$mount_cms\n$env_cms" | sort -u | grep -v '^$')

    for cm in $used_cms; do
      echo "  ConfigMap: $cm --> Deployment: $deploy" >> "$OUTPUT_FILE"
    done
  done

  echo "" >> "$OUTPUT_FILE"
done

echo "✅ Output written to output.txt"
