{{- define "backend-base" }}
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: phonebook
  name: {{ .name}} 
  labels:
  {{- range $k, $v := .labels }}
    {{ $k }}: {{ $v }}
  {{- end }}
spec:
  replicas: {{default 1 .replicas}}
  selector:
    matchLabels:
    {{- range $k, $v := .labels }}
      {{ $k }}: {{ $v }}
    {{- end }}
  template:
    metadata:
      labels:
      {{- range $k, $v := .labels }}
        {{ $k }}: {{ $v }}
      {{- end }}
    spec:
      containers:
        - image: {{ .image }}:{{ .tag }}
          name: {{ .container_name }}
          workingDir: /app
          env:
            {{- range $k, $v := .env}}
            - name: {{ $k }}
              value: {{ $v }}
            {{- end }}
          envFrom:
            - secretRef:
                name: {{.config_name}}
          command: 
            {{ range .command }}
            - {{ . | quote }}
            {{- end }}
          args: 
            {{- range .args}}
            - {{. | quote}}
            {{- end }}
{{- end}}