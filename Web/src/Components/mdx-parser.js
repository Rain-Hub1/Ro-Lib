class MDXParser {
    constructor() {
        this.pages = {};
    }

    parseFrontmatter(content) {
        const frontmatterRegex = /^---\s*\n([\s\S]*?)\n---\s*\n/;
        const match = content.match(frontmatterRegex);
        
        if (!match) {
            return { frontmatter: {}, content: content };
        }

        const frontmatterText = match[1];
        const remainingContent = content.slice(match[0].length);
        
        const frontmatter = {};
        const lines = frontmatterText.split('\n');
        
        lines.forEach(line => {
            const colonIndex = line.indexOf(':');
            if (colonIndex > -1) {
                const key = line.slice(0, colonIndex).trim();
                const value = line.slice(colonIndex + 1).trim();
                frontmatter[key] = value;
            }
        });

        return { frontmatter, content: remainingContent };
    }

    escapeHtml(text) {
        const map = {
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            '"': '&quot;',
            "'": '&#039;'
        };
        return text.replace(/[&<>"']/g, m => map[m]);
    }

    parseMarkdown(markdown) {
        let html = markdown;

        html = html.replace(/```(\w+)?\n([\s\S]*?)```/g, (match, language, code) => {
            const lang = language || 'text';
            const escapedCode = this.escapeHtml(code.trim());
            return `<pre data-language="${lang}"><code>${escapedCode}</code></pre>`;
        });

        html = html.replace(/`([^`]+)`/g, '<code>$1</code>');

        html = html.replace(/^### (.*$)/gim, '<h3>$1</h3>');
        html = html.replace(/^## (.*$)/gim, '<h2>$1</h2>');
        html = html.replace(/^# (.*$)/gim, '<h1>$1</h1>');

        html = html.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
        html = html.replace(/\*(.*?)\*/g, '<em>$1</em>');

        html = html.replace(/\[([^\]]+)\]\(([^\)]+)\)/g, '<a href="$2">$1</a>');

        html = html.replace(/^\* (.*$)/gim, '<li>$1</li>');
        html = html.replace(/(<li>.*<\/li>)/s, '<ul>$1</ul>');

        html = html.replace(/^\d+\. (.*$)/gim, '<li>$1</li>');

        html = html.split('\n\n').map(para => {
            if (para.startsWith('<h') || para.startsWith('<pre') || 
                para.startsWith('<ul') || para.startsWith('<ol') ||
                para.trim() === '') {
                return para;
            }
            return `<p>${para}</p>`;
        }).join('\n');

        return html;
    }

    registerPage(filename, content) {
        const { frontmatter, content: markdownContent } = this.parseFrontmatter(content);
        const htmlContent = this.parseMarkdown(markdownContent);
        
        this.pages[filename] = {
            title: frontmatter.title || 'Sem título',
            desc: frontmatter.desc || '',
            content: htmlContent,
            filename: filename
        };
    }

    getPage(filename) {
        return this.pages[filename];
    }

    getAllPages() {
        return Object.keys(this.pages).map(key => ({
            filename: key,
            title: this.pages[key].title,
            desc: this.pages[key].desc
        }));
    }
}

window.mdxParser = new MDXParser();