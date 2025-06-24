{{/* vim: set filetype=mustache: */}}

{{- define "router.labels" -}}
{{- include "common.labels" . }}
{{- range $k, $v := .Values.router.metadata.labels }}
{{ $k | quote }}: {{ $v | quote }}
{{- end }}
{{- end -}}

{{- define "router.match.labels" -}}
{{ .Values.domain }}/name: {{ .Values.name }}
{{ .Values.domain }}/version: {{ .Values.version }}
{{ .Values.domain }}/component: {{ include "druid.name" . }}-druid-router
{{- end -}}

{{- define "router.annotations" -}}
{{- include "common.annotations" . }}
{{- range $k, $v := .Values.router.metadata.annotations }}
{{ $k | quote  }}: {{ $v | quote }}
{{- end }}
{{- end -}}

{{- define "router.node.selector" -}}
{{- include "druid.node.selector" . }}
{{ toYaml .Values.router.node.selector }}
eks.amazonaws.com/nodegroup: {{ include "druid.name" . }}-druid-router-node
{{- end -}}

{{- define "router.volumes" -}}
{{- include "common.volumes" . }}
{{- with .Values.router.volumes }}
{{ . | toYaml }}
{{- end }}
{{- end -}}

{{- define "router.volume.mounts" -}}
{{- include "common.volumeMounts" . }}
{{- with .Values.router.volumeMounts }}
{{ . | toYaml }}
{{- end }}
{{- end -}}

{{- define "router.jvm" -}}
{{- if .Values.router.jvm }}
{{- printf "%s\n%s" (.Files.Get "common/jvm.config") .Values.router.jvm | toYaml }}
{{- else}}
{{- .Files.Get "common/jvm.config" | toYaml }}
{{- end }}
{{- end -}}
