# Roblox UI Library - Documentação

Documentação completa da UI Library para Roblox hospedada no GitHub Pages.

## Estrutura do Projeto

```
roblox-ui-docs/
├── README.md
└── src/
    ├── Components/
    │   ├── index.html
    │   ├── styles.css
    │   ├── script.js
    │   └── mdx-parser.js
    └── Pages/
        └── (seus arquivos .mdx aqui)
```

## Como Adicionar Páginas

1. Crie um arquivo `.mdx` em `src/Pages/`

```markdown
---
title: Título da Página
desc: Descrição da página.
---

# Conteúdo

Seu conteúdo aqui...
```

2. Registre no `script.js` no objeto `pagesConfig`:

```javascript
const pagesConfig = {
    'SuaPagina.mdx': `---
title: Sua Página
desc: Descrição aqui
---

# Conteúdo
`
};
```

## Formato MDX Suportado

### Frontmatter
```yaml
---
title: Título
desc: Descrição
---
```

### Markdown

- Headers: `# H1`, `## H2`, `### H3`
- Negrito: `**texto**`
- Itálico: `*texto*`
- Code inline: `` `código` ``
- Code blocks: ` ```lua ` 
- Listas: `* item`
- Links: `[texto](url)`

## Deploy no GitHub Pages

1. Push para o GitHub
2. Settings > Pages
3. Branch `main` > pasta `/src/Components`
4. Salve

## Licença

MIT License