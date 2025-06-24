{{/* vim: set filetype=mustache: */}}

{{- define "broker.labels" -}}
{{- include "common.labels" . }}
{{- range $k, $v := .Values.broker.metadata.labels }}
{{ $k | quote }}: {{ $v | quote }}
{{- end }}
{{- end -}}

{{- define "broker.match.labels" -}}
{{ .Values.domain }}/name: {{ .Values.name }}
{{ .Values.domain }}/version: {{ .Values.version }}
{{ .Values.domain }}/component: {{ include "druid.name" . }}-druid-broker
{{- end -}}

{{- define "broker.annotations" -}}
{{- include "common.annotations" . }}
{{- range $k, $v := .Values.broker.metadata.annotations }}
{{ $k | quote }}: {{ $v | quote }}
{{- end }}
{{- end -}}

{{- define "broker.node.selector" -}}
{{- include "druid.node.selector" . }}
{{ toYaml .Values.broker.node.selector }}
eks.amazonaws.com/nodegroup: {{ include "druid.name" . }}-druid-broker-node
{{- end -}}

{{- define "broker.volumes" -}}
{{- include "common.volumes" . }}
{{- with .Values.broker.volumes }}
{{ . | toYaml }}
{{- end }}
{{- end -}}

{{- define "broker.volume.mounts" -}}
{{- include "common.volumeMounts" . }}
{{- with .Values.broker.volumeMounts }}
{{ . | toYaml }}
{{- end }}
{{- end -}}

{{- define "broker.jvm" -}}
{{- if .Values.broker.jvm }}
{{- printf "%s\n%s" (.Files.Get "common/jvm.config") .Values.broker.jvm | toYaml }}
{{- else}}
{{- .Files.Get "common/jvm.config" | toYaml }}
{{- end }}
{{- end -}}
