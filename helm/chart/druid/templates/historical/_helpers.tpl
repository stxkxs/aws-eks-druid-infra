{{/* vim: set filetype=mustache: */}}

{{- define "historical.labels" -}}
{{- include "common.labels" . }}
{{- range $k, $v := .Values.historical.metadata.labels }}
{{ $k | quote }}: {{ $v | quote }}
{{- end }}
{{- end -}}

{{- define "historical.match.labels" -}}
{{ .Values.domain }}/name: {{ .Values.name }}
{{ .Values.domain }}/version: {{ .Values.version }}
{{ .Values.domain }}/component: {{ include "druid.name" . }}-druid-historical
{{- end -}}

{{- define "historical.annotations" -}}
{{- include "common.annotations" . }}
{{- range $k, $v := .Values.historical.metadata.annotations }}
{{ $k | quote }}: {{ $v | quote }}
{{- end }}
{{- end -}}

{{- define "historical.node.selector" -}}
{{- include "druid.node.selector" . }}
{{ toYaml .Values.historical.node.selector }}
eks.amazonaws.com/nodegroup: {{ include "druid.name" . }}-druid-historical-node
{{- end -}}

{{- define "historical.volumes" -}}
{{- include "common.volumes" . }}
{{- with .Values.historical.volumes }}
{{ . | toYaml }}
{{- end }}
{{- end -}}

{{- define "historical.volume.mounts" -}}
{{- include "common.volumeMounts" . }}
{{- with .Values.historical.volumeMounts }}
{{ . | toYaml }}
{{- end }}
{{- end -}}

{{- define "historical.jvm" -}}
{{- if .Values.historical.jvm }}
{{- printf "%s\n%s" (.Files.Get "common/jvm.config") .Values.historical.jvm | toYaml }}
{{- else}}
{{- .Files.Get "common/jvm.config" | toYaml }}
{{- end }}
{{- end -}}
