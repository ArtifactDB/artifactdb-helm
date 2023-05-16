{{/*
Expand the name of the chart.
*/}}
{{- define "adb.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "adb.fullname" -}}
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
{{- define "adb.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "adb.labels" -}}
helm.sh/chart: {{ include "adb.chart" . }}
{{ include "adb.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
env: {{ .Values.global.env }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "adb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "adb.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "adb.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "adb.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "adb.namespace" -}}
{{- if .Values.namespaceOverride }}
{{- .Values.namespaceOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Namespace }}
{{- end }}
{{- end }}

{{/*
VersionString generation
*/}}
{{- define "adb.version" -}}
{{- .Chart.AppVersion }}-{{- .Values.env }}-{{- .Values.Version }}
{{- end }}

{{/*
API path prefix
*/}}
{{- define "adb.api_hostname" -}}
{{- if .Values.ingress.hostname }}
{{- .Values.ingress.hostname }}
{{- else }}
{{- fail "ingress.hostname must be set to generate ingress rule" }}
{{- end }} 
{{- end }}

{{/*
API path prefix
normalize resulting prefix so it can be used by appending/prepending "/" and avoid "//"
This is an opinion(h)ated implementation of what a path prefix should be.
*/}}
{{- define "adb.api_prefix" -}}
{{- $prefix := printf "%s/%s" (default "" .Values.ingress.prefix) (default "" .Values.global.instance_version) }}
{{- $prefix = trimPrefix "/" $prefix }}
{{- $prefix = trimSuffix "/" $prefix }}
{{- if ne "" $prefix }}
{{- printf "/%s" $prefix }}
{{- else }}
{{- printf "" }}
{{- end }}
{{- end }}

{{/*
Ingress type
*/}}
{{- define "ingress-type" -}}
{{- default "traefik" .Values.ingress.type }}
{{- end }}

{{/* Local/dev mode, mounting code from host (volumes)
*/}}
{{- define "local-code-volumes" -}}
{{- if .Values.global.src_folder }}
{{- if .Values.mountLocalCode }}
- name: src-code
  hostPath:
    path: "/code/{{ .Values.global.src_folder }}"
{{- end }}
{{- if .Values.mountLocalLib }}
- name: src-lib
  hostPath:
    path: "/code/lib"
{{- end }}
{{- else }}
{{- fail "global.src_folder must be set to mount code from host" }}
{{- end }} 
{{- end }}


{{/* Local/dev mode, mounting code from host (volume mounts)
*/}}
{{- define "local-code-volume-mounts" -}}
{{- if .Values.global.src_folder }}
{{- if .Values.mountLocalCode }}
- mountPath: /app
  name: src-code
{{- end }}
{{- if .Values.mountLocalLib }}
- mountPath: /app/lib
  name: src-lib
{{- end }}
{{- else }}
{{- fail "global.src_folder must be set to mount code from host" }}
{{- end }} 
{{- end }}

{{/* Set PYTHONPATH depending on environment */}}
{{- define "adb.pythonpath" -}}
{{- $pythonpath := .Values.global.pythonpath }}
{{- if .Values.global.standalone }}
{{/* Point to standalone code  */}}
{{- $pythonpath = printf "%s:%s" $pythonpath .Values.global.standalone.src_path }}
{{- end }}
{{- if .Values.mountLocalLib }}
{{/* Expecting lib code within /app */}}
{{- $pythonpath = printf "/app/lib/artifactdb-utils/src:/app/lib/artifactdb-identifiers/src:/app/lib/artifactdb-backend/src:%s" $pythonpath }}
{{- end }}
- name: PYTHONPATH
  value: {{ printf "%s" $pythonpath }}
{{- end }}
