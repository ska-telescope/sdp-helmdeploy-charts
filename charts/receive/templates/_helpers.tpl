{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "receive.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "receive.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "receive.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "receive.labels" -}}
helm.sh/chart: {{ include "receive.chart" . }}
{{ include "receive.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "receive.selectorLabels" -}}
app.kubernetes.io/name: {{ include "receive.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/* Environment variables for HTTP proxy settings */}}
{{- define "receive.http-proxy" -}}
{{- $noproxy := list  "localhost" "127.0.0.1" "10.96.0.0/12" "172.17.0.1/12" -}}
{{- if eq $.Values.proxy.use true }}
- name: http_proxy
  value: {{ printf "%s%s" "http://" .Values.proxy.server | quote  }}
- name: https_proxy
  value: {{ printf "%s%s" "http://" .Values.proxy.server | quote }}
- name: no_proxy
  value: {{ join "," $noproxy | quote }}
{{- end }}
{{- end -}}
