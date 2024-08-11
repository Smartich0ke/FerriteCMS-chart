{{/*
Expand the name of the chart.
*/}}
{{- define "artichoke3d.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "artichoke3d.fullname" -}}
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
{{- define "artichoke3d.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "artichoke3d.labels" -}}
helm.sh/chart: {{ include "artichoke3d.chart" . }}
{{ include "artichoke3d.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "artichoke3d.selectorLabels" -}}
app.kubernetes.io/name: {{ include "artichoke3d.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "artichoke3d.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "artichoke3d.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "artichoke3d.commonEnvVars" -}}
- name: RUN_MIGRATIONS
  value: "false"
- name: GENERATE_KEY
  value: "false"
- name: APP_KEY
  valueFrom:
    secretKeyRef:
      name: {{ if .Values.appKey.useExistingSecret }}{{ .Values.appKey.existingSecretName }}{{ else }}{{ include "artichoke3d.fullname" . }}-app-key{{ end }}
      key: key
- name: APP_ENV
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: APP_ENV
- name: APP_DEBUG
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: APP_DEBUG
- name: APP_URL
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: APP_URL
- name: APP_NAME
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: APP_NAME
- name: LOG_LEVEL
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: LOG_LEVEL
- name: LOG_CHANNEL
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: LOG_CHANNEL
- name: CACHE_DRIVER
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: CACHE_DRIVER
- name: QUEUE_CONNECTION
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: QUEUE_CONNECTION
- name: SESSION_DRIVER
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: SESSION_DRIVER
- name: DB_CONNECTION
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: DB_CONNECTION
- name: DB_HOST
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: DB_HOST
- name: DB_PORT
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: DB_PORT
- name: DB_DATABASE
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: DB_DATABASE
- name: DB_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ if .Values.database.auth.useExistingSecret }}{{ .Values.database.auth.existingSecretName }}{{ else }}{{ include "artichoke3d.fullname" . }}-db-credentials{{ end }}
      key: username
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ if .Values.database.auth.useExistingSecret }}{{ .Values.database.auth.existingSecretName }}{{ else }}{{ include "artichoke3d.fullname" . }}-db-credentials{{ end }}
      key: password
- name: REDIS_CONNECTION
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: REDIS_CONNECTION
- name: REDIS_HOST
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: REDIS_HOST
- name: REDIS_PORT
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: REDIS_PORT
- name: REDIS_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ if .Values.redis.auth.useExistingSecret }}{{ .Values.redis.auth.existingSecretName }}{{ else }}{{ include "artichoke3d.fullname" . }}-redis-credentials{{ end }}
      key: password
- name: MAIL_MAILER
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: MAIL_MAILER
- name: MAIL_HOST
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: MAIL_HOST
- name: MAIL_PORT
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: MAIL_PORT
- name: MAIL_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ if .Values.mail.useExistingSecret }}{{ .Values.mail.existingSecretName }}{{ else }}{{ include "artichoke3d.fullname" . }}-mail-credentials{{ end }}
      key: username
- name: MAIL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ if .Values.mail.useExistingSecret }}{{ .Values.mail.existingSecretName }}{{ else }}{{ include "artichoke3d.fullname" . }}-mail-credentials{{ end }}
      key: password
- name: MAIL_ENCRYPTION
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: MAIL_ENCRYPTION
- name: MAIL_FROM_ADDRESS
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: MAIL_FROM_ADDRESS
- name: MAIL_FROM_NAME
  valueFrom:
    configMapKeyRef:
      name: {{ include "artichoke3d.fullname" . }}-config
      key: MAIL_FROM_NAME
{{- end }}
