{{/* vim: set filetype=mustache: */}}

{{- define "druid.name" -}}
{{ .Values.hostedId }}-{{ .Release.Name }}
{{- end -}}

{{- define "druid.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "common.labels" -}}
{{- range $k, $v := .Values.labels }}
{{ $k | quote }}: {{ $v | quote }}
{{- end }}
{{- end -}}

{{- define "common.annotations" -}}
{{- range $k, $v := .Values.annotations }}
{{ $k | quote }}: {{ $v | quote }}
{{- end }}
{{- end -}}

{{- define "common.volumes" -}}
{{- with .Values.volumes }}
{{- . | toYaml }}
{{- end }}
{{- end -}}

{{- define "common.volumeMounts" -}}
{{- with .Values.volumeMounts }}
{{- . | toYaml }}
{{- end }}
{{- end -}}

{{- define "common.security" -}}
automountServiceAccountToken: true
serviceAccountName: {{ include "druid.name" . }}-druid-sa
securityContext:
{{- toYaml .Values.securityContext | nindent 2 }}
{{- end -}}

{{- define "common.env" -}}
{{- with .Values.env }}
{{- . | toYaml }}
{{- end }}
{{- end -}}

{{- define "druid.image" -}}
image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
imagePullPolicy: {{ .Values.image.pullPolicy }}
{{- end -}}

{{- define "druid.node.selector" -}}
kubernetes.io/arch: amd64
kubernetes.io/os: linux
karpenter.sh/capacity-type: on-demand
{{- end -}}

{{- define "druid.node.labels" -}}
{{ .Values.domain }}/category: analytics
{{ .Values.domain }}/type: node
{{ .Values.domain }}/part-of: druid
{{- end -}}

{{- define "druid.node.requirements" -}}
- key: "kubernetes.io/arch"
  operator: In
  values: [ "amd64" ]
- key: "kubernetes.io/os"
  operator: In
  values: [ "linux" ]
- key: "karpenter.sh/capacity-type"
  operator: In
  values: [ "on-demand" ]
{{- end -}}
