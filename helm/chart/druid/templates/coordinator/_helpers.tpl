{{/* vim: set filetype=mustache: */}}

{{- define "coordinator.labels" -}}
{{- include "common.labels" . }}
{{- range $k, $v := .Values.coordinator.metadata.labels }}
{{ $k | quote }}: {{ $v | quote }}
{{- end }}
{{- end -}}

{{- define "coordinator.match.labels" -}}
{{ .Values.domain }}/name: {{ .Values.name }}
{{ .Values.domain }}/version: {{ .Values.version }}
{{ .Values.domain }}/component: {{ include "druid.name" . }}-druid-coordinator
{{- end -}}

{{- define "coordinator.annotations" -}}
{{- include "common.annotations" . }}
{{- range $k, $v := .Values.coordinator.metadata.annotations }}
{{ $k | quote }}: {{ $v | quote }}
{{- end }}
{{- end -}}

{{- define "coordinator.node.selector" -}}
{{- include "druid.node.selector" . }}
{{ toYaml .Values.coordinator.node.selector }}
eks.amazonaws.com/nodegroup: {{ include "druid.name" . }}-druid-coordinator-node
{{- end -}}

{{- define "coordinator.volumes" -}}
{{- include "common.volumes" . }}
{{- with .Values.coordinator.volumes }}
{{ . | toYaml }}
{{- end }}
{{- end -}}

{{- define "coordinator.volume.mounts" -}}
{{- include "common.volumeMounts" . }}
{{- with .Values.coordinator.volumeMounts }}
{{ . | toYaml }}
{{- end }}
{{- end -}}

{{- define "coordinator.jvm" -}}
{{- if .Values.coordinator.jvm }}
{{- printf "%s\n%s" (.Files.Get "common/jvm.config") .Values.coordinator.jvm | toYaml }}
{{- else}}
{{- .Files.Get "common/jvm.config" | toYaml }}
{{- end }}
{{- end -}}
