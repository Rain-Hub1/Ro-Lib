const pagesConfig = {
    'Test.mdx': `---
title: Test Page
desc: Esta é uma página de teste para a documentação.
---

# Test

Esta é uma página de teste.

## Exemplo de Código

\`\`\`lua
-- Teste de código
local function teste()
    print("Hello World")
end
\`\`\`

## Lista de Itens

* Item 1
* Item 2
* Item 3

**Negrito** e *itálico* funcionam!`,

    'Hi.mdx': `---
title: Hi Page
desc: Página de boas-vindas da documentação.
---

# Hi!

Bem-vindo à documentação da **Roblox UI Library**.

## O que você encontrará aqui

* Componentes completos
* Exemplos práticos
* Guias de uso

\`\`\`lua
-- Exemplo de uso
local UI = require(game.ReplicatedStorage.UILibrary)
\`\`\``,

    'WindowLoad.mdx': `---
title: Window and Load
desc: Todas as funções do window e load.
---

# Load

O sistema de carregamento permite inicializar componentes.

\`\`\`lua
-- Exemplo de Load
local UI = require(game.ReplicatedStorage.UILibrary)

UI.Load({
    name = "MainWindow",
    parent = game.Players.LocalPlayer.PlayerGui
})
\`\`\`

## Window

Crie janelas customizadas:

\`\`\`lua
-- Criar window
local window = UI.Window({
    title = "Minha Janela",
    size = UDim2.new(0, 400, 0, 300)
})
\`\`\`

### Propriedades

* **title**: Título da janela
* **size**: Tamanho em UDim2
* **position**: Posição na tela`
};

// Estado da aplicação
let currentPage = 'Test.mdx';
let pagesList = [];

// Inicialização
function init() {
    // Registrar todas as páginas no parser
    Object.keys(pagesConfig).forEach(filename => {
        window.mdxParser.registerPage(filename, pagesConfig[filename]);
    });

    // Obter lista de páginas
    pagesList = window.mdxParser.getAllPages();

    // Renderizar navegação
    renderNav();

    // Carregar primeira página
    loadPage(currentPage);

    // Event listeners
    setupEventListeners();
}

// Renderizar navegação lateral
function renderNav() {
    const navLinks = document.getElementById('navLinks');
    navLinks.innerHTML = '';

    pagesList.forEach(page => {
        const link = document.createElement('a');
        link.href = '#';
        link.className = 'nav-link';
        link.dataset.page = page.filename;
        
        if (page.filename === currentPage) {
            link.classList.add('active');
        }

        const emoji = getPageEmoji(page.filename);
        link.innerHTML = `<span>${emoji}</span><span>${page.title}</span>`;
        
        link.addEventListener('click', (e) => {
            e.preventDefault();
            loadPage(page.filename);
        });

        navLinks.appendChild(link);
    });
}

// Obter emoji para página
function getPageEmoji(filename) {
    const emojiMap = {
        'Test.mdx': '🧪',
        'Hi.mdx': '👋',
        'WindowLoad.mdx': '🪟'
    };
    return emojiMap[filename] || '📄';
}

// Carregar página
function loadPage(filename) {
    const page = window.mdxParser.getPage(filename);
    
    if (!page) {
        console.error('Página não encontrada:', filename);
        return;
    }

    // Atualizar título da página
    document.getElementById('pageTitle').textContent = `${page.title} - Roblox UI Library`;
    document.getElementById('pageTitleMain').textContent = page.title;
    document.getElementById('pageDesc').textContent = page.desc;

    // Renderizar conteúdo
    document.getElementById('pageContent').innerHTML = page.content;

    // Atualizar navegação ativa
    document.querySelectorAll('.nav-link').forEach(link => {
        link.classList.remove('active');
        if (link.dataset.page === filename) {
            link.classList.add('active');
        }
    });

    // Atualizar página atual
    currentPage = filename;

    // Atualizar botões de navegação
    updatePageNavigation();

    // Fechar sidebar no mobile
    if (window.innerWidth < 1024) {
        document.getElementById('sidebar').classList.add('mobile-hidden');
        document.getElementById('overlay').classList.remove('active');
    }

    // Scroll para o topo
    window.scrollTo(0, 0);
}

// Atualizar navegação entre páginas
function updatePageNavigation() {
    const currentIndex = pagesList.findIndex(p => p.filename === currentPage);
    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');

    // Botão anterior
    if (currentIndex > 0) {
        prevBtn.style.visibility = 'visible';
        prevBtn.onclick = () => loadPage(pagesList[currentIndex - 1].filename);
    } else {
        prevBtn.style.visibility = 'hidden';
    }

    // Próximo botão
    if (currentIndex < pagesList.length - 1) {
        nextBtn.style.visibility = 'visible';
        nextBtn.onclick = () => loadPage(pagesList[currentIndex + 1].filename);
    } else {
        nextBtn.style.visibility = 'hidden';
    }
}

// Setup event listeners
function setupEventListeners() {
    const menuBtn = document.getElementById('menuBtn');
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('overlay');

    // Toggle menu mobile
    menuBtn.addEventListener('click', () => {
        sidebar.classList.toggle('mobile-hidden');
        overlay.classList.toggle('active');
    });

    // Fechar ao clicar no overlay
    overlay.addEventListener('click', () => {
        sidebar.classList.add('mobile-hidden');
        overlay.classList.remove('active');
    });
}

// Iniciar quando o DOM estiver pronto
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}
