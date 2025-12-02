{{/*
Expand the name of the chart.
*/}}
{{- define "strudel.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "strudel.fullname" -}}
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
{{- define "strudel.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "strudel.labels" -}}
helm.sh/chart: {{ include "strudel.chart" . }}
{{ include "strudel.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "strudel.selectorLabels" -}}
app.kubernetes.io/name: {{ include "strudel.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Build CoreWeave hostname from service name, orgID, and clusterName
Usage: {{ include "strudel.coreweaveHostname" (dict "service" "strudel" "context" .) }}
Requires: orgID and clusterName to be set in values (via ArgoCD parameters or values file)
*/}}
{{- define "strudel.coreweaveHostname" -}}
{{- $service := .service -}}
{{- $orgID := .context.Values.orgID | default "" -}}
{{- $clusterName := .context.Values.clusterName | default "" -}}
{{- if and $orgID $clusterName -}}
{{- printf "%s.%s-%s.coreweave.app" $service $orgID $clusterName -}}
{{- else -}}
{{- fail "orgID and clusterName must be set in values (set via ArgoCD parameters: orgID and clusterName)" -}}
{{- end -}}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "strudel.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "strudel.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Grafana password manager
*/}}
{{- define "strudel.grafana.password.manager" -}}

{{- $secretName := printf "%s-grafana" (include "strudel.fullname" .) }}
{{- $existingSecret := (lookup "v1" "Secret" .Release.Namespace $secretName) }}
{{- $passwordKey := "admin-password" }}
{{- $password := "" }}

{{- if $existingSecret }}
  {{- if hasKey $existingSecret.data $passwordKey }}
    {{- $password = index $existingSecret.data $passwordKey | b64dec }}
  {{- end }}
{{- end }}

{{- if not $password }}
  {{- if .Values.grafana.adminPassword }}
    {{- $password = .Values.grafana.adminPassword }}
  {{- else }}
    {{- $password = randAlphaNum 32 }}
  {{- end }}
{{- end }}

{{- $password | b64enc | quote -}}
{{- end }}

