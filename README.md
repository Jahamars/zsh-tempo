# Tempo
> Minimalist time progress tracker for Zsh

Tempo provides a clean, visual representation of time passing. It integrates seamlessly into your terminal, helping you keep track of progress through the day, week, month, and year.

## Features
- **Visual Clarity**: Elegant progress bars using Unicode block characters.
- **Dynamic Colors**: Optional color-coding based on completion percentage.
- **Smart Loading**: Asynchronous initialization to ensure configuration is always respected.
- **Zero Configuration**: Works out of the box with sensible defaults.

## Installation

### Manual
1. Clone this repository:
   ```bash
   git clone https://github.com/Jahamars/tempo.git ~/tempo
   ```
2. Source the plugin in your `.zshrc`:
   ```zsh
   source ~/tempo/tempo.plugin.zsh
   ```

### Oh My Zsh
1. Clone into your custom plugins directory:
   ```bash
   git clone https://github.com/Jahamars/tempo.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/tempo
   ```
2. Add `tempo` to your `plugins` array in `.zshrc`.

## Configuration
Customize Tempo by setting these variables in your `.zshrc`. The plugin picks up changes automatically.

| Variable | Default | Description |
| :--- | :--- | :--- |
| `TEMPO_AUTO_SHOW` | `true` | Show progress bars on shell startup |
| `TEMPO_SHOW_ITEMS` | `day week month year` | List of items to display |
| `TEMPO_WIDTH` | `40` | Total width of the progress bar |
| `TEMPO_FILLED_CHAR` | `█` | Character for the filled portion |
| `TEMPO_EMPTY_CHAR` | `░` | Character for the empty portion |
| `TEMPO_COLOR_STYLE` | `true` | Enable progress-based coloring |

### Example
```zsh
TEMPO_WIDTH=50
TEMPO_SHOW_ITEMS="day week"
TEMPO_FILLED_CHAR="#"
TEMPO_EMPTY_CHAR="."
```

## Usage
Run the `tempo` command manually at any time.

```bash
tempo           # Show default items
tempo --day     # Show only today's progress
tempo --config  # View current settings
tempo --help    # Show all options
```

## License
MIT
