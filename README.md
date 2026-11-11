# MN Tech Cell — Estoque & Finanças

Aplicação web responsiva para operação de balcão e gestão de estoque da **MN Tech Cell — A Solução para o Seu Celular**.

## Funcionalidades

- Cadastro e edição de produtos, categorias, SKU e código de barras.
- Leitura de códigos pela câmera traseira (HTTPS obrigatório e permissão de câmera).
- Busca por produto/código e movimentação rápida de entrada e saída.
- Bloqueio de baixa acima do saldo disponível.
- Dashboard com custo do estoque, potencial de venda, margem, alertas e giro.
- Relatórios de vendas, lucro realizado e produtos parados.
- Tema claro/escuro e navegação adaptada para celular.
- Salvamento local no navegador e sincronização Supabase quando configurada.
- Estrutura PWA com cache do app para abertura offline; leitura pela câmera e sincronização exigem conexão/serviços disponíveis.

## Publicação

O app é estático: `index.html` é o ponto de entrada. Pode ser servido pelo GitHub Pages ou por hospedagem estática com HTTPS.

## Configuração do Supabase

1. Crie um projeto Supabase.
2. Abra `supabase/schema.sql` no SQL Editor e execute o script.
3. No `index.html`, substitua `https://SEU-PROJETO.supabase.co` pela URL do projeto e `SUA_CHAVE_ANON_PUBLICA` pela chave `anon`/publishable.
4. Em Authentication > Users, crie os usuários autorizados da equipe (e-mail e senha). O aplicativo não oferece cadastro público.
5. Nunca coloque a chave `service_role` no navegador; use somente a chave pública `anon`/publishable.
6. O SQL ativa RLS e permite operações somente para usuários autenticados. Não remova essas políticas nem habilite acesso anônimo.

## Observações

- A primeira abertura sem dados na nuvem inicia com dados demonstrativos. Apague/substitua os itens de demonstração antes de operar o estoque real.
- O navegador mantém uma cópia local. Para evitar conflito, use uma sessão/dispositivo por vez até implementar sincronização transacional multiusuário.
- O scanner usa a biblioteca `html5-qrcode` carregada por CDN; a primeira carga dessa biblioteca exige internet.