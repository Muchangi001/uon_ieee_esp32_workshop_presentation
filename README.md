# Embedded Systems with Rust ESP-HAL Presentation

A beautiful, responsive Flutter presentation for an ESP32 Rust workshop, featuring a Rustacean theme with smooth animations and interactive elements.

![Presentation Screenshot](https://via.placeholder.com/800x450/1E1F23/FFFFFF?text=ESP32+Rust+Workshop)

## Features

- 🦀 **Rustacean Theme**: Beautiful dark theme with rust colors (brown, orange)
- 📱 **Fully Responsive**: Adapts to different screen sizes with optimized layouts
- 🎨 **Smooth Animations**: Fade transitions between slides and interactive elements
- ⚡ **Interactive Demos**: Bitwise operations demo with visual feedback
- 📊 **Clean Visuals**: Professional code blocks with FiraCode font
- 🔧 **ESP32-C6 Focus**: Detailed information about ESP32-C6 capabilities
- 🚫 **No Overflows**: All content properly contained with scrolling where needed

## Slides Included

1. **Title Slide** - Introduction with Rust branding
2. **What Are Embedded Systems** - Definition and examples
3. **Hardware Concepts** - GPIO & registers explanation
4. **Bitwise Operations** - Interactive demo with visual register
5. **ESP32-C6 vs WROOM32** - Comparison of ESP32 variants
6. **GPIO Pinout & Safe Pins** - Pin configuration guidelines
7. **Rust ESP-HAL Projects** - Project ideas and benefits
8. **Session Plan** - Workshop timeline and activities
9. **Peripherals & Drivers** - Built-in hardware capabilities
10. **Driver Implementation** - Rust code examples
11. **Setup vs Loop Functions** - Arduino vs Rust comparison

## Getting Started

### Prerequisites

- Flutter SDK (version 2.0 or higher)
- Dart (version 2.12 or higher)

### Installation

1. Clone the repository:
```bash
git clone uon_ieee_esp32_workshop_presentation
cd uon_ieee_esp32_workshop_presentation
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the application:
```bash
flutter run
```

### For Web Deployment

```bash
flutter build web
flutter run -d chrome
```

## Customization

### Colors
The presentation uses a custom Rust-themed color palette:
- Primary: `#BC8C61` (Rust brown)
- Accent: `#E38C2D` (Rust orange)
- Background: `#1E1F23` (Dark gray)
- Card Background: `#2D2E32` (Lighter gray)

### Fonts
- Primary: FiraCode (for code blocks)
- Fallback: Roboto (for general text)

### Adding New Slides
1. Create a new slide method following the naming convention `_buildSlideName()`
2. Add the slide to the PageView children list in the build method
3. Update the `totalSlides` variable

## Technical Details

### Responsive Design
The presentation uses `LayoutBuilder` to adapt content based on screen width:
- Desktop: Side-by-side layouts with expanded content
- Mobile: Stacked layouts with appropriate spacing

### Animation System
- Fade transitions between slides
- Interactive animations for the bitwise demo
- Smooth page transitions

### Interactive Elements
- Bitwise operation demo with toggleable bits
- Navigation controls with slide indicators
- Responsive touch targets for mobile devices

## ESP32-C6 Information

The presentation includes detailed information about:
- ESP32-C6 peripherals and capabilities
- GPIO pin configurations and safe usage
- Rust ESP-HAL driver implementation
- Comparison with ESP32 WROOM32

## License

This project is created for educational purposes as part of IEEE University of Nairobi workshops.

## Contributing

Feel free to fork this project and adapt it for your own workshops or presentations. If you make improvements, consider submitting a pull request.

## Acknowledgments

- IEEE University of Nairobi for the workshop initiative
- ESP-RS community for Rust on ESP32 resources
- Flutter team for the excellent framework