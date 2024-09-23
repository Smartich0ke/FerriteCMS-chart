{{/*
Expand the name of the chart.
*/}}
{{- define "ferritecms.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ferritecms.fullname" -}}
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
{{- define "ferritecms.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "ferritecms.labels" -}}
helm.sh/chart: {{ include "ferritecms.chart" . }}
{{ include "ferritecms.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ferritecms.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ferritecms.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ferritecms.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ferritecms.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "ferritecms.commonEnvVars" -}}
- name: APP_KEY
  valueFrom:
    secretKeyRef:
      name: {{ if .Values.appKey.useExistingSecret }}{{ .Values.appKey.existingSecretName }}{{ else }}{{ include "ferritecms.fullname" . }}-app-key{{ end }}
      key: key
- name: DB_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ if .Values.database.auth.useExistingSecret }}{{ .Values.database.auth.existingSecretName }}{{ else }}{{ include "ferritecms.fullname" . }}-db-credentials{{ end }}
      key: username
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ if .Values.database.auth.useExistingSecret }}{{ .Values.database.auth.existingSecretName }}{{ else }}{{ include "ferritecms.fullname" . }}-db-credentials{{ end }}
      key: password
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ if .Values.redis.auth.useExistingSecret }}{{ .Values.redis.auth.existingSecretName }}{{ else }}{{ include "ferritecms.fullname" . }}-redis-credentials{{ end }}
      key: password
- name: MAIL_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ if .Values.mail.useExistingSecret }}{{ .Values.mail.existingSecretName }}{{ else }}{{ include "ferritecms.fullname" . }}-mail-credentials{{ end }}
      key: username
- name: MAIL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ if .Values.mail.useExistingSecret }}{{ .Values.mail.existingSecretName }}{{ else }}{{ include "ferritecms.fullname" . }}-mail-credentials{{ end }}
      key: password
{{- if .Values.authentik.enabled }}
- name: AUTHENTIK_CLIENT_ID
  valueFrom:
    secretKeyRef:
      name: {{ if .Values.authentik.useExistingSecret }}{{ .Values.authentik.existingSecretName }}{{ else }}{{ include "ferritecms.fullname" . }}-authentik-credentials{{ end }}
      key: client-id
- name: AUTHENTIK_CLIENT_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ if .Values.authentik.useExistingSecret }}{{ .Values.authentik.existingSecretName }}{{ else }}{{ include "ferritecms.fullname" . }}-authentik-credentials{{ end }}
      key: client-secret
{{- end }}
{{- end }}
