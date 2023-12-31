{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "ik-core.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ik-core.fullname" -}}
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
{{- define "ik-core.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ik-core.labels" -}}
helm.sh/chart: {{ include "ik-core.chart" . }}
{{ include "ik-core.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ik-core.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ik-core.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ik-core.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
    {{- default (include "ik-core.fullname" .) .Values.serviceAccount.name }}
{{- else }}
    {{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Returns user's password or use default
*/}}
{{- define "getOrDefaultPass" }}
{{- if not .Values.adminPassword -}}
{{- printf "$2a$10$zcHepmzfKPoxCVCYZr5K7ORPZZ/ySe9p/7IUb/8u./xHrnSX2LOCO" -}}
{{- else -}}
{{- printf "%s" .Values.adminPassword -}}
{{- end -}}
{{- end }}

{{/*
Returns user's password or use default. Used by NOTES.txt
*/}}
{{- define "printOrDefaultPass" }}
{{- if not .Values.adminPassword -}}
{{- printf "P@88w0rd" -}}
{{- else -}}
{{- printf "%s" .Values.adminPassword -}}
{{- end -}}
{{- end }}

{{- define "getNodeAddress" -}}
{{- $address := "127.0.0.1"}}
{{- with $nodes := lookup "v1" "Node" "" "" }}
{{- $node := first $nodes.items -}}
{{- range $k, $v := $node.status.addresses }}
  {{- if (eq $v.type "InternalIP") }}
     {{- $address = $v.address }}
  {{- end }}
{{- end }}
{{- else }}
{{- end }}
{{- printf "%s" $address }}
{{- end }}