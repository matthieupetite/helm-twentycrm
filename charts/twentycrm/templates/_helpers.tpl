{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Validate storage configuration for HA deployments
*/}}
{{- define "twentycrm.validateStorage" -}}
{{- $totalPods := add (int .Values.server.replicas) (int .Values.worker.replicas) -}}
{{- if and (gt $totalPods 1) (eq .Values.server.storageAccessMode "ReadWriteOnce") -}}
{{- fail (printf "ERROR: High Availability deployment detected (%d server + %d worker replicas = %d total pods) but storage is configured as ReadWriteOnce.\n\nTo fix this issue, you need to:\n1. Use a ReadWriteMany-capable storage class (ceph-cephfs, nfs, efs, azurefile, etc.)\n2. Set server.storageAccessMode to 'ReadWriteMany' in your values.yaml\n\nExample:\n  server:\n    replicas: %d\n    storageAccessMode: ReadWriteMany\n    storageClassName: ceph-cephfs  # or nfs, efs, azurefile\n  worker:\n    replicas: %d\n\nFor single-instance deployments, set both replicas to 1." (int .Values.server.replicas) (int .Values.worker.replicas) $totalPods (int .Values.server.replicas) (int .Values.worker.replicas)) -}}
{{- end -}}
{{- end -}}


