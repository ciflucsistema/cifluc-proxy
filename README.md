# cifluc-proxy

Proxy nginx que publica o sistema CIFLUC em `https://ciflucsistema.onrender.com`
encaminhando o tráfego para a VM Google Cloud que roda o Next.js (SQLite local).

## Arquitetura

```
navegador ──HTTPS──> Render (nginx proxy, free) ──HTTP + header secreto──> GCP VM :80
```

- **Render Free**: 750h/mês neste workspace, dorme após 15 min sem tráfego
  (o workflow `keep-alive` pinge `/ping` a cada 10 min).
- **VM GCP**: única origem autorizada a servir o app; o nginx dela recusa (403)
  qualquer requisição externa que não venha com o header `X-Cifluc-Key`.

## Configuração (Render Dashboard)

| Env var | Valor |
|---|---|
| `PROXY_ORIGIN` | `http://<IP-da-VM>` |
| `PROXY_SECRET` | segredo compartilhado com o nginx da VM |

Nenhum segredo fica neste repositório (é público de propósito: o workflow de
keep-alive roda de graça ilimitado apenas em repos públicos).

## Segurança

- A VM tem `ufw` (22/80/443), `fail2ban` e exige o header secreto do proxy.
- O IP direto responde 403 para o mundo; só localhost e o proxy passam.
- Troca de segredo: atualizar `PROXY_SECRET` no Render + `/etc/nginx/snippets/`
  da VM e reiniciar nginx nos dois lados.
