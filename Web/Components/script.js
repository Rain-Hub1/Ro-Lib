const pagesConfig = {};

let currentPage = '';
let pagesList = [];

function init() {
    Object.keys(pagesConfig).forEach(filename => {
        window.mdxParser.registerPage(filename, pagesConfig[filename]);
    });

    pagesList = window.mdxParser.getAllPages();

    if (pagesList.length > 0) {
        currentPage = pagesList[0].filename;
    }

    renderNav();

    if (currentPage) {
        loadPage(currentPage);
    }

    setupEventListeners();
}

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

function getPageEmoji(filename) {
    return '📄';
}

function loadPage(filename) {
    const page = window.mdxParser.getPage(filename);
    
    if (!page) {
        console.error('Página não encontrada:', filename);
        return;
    }

    document.getElementById('pageTitle').textContent = `${page.title} - Roblox UI Library`;
    document.getElementById('pageTitleMain').textContent = page.title;
    document.getElementById('pageDesc').textContent = page.desc;

    document.getElementById('pageContent').innerHTML = page.content;

    document.querySelectorAll('.nav-link').forEach(link => {
        link.classList.remove('active');
        if (link.dataset.page === filename) {
            link.classList.add('active');
        }
    });

    currentPage = filename;

    updatePageNavigation();

    if (window.innerWidth < 1024) {
        document.getElementById('sidebar').classList.add('mobile-hidden');
        document.getElementById('overlay').classList.remove('active');
    }

    window.scrollTo(0, 0);
}

function updatePageNavigation() {
    const currentIndex = pagesList.findIndex(p => p.filename === currentPage);
    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');

    if (currentIndex > 0) {
        prevBtn.style.visibility = 'visible';
        prevBtn.onclick = () => loadPage(pagesList[currentIndex - 1].filename);
    } else {
        prevBtn.style.visibility = 'hidden';
    }

    if (currentIndex < pagesList.length - 1) {
        nextBtn.style.visibility = 'visible';
        nextBtn.onclick = () => loadPage(pagesList[currentIndex + 1].filename);
    } else {
        nextBtn.style.visibility = 'hidden';
    }
}

function setupEventListeners() {
    const menuBtn = document.getElementById('menuBtn');
    const sidebar = document.getElementById('sidebar');
    const overlay = document.getElementById('overlay');

    menuBtn.addEventListener('click', () => {
        sidebar.classList.toggle('mobile-hidden');
        overlay.classList.toggle('active');
    });

    overlay.addEventListener('click', () => {
        sidebar.classList.add('mobile-hidden');
        overlay.classList.remove('active');
    });
}

if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
} else {
    init();
}
