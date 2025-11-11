# Ochat 💬

A modern, lightweight web interface for [Ollama](https://ollama.ai) with a clean iOS-inspired design. Chat with local AI models directly in your browser with persistent chat history, web search integration, and vision model support.

![Ochat Interface](./screenshots/ochat-preview.png)

## ✨ Features

### Core Features
- 🎨 **Clean iOS-style Design** - Flat, minimalist interface with blue accent colors
- 💬 **Real-time Streaming** - Watch AI responses generate in real-time
- 💾 **Persistent Chat History** - All conversations saved locally in your browser
- 🌐 **Web Search Integration** - Search the web during conversations (DuckDuckGo, Wikipedia, Brave)
- 🖼️ **Vision Model Support** - Upload images for multimodal AI models
- 📱 **Fully Responsive** - Works seamlessly on desktop, tablet, and mobile
- 🌓 **Dark Mode** - Automatic dark/light mode based on system preferences

### Developer Features
- 🎯 **Code Syntax Highlighting** - Beautiful code blocks with copy functionality
- 🔍 **HTML Preview** - Live preview of HTML code in isolated iframe
- 📎 **File Attachments** - Upload images, documents, and more
- ⚙️ **Customizable Settings** - Adjust temperature, context length, and more
- 🔒 **Privacy First** - All data stored locally, no external servers

## 🚀 Quick Start

### Prerequisites
- [Ollama](https://ollama.ai) installed and running locally
- A modern web browser (Chrome, Firefox, Safari, Edge)

### Installation

1. **Clone the repository:**
   \`\`\`bash
   git clone https://github.com/yourusername/ochat.git
   cd ochat
   \`\`\`

2. **Open in browser:**
   Simply open \`ollama_chat.html\` in your web browser:
   \`\`\`bash
   # On macOS
   open ollama_chat.html

   # On Linux
   xdg-open ollama_chat.html

   # On Windows
   start ollama_chat.html
   \`\`\`

3. **Or serve with a local server:**
   \`\`\`bash
   # Python 3
   python -m http.server 8000

   # Node.js
   npx serve

   # PHP
   php -S localhost:8000
   \`\`\`

   Then open http://localhost:8000 in your browser.

### First Time Setup

1. Make sure Ollama is running:
   \`\`\`bash
   ollama serve
   \`\`\`

2. Pull a model (if you haven't already):
   \`\`\`bash
   ollama pull llama3.2
   \`\`\`

3. Open Ochat and select your model from the dropdown

## 📖 Usage

### Basic Chat
1. Select an Ollama model from the dropdown
2. Type your message in the input box
3. Press Enter or click the send button
4. Watch the AI respond in real-time

### Web Search
1. Click the 🔍 **Search** button to enable web search
2. Ask questions that require current information
3. The AI will search the web and use results in its response

### Image Analysis (Vision Models)
1. Click the 📎 **Attach** button
2. Select an image file
3. Ask questions about the image
4. Works with models like `llava` or `bakllava`

### HTML Preview
1. Ask the AI to generate HTML code
2. Click the **Preview** button next to **Copy**
3. See the live rendered HTML in an iframe

### Chat Management
- **New Chat**: Click the "+ New Chat" button
- **Load Chat**: Click any chat in the sidebar history
- **Delete Chat**: Hover over a chat and click the 🗑️ icon

## ⚙️ Configuration

Click the **⚙️ Settings** button to configure:

### Ollama Settings
- **Host URL**: Default `http://localhost:11434`
- **Temperature**: Controls randomness (0.0 - 2.0)
- **Context Length**: Maximum context window (512 - 32768)

### Search Settings
- **DuckDuckGo**: Free, no API key required
- **Wikipedia**: Free, no API key required
- **Brave Search**: Requires API key from [brave.com/search/api](https://brave.com/search/api)

## 🔧 Technical Details

### Architecture
- **Single HTML file** - No build process, no dependencies
- **Pure vanilla JavaScript** - No frameworks required
- **localStorage** - All data persists locally
- **Fetch API** - Real-time streaming from Ollama

### Browser Compatibility
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

### Security
- All data stored in browser localStorage
- No cookies or tracking
- HTML preview runs in isolated iframe sandbox
- No external API calls except for web search (optional)

## 📁 Project Structure

\`\`\`
ochat/
├── ollama_chat.html       # Main application (single file)
├── README.md              # This file
├── LICENSE                # MIT License
├── CHANGELOG.md           # Version history
└── screenshots/           # Screenshots for documentation
    └── ochat-preview.png
\`\`\`

## 🛠️ Development

### Local Development
No build process needed! Simply edit \`ollama_chat.html\` and refresh your browser.

### CORS Configuration
If you encounter CORS issues, ensure Ollama is configured to allow browser requests:

\`\`\`bash
# Set environment variable
export OLLAMA_ORIGINS="*"

# Or add to ollama service
OLLAMA_ORIGINS="http://localhost:*,http://127.0.0.1:*"
\`\`\`

### Customization
All styles are in the \`<style>\` tag at the top of the HTML file. Key CSS variables:

\`\`\`css
:root {
    --primary: #0066FF;        /* Primary blue color */
    --bg-primary: #FFFFFF;     /* Main background */
    --bg-secondary: #F7F7F8;   /* Secondary background */
    --text-primary: #0D0D0D;   /* Primary text */
    /* ... more variables */
}
\`\`\`

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (\`git checkout -b feature/AmazingFeature\`)
3. Commit your changes (\`git commit -m 'Add some AmazingFeature'\`)
4. Push to the branch (\`git push origin feature/AmazingFeature\`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Ollama](https://ollama.ai) - Amazing local AI platform
- [Marked.js](https://marked.js.org) - Markdown parsing
- [Highlight.js](https://highlightjs.org) - Code syntax highlighting
- Inspired by ChatGPT's clean interface design

## 🐛 Known Issues

- Web search may be limited by API rate limits
- Large images may take time to process with vision models
- Browser localStorage has ~5-10MB limit (affects chat history)

## 🗺️ Roadmap

- [ ] Export/Import chat history
- [ ] Custom themes and color schemes
- [ ] Multi-language support
- [ ] Voice input/output
- [ ] Model management (pull/delete models)
- [ ] Plugin system for extensions
- [ ] PWA support (offline mode)

## 📧 Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/ochat/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/ochat/discussions)

## ⭐ Star History

If you find Ochat useful, please consider giving it a star! ⭐

---

**Made with ❤️ for the Ollama community**
