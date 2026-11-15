# ✨ Perfect Win11 — Mocha Glass Rice

Готовый пресет кастомизации Windows 11 (24H2+): стеклянный таскбар-док, прозрачное меню «Пуск» и центр уведомлений в стиле **Mocha Glass**, тайлинг-менеджер **komorebi**, пакет обоев и курсоров.

> One-line English: a ready-made Windows 11 rice preset — glassy DockLike taskbar, translucent Mocha Glass Start menu & notification center, komorebi tiling, themed wallpapers & cursors.

## 🖼 Скриншоты

### Рабочий стол

<p align="center">
  <img src="img/hero-desktop.png" width="85%" alt="Рабочий стол с доком">
</p>

### Меню «Пуск» — прозрачное, с зонами без линий

<p align="center">
  <img src="img/start-menu.png" width="60%" alt="Меню «Пуск»">
</p>

### Центр уведомлений — Mocha Glass

<p align="center">
  <img src="img/notification-center.png" width="38%" alt="Центр уведомлений">
</p>

### Док и прозрачный трей

<p align="center">
  <img src="img/dock.png" width="46%" alt="Док">
  <img src="img/tray.png" width="46%" alt="Прозрачный трей">
</p>

### Проводник — жидкое стекло

<p align="center">
  <img src="img/explorer.png" width="85%" alt="Проводник со стеклянным фоном">
</p>

*Сквозь окно видно обои: окно, панель вкладок, адресная строка и список файлов — прозрачные, с блюром и тёмной тонировкой `#18181b` для читаемости.*

## Что внутри

```
222/
├── install-all.bat                # установка всего в один клик
├── explorer.bat                   # fln explorer tweaker (самоповышение + PowerShell)
├── win-tweaker.bat               # fln system tweaker
├── autounattend.xml              # автоматическая установка Windows с пресетом
├── wallpapers/                   # обои по темам: Everforest, Kanagawa, TokyoNight,
│                                 #   NordWin11, Win11GruvboxMaterial, Frieren и др.
├── cursors/                      # пакеты курсоров (dark/light, с Install.inf)
├── presets/                      # готовые настройки Windhawk-модов (.reg)
│   ├── taskbar-styler.reg              # DockLike-док, прозрачные часы, click-through
│   ├── start-menu-styler.reg           # прозрачное «Пуск» (TranslucentStartMenu + правки)
│   ├── notification-center-styler.reg  # Mocha Glass для центра уведомлений
│   ├── file-explorer-styler.reg        # проводник: Translucent Explorer11 (стекло)
│   ├── translucent-windows.reg         # блюр окна проводника (SystemBackdrop/Blur)
│   ├── assets/                         # PNG-логотип «Пуска» в Mocha (3 состояния)
│   └── taskbar-dock-animation.reg      # мягкие прыжки значков (macOS-стиль)
├── komorebi/                     # конфиги тайлинг-менеджера
│   ├── komorebi.json                   # раскладки, рамки Catppuccin Mocha
│   └── whkdrc                          # хоткеи (Alt + H/J/K/L и т.д.)
├── scripts/
│   ├── apply-windhawk-preset.ps1       # применить пресет одной командой
│   └── backup-windhawk.ps1             # бэкап текущих настроек перед применением
└── img/                          # скриншоты
```

## Требования

- Windows 11 **24H2** (build 26100) или новее
- [Windhawk](https://windhawk.net/) — движок модов
- Опционально: [komorebi](https://github.com/LGUG2Z/komorebi) + [whkd](https://github.com/LGUG2Z/whkd) — тайлинг окон
- Тема Windows: **тёмная** (персонализация → цвета)

## Установка

### 1. Windhawk-моды

В Windhawk → «Обзор» установи эти моды (просто установи, настройки перезапишутся пресетом):

| Мод | Автор |
|---|---|
| Windows 11 Taskbar Styler | m417z |
| Windows 11 Start Menu Styler | m417z |
| Windows 11 Notification Center Styler | m417z |
| Windows 11 File Explorer Styler | m417z |
| Translucent Windows | Undisputed00x |
| Taskbar Dock Animation | Ph0en1x-dev |

### 2. Применить пресет — автоматически (рекомендуется)

Запусти `install-all.bat` от имени администратора — он:
1. Установит Windhawk, komorebi и whkd через winget
2. Разложит конфиги komorebi
3. Подскажет, какие 6 модов доустановить в Windhawk (ссылки откроются сами)
4. Импортирует все пресеты и перезапустит оболочку
5. Создаст автозапуск komorebi

Ручной способ:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\backup-windhawk.ps1   # бэкап текущих настроек
powershell -ExecutionPolicy Bypass -File .\scripts\apply-windhawk-preset.ps1
```

Скрипт импортирует `.reg`-пресеты и перезапустит проводник с хостами меню/уведомлений.

### 3. Komorebi (опционально)

```powershell
Copy-Item .\komorebi\komorebi.json $env:USERPROFILE\komorebi.json
New-Item -ItemType Directory -Force "$env:USERPROFILE\.config" | Out-Null
Copy-Item .\komorebi\whkdrc $env:USERPROFILE\.config\whkdrc
komorebic start --whkd
```

Автозапуск: ярлык `komorebic-no-console.exe start --whkd` в `shell:startup`.

## Что даёт пресет

- **Таскбар-док**: плавающая центральная панель, стекло с блюром, прозрачные часы, сквозные клики по пустым местам (`clickThroughTaskbar`), углы 8–12 px
- **Кнопка «Пуск» в Mocha**: логотип Windows заменён на четыре квадрата `#89b4fa` — в тон индикаторам, три состояния (обычное, наведение со стеклянной плашкой, открытое меню с мягкой Mocha-подсветкой)
- **Состояния иконок дока**: у активной программы — стеклянная плашка `#1FFFFFFF` (12% белого), у наведения и нажатия свои оттенки, индикатор запуска — линия 14×3 px цветом `#89b4fa` (у активной ярче, у фоновых — 40%)
- **Воздух между зонами**: 6 px после «Пуска», трей отделён от дока пустотой — зоны разделены пустым местом, без линий и рамок
- **Меню «Пуск»**: прозрачный акрил, разделение зон (поиск / закреплено / все / профиль) пустым местом без линий, скругления 12 px
- **Центр уведомлений «Mocha Glass»**: жидкое стекло на всех панелях (блюр 30, тонировка 40%), скругления 18 px, акцент `#89b4fa` (Catppuccin Mocha), скруглённая обложка медиаплеера
- **Проводник — жидкое стекло**: тема **Translucent Explorer11** (File Explorer Styler) делает панели и список файлов прозрачными, а **Translucent Windows** добавляет реальный блюр окна (AccentBlurBehind) с тёмной тонировкой `#18181b` (30%) — сквозь проводник видно обои, текст остаётся читаемым
- **Анимации дока**: мягкое масштабирование 115% с лёгким прыжком, системные кнопки не анимируются
- **Komorebi**: BSP-тайлинг с рамками Mocha и хоткеями

## Заметка по кнопке «Пуск»

Логотип «Пуска» — это PNG из `presets/assets/` (`start-normal.png`, `start-hover.png`, `start-active.png`), а пресет ссылается на них по прямым ссылкам на этот репозиторий. Поэтому:

- нужен интернет при загрузке картинок (Windhawk кэширует их после первого показа);
- хочешь другой оттенок — перекрась PNG в `presets/assets/` (64×64, логотип 32×32 по центру) и обнови пресет;
- если сменишь ник/имя репозитория — поправь URL в `taskbar-styler.reg` (`controlStyles[43]`).

Стандартный логотип скрывается стилем `controlStyles[44]` (`Opacity=0`), поэтому картинка и системный значок не накладываются друг на друга.

## Заметка по проводнику

Стекло в проводнике собирают **два мода вместе**: File Explorer Styler (тема `Translucent Explorer11`) делает XAML-часть прозрачной, а Translucent Windows даёт сам блюр окна.

Если проводник стал глухим:

- В настройках File Explorer Styler **не должно быть** параметра `backgroundTranslucentEffectRegion` — пустое значение делает окно непрозрачным.
- Оба мода должны быть включены; после смены настроек перезапусти проводник (`taskkill /f /im explorer.exe` → `explorer.exe`).
- Прозрачность видно только над светлым/цветным: над чёрными обоями стекло выглядит тёмным — это нормально.
- Тема `LiquidGlass` (и `OS26 Liquid Glass`) в этой сборке не применяется — окно становится полностью прозрачным, без стекла и оформления. Рабочая связка — `Translucent Explorer11` + `acrylicblur`.

## Заметка по трею

Трей — это стандартные иконки Windows с прозрачным фоном (`Background=Transparent` на `SystemTrayFrameGrid`), без собственных отступов и рамок.

Если часы и дата обрезаны сверху:

- уберите стиль, который вешает на `SystemTrayFrameGrid` «невидимую рамку» — `CornerRadius` + `BorderThickness=12` + отрицательные `Margin`. Эта рамка подрезает текст часов;
- не добавляйте трею левый `Margin` — из-за него значок уведомлений уезжает за край экрана.

`controlStyles` в пресете нумеруются подряд: если удалить стиль из середины, всё, что идёт после него, перестаёт применяться — индексы нужно сдвинуть вверх (`[49]` → `[48]` и так далее).

## Структура настроек

Пресеты лежат в `HKLM\SOFTWARE\Windhawk\Engine\Mods\<id мода>\Settings` — формат `controlStyles[N].target` / `controlStyles[N].styles[N]`, константы в виде `ИМЯ = значение`. Правятся прямо в реестре или через UI мода.

## Лицензия

MIT. Моды Windhawk — их авторы (m417z, Ph0en1x-dev), komorebi — LGUG2Z.
