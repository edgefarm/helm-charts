{{/*
Expand the name of the chart.
*/}}
{{- define "kube-proxy.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kube-proxy.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "kube-proxy.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kube-proxy.labels" -}}
helm.sh/chart: {{ include "kube-proxy.chart" . }}
{{ include "kube-proxy.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kube-proxy.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kube-proxy.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "kube-proxy.serviceAccountName" -}}
{{- default (include "kube-proxy.fullname" .) .Release.Name }}
{{- end }}

{{/* Define a custom template function to get the server address */}}
{{- define "kube-proxy.getServerAddress" -}}
{{- if and .Values.kuberneteServerAddr.manual.enabled .Values.kuberneteServerAddr.lookup.enabled }}
  {{- fail "kuberneteServerAddr.manual.enabled and kuberneteServerAddr.lookup.enabled cannot be true at the same time" }}
{{- else if .Values.kuberneteServerAddr.manual.enabled }}
  {{- $host := .Values.kuberneteServerAddr.manual.host }}
  {{- $port := .Values.kuberneteServerAddr.manual.port }}
  {{- printf "https://%s:%s" $host ($port | toString) }}
{{- else if .Values.kuberneteServerAddr.lookup.enabled }}
  {{- $secretObj := (lookup "v1" "Secret" .Values.kuberneteServerAddr.lookup.secretRef.namespace .Values.kuberneteServerAddr.lookup.secretRef.name ) | default dict }}
  {{- $secretData := (get $secretObj "data") | default dict }}
  {{- $host := (get $secretData .Values.kuberneteServerAddr.lookup.secretRef.keys.host ) | b64dec }}
  {{- $port := (get $secretData .Values.kuberneteServerAddr.lookup.secretRef.keys.port ) | b64dec }}
  {{- printf "https://%s:%s" $host $port }}
{{- end -}}
{{- end -}}