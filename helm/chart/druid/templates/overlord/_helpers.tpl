{{/* vim: set filetype=mustache: */}}

{{- define "overlord.labels" -}}
{{- include "common.labels" . }}
{{- range $k, $v := .Values.overlord.metadata.labels }}
{{ $k | quote }}: {{ $v | quote }}
{{- end }}
{{- end -}}

{{- define "overlord.match.labels" -}}
{{ .Values.domain }}/name: {{ .Values.name }}
{{ .Values.domain }}/version: {{ .Values.version }}
{{ .Values.domain }}/component: {{ include "druid.name" . }}-druid-overlord
{{- end -}}

{{- define "overlord.annotations" -}}
{{- include "common.annotations" . }}
{{- range $k, $v := .Values.overlord.metadata.annotations }}
{{ $k | quote }}: {{ $v | quote }}
{{- end }}
{{- end -}}

{{- define "overlord.node.selector" -}}
{{- include "druid.node.selector" . }}
{{ toYaml .Values.overlord.node.selector }}
eks.amazonaws.com/nodegroup: {{ include "druid.name" . }}-druid-overlord-node
{{- end -}}

{{- define "overlord.volumes" -}}
{{- include "common.volumes" . }}
{{- with .Values.overlord.volumes }}
{{ . | toYaml }}
{{- end }}
{{- end -}}

{{- define "overlord.volume.mounts" -}}
{{- include "common.volumeMounts" . }}
{{- with .Values.overlord.volumeMounts }}
{{ . | toYaml }}
{{- end }}
{{- end -}}

{{- define "overlord.jvm" -}}
{{- if .Values.overlord.jvm }}
{{- printf "%s\n%s" (.Files.Get "common/jvm.config") .Values.overlord.jvm | toYaml }}
{{- else}}
{{- .Files.Get "common/jvm.config" | toYaml }}
{{- end }}
{{- end -}}
