# Tempo
> A minimalist time progress tracker for your shell

```
Day    : [############################......................] 57%                             
Week   : [##################................................] 36%
Month  : [######............................................] 12%
Year   : [####..............................................] 9%
```

## Installation

### Manual
   ```bash
   git clone https://github.com/Jahamars/tempo.git ~/tempo
   source ~/tempo/tempo.plugin.zsh
   ```

### Oh My Zsh
1. Clone into your plugins directory
   ```bash
   git clone https://github.com/Jahamars/tempo.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/tempo
   ```
2. Add `tempo` to your `plugins` array in `.zshrc`
 ```zsh
 plugins=(... tempo)
 ```

## Configuration
Customize Tempo by setting these variables in your `.zshrc`

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
Run the `tempo` command manually at any time

```bash
tempo           # Show default items
tempo --day     # Show only today's progress
tempo --config  # View current settings
tempo --help    # Show all options
```
