{{/*
Expand the name of the chart.
*/}}
{{- define "yurthub.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "yurthub.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "yurthub.labels" -}}
helm.sh/chart: {{ include "yurthub.chart" . }}
{{ include "yurthub.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "yurthub.selectorLabels" -}}
app.kubernetes.io/name: {{ include "yurthub.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Define a custom template function to get the server address */}}
{{- define "yurthub.getServerAddress" -}}
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
  {{- if or (not $host) (not $port) }}
    {{- fail "Host or port not set in the secret" }}
  {{- else }}
    {{- printf "https://%s:%s" $host $port }}
  {{- end }}
{{- end -}}
{{- end -}}