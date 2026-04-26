# radar_chart_plus

A customizable radar (spider) chart widget for Flutter.  
This package helps you visualize multi-dimensional data in a clean, interactive radar chart.

---

## 🚀 Interactive Demo

Check out the live demo to explore all available chart features and configurations.

🔗 **Demo Website:** [View Chart Features Demo](https://sudharsan-005.github.io/radar_chart_demo/)

![screenshot](screenshots/multi_chart.jpg)


## Features

- 🎯 Draw radar (spider) charts with ease
- 🎨 Customizable chart colors, labels, and ticks
- 🔵 Optional dots at data points
- 📐 Responsive layout support
- ⚡ Lightweight and dependency-friendly

---

## Getting started
```dart
RadarChartPlus(
  ticks: [2, 4, 6],
  labels: ['AA', 'BB', 'CC'],
  dataSets: [
    RadarDataSet(
      data: [3, 2, 5],
      borderColor: Color(0xFF8072F3),
      fillColor: Color(0x668072F3),
      dotColor: Color(0xFF8072F3),
    ),
  ],
)
```

## 🛠️ Customization Options

`RadarChartPlus` offers a wide range of properties to customize the look and feel of your charts.

### 📊 Data & Structure
- **`labels`** `(List<String>)`: The labels for each axis.
- **`dataSets`** `(List<RadarDataSet>?)`: The data series to plot. Allows rendering multiple overlapping data sets.
- **`ticks`** `(List<double>?)`: Values for the concentric circles. Generated automatically if not provided.
- **`shape`** `(RadarChartShape)`: Shape of the background web (`circle` or `polygon`). Defaults to `circle`.

### 🎨 Styling
- **`ringsStyle`** `(RadarChartLineStyle)`: Customizes the inner concentric rings and spokes (color and stroke width).
- **`borderStyle`** `(RadarChartLineStyle)`: Customizes the outermost border (color and stroke width).

### 🏷️ Text & Labels
- **`labelTextStyle`** `(TextStyle?)`: Style for the axis labels.
- **`horizontalLabels`** `(bool)`: Draw all labels horizontally (quadrant-aware alignment) instead of rotating them.
- **`labelPadding`** `(double)`: Space reserved around the chart for horizontal labels.
- **`maxWordsPerLine`** `(int)`: Maximum number of words per line in labels to enable wrapping.
- **`labelTextAlign`** `(TextAlign)`: Alignment for multi-line labels.
- **`labelSpacing`** `(double)`: Gap between the spoke tip and the feature label.
- **`tickTextStyle`** `(TextStyle?)`: Style for the tick numbers.
- **`tickFractionDigits`** `(int)`: Number of fractional digits to show on tick numbers. Defaults to `0`.
- **`tickTextOffset`** `(Offset)`: Offset the tick numbers from their default position.

### 👆 Interaction & Tooltips
- **`dotTapEnabled`** `(bool)`: Enable tapping on data dots to show a tooltip. Defaults to `true`.
- **`tooltipStyle`** `(RadarTooltipStyle?)`: Visual style configuration for the interactive tooltip.
- **`customToolTipText`** `(String Function(String, double, String?)?)`: Optional callback to format the text inside the tooltip.


## Additional information

This package was created to offer a modern, customizable, and lightweight radar chart widget for Flutter applications. Ideal for dashboards, analytics, and performance visualization.
Feel free to contribute, report issues, or request new features on the GitHub repository.

## Contribution

Contributions are welcome! If you'd like to improve the package, follow these steps:

1. Fork the repository

2. Create a new branch for your feature or fix

3. Make your changes with clear commit messages

4. Submit a Pull Request describing what you changed and why

5. The PR will be reviewed and merged if everything looks good

## Contributors

<a href="https://github.com/VishnuB01/radar_chart_plus/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=VishnuB01/radar_chart_plus" />
</a>
