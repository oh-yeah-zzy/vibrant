# Vibrant Theme for Oh My Zsh

> 🇨🇳 [中文版本](vibrant-theme-README.md) | 🇺🇸 English

A colorful and modern terminal theme with bright colors that brings life to your command line interface.

## Features

- 🌈 **Bright and vibrant colors** for enhanced visibility
- 🔗 **Git status integration** with visual indicators
- 🐍 **Conda environment display** with custom styling
- 🚀 **Clean and minimal design** without username/hostname clutter
- 🎯 **Detached HEAD support** with commit hash display
- ⚡ **Fast and lightweight** performance

## Visual Elements

### Git Status Indicators
- **Clean repository**: Branch name in bright green
- **Uncommitted changes**: Red asterisk (`*`) 
- **Staged changes**: Yellow plus (`+`)
- **Detached HEAD**: Shows commit hash with bright blue highlighting

### Conda Environment
- **Active environment**: Displayed in bright red brackets
- **Base environment**: Shown in slightly dimmer red
- **No environment**: Hidden when not in conda environment

### Color Scheme
- **Directory path**: Bright cyan
- **Prompt symbol**: Bright green arrow (`❯`)
- **Git branch**: Bright green (normal) / Bright blue (detached)
- **Git brackets**: Bright purple
- **Conda environment**: Bright red

## Installation

### Prerequisites
- [Oh My Zsh](https://ohmyz.sh/) installed
- A terminal that supports 256 colors

### Manual Installation

1. Download the theme file:
```bash
curl -o ~/.oh-my-zsh/themes/vibrant.zsh-theme https://raw.githubusercontent.com/your-username/vibrant/main/vibrant.zsh-theme
```

2. Set the theme in your `~/.zshrc`:
```bash
ZSH_THEME="vibrant"
```

3. Reload your shell:
```bash
source ~/.zshrc
```

### Alternative Installation

1. Clone this repository:
```bash
git clone https://github.com/your-username/vibrant.git
cd vibrant
```

2. Copy the theme to your Oh My Zsh themes directory:
```bash
cp vibrant.zsh-theme ~/.oh-my-zsh/themes/
```

3. Update your `~/.zshrc` and reload:
```bash
echo 'ZSH_THEME="vibrant"' >> ~/.zshrc
source ~/.zshrc
```

## Configuration

The theme works out of the box with no additional configuration required. However, you can customize the behavior:

### Conda Integration
The theme automatically detects and displays conda environments. If you prefer conda's default prompt, you can disable the custom conda display by setting:
```bash
export CONDA_CHANGEPS1=true
```

## Compatibility

- **Oh My Zsh**: All versions
- **Zsh**: 5.0+
- **Terminal**: Any terminal with 256-color support
- **Git**: Any recent version
- **Conda**: Optional, auto-detected when available

## Screenshots

```
(myenv) ~/projects/awesome-project (main) 
❯ 

(base) ~/projects/awesome-project (detached:a1b2c3d) *
❯ 

~/projects/awesome-project (feature-branch) +
❯ 
```

## Troubleshooting

### Colors not displaying correctly
Ensure your terminal supports 256 colors. Test with:
```bash
curl -s https://gist.githubusercontent.com/HaleTom/89ffe32783f89f403bba96bd7bcd1263/raw/ | bash
```

### Git status not showing
Make sure you're in a git repository and git is properly installed:
```bash
git --version
git status
```

### Conda environment not displaying
Verify conda is activated and `CONDA_DEFAULT_ENV` is set:
```bash
echo $CONDA_DEFAULT_ENV
```

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

## License

This theme is released under the MIT License. See LICENSE file for details.

## Author

**zzy** - Version 1.0

---

*Enjoy your vibrant terminal experience!* 🎨