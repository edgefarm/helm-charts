{{/*
Expand the name of the chart.
*/}}
{{- define "node-servant-applier.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "node-servant-applier.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "node-servant-applier.labels" -}}
helm.sh/chart: {{ include "node-servant-applier.chart" . }}
{{ include "node-servant-applier.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "node-servant-applier.selectorLabels" -}}
app.kubernetes.io/name: {{ include "node-servant-applier.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
