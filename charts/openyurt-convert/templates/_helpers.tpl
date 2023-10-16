{{/*
Expand the name of the chart.
*/}}
{{- define "openyurt-convert.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "openyurt-convert.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "openyurt-convert.labels" -}}
helm.sh/chart: {{ include "openyurt-convert.chart" . }}
{{ include "openyurt-convert.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "openyurt-convert.selectorLabels" -}}
app.kubernetes.io/name: {{ include "openyurt-convert.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create a Helm template function to add seconds to the current time.
Usage: {{ addSeconds currentTime secondsToAdd }}
Based on https://git.musl-libc.org/cgit/musl/tree/src/time/__secs_to_tm.c?h=v0.9.15
*/}}
{{- define "toRFC3339" -}}
{{- $unixTime := index . "timestamp" }} 
{{- $LEAPOCH := 946684800 }}
{{- $constantDaysPer400y := 146097 }}
{{- $constantDaysPer100y := 36524 }}
{{- $constantDaysPer4y := 1461 }}

{{- $secs := sub $unixTime $LEAPOCH }}
{{- $days := div $secs 86400 }}        
{{- $remsecs := mod $secs 86400 }}     
{{- if lt $remsecs 0 }}                
  {{- $remsecs = add $remsecs 86400 }} 
  {{- $days = sub $days 1 }}           
{{- end }}                             

{{- $wday := mod (add 3 $days) 7 }}
{{- if lt $wday 0 }}                
  {{- $wday = add $wday 7 }} 
{{- end }}

{{- $qc_cycles := div $days $constantDaysPer400y }}
{{- $remdays := mod $days $constantDaysPer400y }}
{{- if lt $remdays 0 }}
  {{- $remdays = add $remdays $constantDaysPer400y }}
  {{- $qc_cycles = sub $qc_cycles 1 }}
{{- end }} 

{{- $c_cycles := div $remdays $constantDaysPer100y }}
{{- if eq $c_cycles 4 }}
  {{- $c_cycles = sub $c_cycles 1 }}
{{- end }}
{{- $remdays = sub $remdays (mul $c_cycles $constantDaysPer100y) }} 

{{- $q_cycles := div $remdays $constantDaysPer4y }}
{{- if eq $q_cycles 25 }}
  {{- $q_cycles = sub $q_cycles 1 }}
{{- end }}
{{- $remdays = sub $remdays (mul $q_cycles $constantDaysPer4y) }}

{{- $remyears := div $remdays 365 }}
{{- if eq $remyears 4 }}
  {{- $remyears = sub $remyears 1 }}
{{- end }}
{{- $remdays = sub $remdays (mul $remyears 365) }}

{{- $leap := and (eq $remyears 0) (or $q_cycles (eq $c_cycles 0)) }}

{{- $years := add $remyears (mul 4 $q_cycles) (mul 100 $c_cycles) (mul 400 $qc_cycles) -}}

{{- $months := 1 }}
{{- $days_in_month := list 31 28 31 30 31 30 31 31 30 31 30 31 }}
{{- $days_in_month_leap := list 31 29 31 30 31 30 31 31 30 31 30 31 }}
{{- $days_in_month_to_use := $days_in_month }}
{{- if $leap }}
  {{- $days_in_month_to_use = $days_in_month_leap }}
{{- end }}
{{- range $index, $days_in_month_value := $days_in_month_to_use }}
  {{- if le $remdays $days_in_month_value }}
    {{- break }}
  {{- else }}
    {{- $remdays = sub $remdays $days_in_month_value }}
    {{- $months = add $months 1 }}
  {{- end }}
{{- end }}

{{- $tm_year := add $years 2000 }}
{{- $tm_mon := $months }}
{{- $tm_mday := $remdays }}
{{- $tm_hour := div $remsecs 3600 }}
{{- $tm_min := mod (div $remsecs 60) 60 }}
{{- $tm_sec := mod $remsecs 60 }}

{{- printf "%04d-%02d-%02dT%02d:%02d:%02dZ" $tm_year $tm_mon $tm_mday $tm_hour $tm_min $tm_sec }}
{{- end }}