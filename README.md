# ControlAddins In BC

![AL](https://img.shields.io/badge/AL-Language-blue) ![JavaScript](https://img.shields.io/badge/JavaScript-ES6-yellow) ![Business Central](https://img.shields.io/badge/Business%20Central-BC20-orange) ![License](https://img.shields.io/badge/License-MIT-green)

A collection of JavaScript control add-ins for Microsoft Dynamics 365 Business
Central, built for learning and demo purposes. Each add-in is wired into a
standard BC page to show a complete, working example.

## Add-ins

| Add-in | Where it shows up | What it does |
|---|---|---|
| **Bar Graph** | Customer Card | Bar chart of the customer's quotes/orders/invoices |
| **Carousel** | Customer List | Bootstrap image carousel |
| **CKEditor Notes** | Customer List / Customer Card | Rich text editor for customer notes |
| **Countries Chart** | Items by Countries | Geo chart of items sold by country |
| **Drag and Drop** *(experimental)* | Item List | Drop JSON files to bulk-create items |
| **Pie Chart** | Sales Order List | Pie chart of open vs. released sales orders |
| **Screen Recorder** | Screen Recorder page | Record the screen and download the video |

See [docs/PROJECT_TAGS.md](docs/PROJECT_TAGS.md) for a feature-by-feature
breakdown and the `//JOA00X` comment tags used to locate each one in the code.

## Project structure

```
src/
├── addins/        # One folder per control add-in (controladdin + scripts + AL objects)
├── extensions/     # Page/table extensions to standard BC objects
├── shared/         # Script(s) shared by every control add-in
└── test/           # Scratch/demo pages, not part of the actual add-ins
```

All custom AL objects use the `SCR` prefix and live in the `50100`-`50199`
ID range.

## Requirements

- Business Central (AL development environment)
- AL Language extension for VS Code

## Getting started

1. Open this folder in VS Code with the AL Language extension installed.
2. Download symbols for your target environment (`AL: Download Symbols`).
3. Create your own `.vscode/launch.json` (see AL Language docs) — it's
   intentionally not committed since it's specific to each developer's
   sandbox/server.
4. Publish (`F5`).

## License

MIT — see [LICENSE](LICENSE).
