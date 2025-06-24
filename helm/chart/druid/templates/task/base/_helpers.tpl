{{/* vim: set filetype=mustache: */}}

{{- define "task.base.labels" -}}
{{- include "common.labels" . }}
{{- range $k, $v := .Values.task.base.metadata.labels }}
{{ $k | quote }}: {{ $v | quote }}
{{- end }}
{{- end -}}

{{- define "task.base.annotations" -}}
{{- include "common.annotations" . }}
{{- range $k, $v := .Values.task.base.metadata.annotations }}
{{ $k | quote }}: {{ $v | quote }}
{{- end }}
{{- end -}}

{{- define "task.base.node.selector" -}}
{{- include "druid.node.selector" . }}
{{ toYaml .Values.task.base.node.selector }}
eks.amazonaws.com/nodegroup: {{ include "druid.name" . }}-druid-task-base-node
{{- end -}}

{{- define "task.base.volumes" -}}
{{- include "common.volumes" . }}
{{- with .Values.task.base.volumes }}
{{ . | toYaml }}
{{- end }}
{{- end -}}

{{- define "task.base.volume.mounts" -}}
{{- include "common.volumeMounts" . }}
{{- with .Values.task.base.volumeMounts }}
{{ . | toYaml }}
{{- end }}
{{- end -}}

{{- define "task.base.jvm" -}}
{{- if .Values.task.base.jvm }}
{{- printf "%s\n%s" (.Files.Get "common/jvm.config") .Values.task.base.jvm | toYaml }}
{{- else}}
{{- .Files.Get "common/jvm.config" | toYaml }}
{{- end }}
{{- end -}}
