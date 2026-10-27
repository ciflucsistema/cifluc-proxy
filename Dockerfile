# Proxy nginx do CIFLUC (Render Free) — encaminha para a VM GCP.
# O entrypoint oficial do nginx aplica envsubst nos templates usando APENAS
# variáveis definidas no ambiente ($host, $remote_addr etc. ficam intactas).
FROM nginx:1.27-alpine

COPY nginx.conf.template /etc/nginx/templates/default.conf.template

# Render: Docker runtime, porta 80 via $PORT, health check em /ping.
