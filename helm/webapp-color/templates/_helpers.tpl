{{/* Expand the name of the chart. */}}
{{- define "webapp-color.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Create a default fully qualified app name. */}}
{{- define "webapp-color.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/* Selector labels */}}
{{- define "webapp-color.selectorLabels" -}}
app.kubernetes.io/name: "{{ include "webapp-color.name" . }}"
app.kubernetes.io/instance: "{{ include "webapp-color.fullname" . }}"
{{- end -}}

{{/* Common labels */}}
{{- define "webapp-color.labels" -}}
helm.sh/chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
{{ include "webapp-color.selectorLabels" . }}
app.kubernetes.io/version: "{{ .Chart.AppVersion }}"
app.kubernetes.io/managed-by: "{{ .Release.Service }}"
environment: "{{ .Values.environment }}"
{{- end -}}

{{/* ServiceAccount name */}}
{{- define "webapp-color.serviceAccountName" -}}
{{- if .Values.serviceAccount.name -}}
{{ .Values.serviceAccount.name }}
{{- else -}}
{{ include "webapp-color.fullname" . }}
{{- end -}}
{{- end -}}