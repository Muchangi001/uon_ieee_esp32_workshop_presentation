import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(EmbeddedSystemsPresentation());
}

class EmbeddedSystemsPresentation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32 Workshop - IEEE UoN',
      theme: ThemeData(
        primaryColor: Color(0xFFBC8C61), // Rust brown
        hintColor: Color(0xFFE38C2D), // Rust orange
        scaffoldBackgroundColor: Color(0xFF1E1F23), // Dark gray
        fontFamily: 'FiraCode',
        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white70),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.white60),
        ),
      ),
      home: PresentationScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PresentationScreen extends StatefulWidget {
  @override
  _PresentationScreenState createState() => _PresentationScreenState();
}

class _PresentationScreenState extends State<PresentationScreen> with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  int currentSlide = 0;
  int totalSlides = 11;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Interactive bitwise demo state
  int registerValue = 0;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void toggleBit(int bitPosition) {
    setState(() {
      registerValue ^= (1 << bitPosition); // XOR to toggle
    });
  }

  void _onPageChanged(int index) {
    setState(() {
      currentSlide = index;
      _animationController.reset();
      _animationController.forward();
    });
  }

  Widget _buildPeripheralItem(String emoji, String title, String description) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: 20)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(description, style: TextStyle(fontSize: 14, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDriverLayer(String title, String description, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 4),
          Text(description, style: TextStyle(fontSize: 14, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildDriverCard(String title, String subtitle, String code, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 14, color: Colors.white70)),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(code, style: TextStyle(fontSize: 12, fontFamily: 'FiraCode', color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D))),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white70))),
        ],
      ),
    );
  }

  Widget _buildComparisonItem(String title, String arduino, String rust) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 4),
          Text('Arduino: $arduino', style: TextStyle(fontSize: 14, color: Colors.blue.shade300)),
          Text('Rust: $rust', style: TextStyle(fontSize: 14, color: Color(0xFFE38C2D))),
        ],
      ),
    );
  }

  Widget _buildExampleCard(String emoji, String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2D2E32),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Color(0xFFBC8C61), width: 1.5),
      ),
      child: Row(
        children: [
          Text(emoji, style: TextStyle(fontSize: 24)),
          SizedBox(width: 12),
          Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildSpecItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPinRow(String pin, String description, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            child: Text(
              pin,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'FiraCode', color: color),
            ),
          ),
          Expanded(
            child: Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyTip(String tip) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Text(
        tip,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white70),
      ),
    );
  }

  Widget _buildBenefitItem(String emoji, String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: 24)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(description, style: TextStyle(fontSize: 14, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectCard(String emoji, String title, String description) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2D2E32),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFBC8C61), width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: TextStyle(fontSize: 24)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                Text(description, style: TextStyle(fontSize: 14, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String time, String title, List<String> items, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 32, color: color),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                ...items.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
                      Expanded(child: Text(item, style: TextStyle(fontSize: 14, color: Colors.white70))),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeripheralsSlide() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ESP32 Peripherals & Drivers 🔧',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 30),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Built-in Peripherals
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Built-in Peripherals',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFBC8C61)),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFFBC8C61), width: 1.5),
                              ),
                              child: Column(
                                children: [
                                  _buildPeripheralItem('📶', 'WiFi', 'IEEE 802.11 b/g/n, AP/STA modes'),
                                  _buildPeripheralItem('🔵', 'Bluetooth', 'Classic + BLE, HID support'),
                                  _buildPeripheralItem('📊', 'ADC', '12-bit, multiple channels for sensors'),
                                  _buildPeripheralItem('⚡', 'PWM', 'LED brightness, motor speed control'),
                                  _buildPeripheralItem('💬', 'UART', 'Serial communication with sensors'),
                                  _buildPeripheralItem('🔄', 'I2C/SPI', 'High-speed sensor protocols'),
                                  _buildPeripheralItem('⏰', 'Timers', 'Precise timing, interrupts'),
                                  _buildPeripheralItem('🎵', 'DAC', 'Audio output, analog signals'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 40),
                      // What are Drivers?
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'What are Drivers?',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D)),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFFE38C2D), width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Software that controls hardware',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  SizedBox(height: 15),
                                  _buildDriverLayer('🧠 Application Layer', 'Your code: "turn on LED"', Colors.blue),
                                  Icon(Icons.keyboard_arrow_down, size: 30, color: Colors.white70),
                                  _buildDriverLayer('🔧 Driver Layer', 'HAL: "set GPIO5 to HIGH"', Colors.orange),
                                  Icon(Icons.keyboard_arrow_down, size: 30, color: Colors.white70),
                                  _buildDriverLayer('⚙️ Hardware Layer', 'Register: GPIO_OUT |= (1<<5)', Colors.red),
                                  SizedBox(height: 15),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Color(0xFFE38C2D).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Color(0xFFE38C2D)),
                                    ),
                                    child: Text(
                                      'HAL = Hardware Abstraction Layer\nHides complex register operations!',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Built-in Peripherals
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Built-in Peripherals',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFBC8C61)),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFBC8C61), width: 1.5),
                            ),
                            child: Column(
                              children: [
                                _buildPeripheralItem('📶', 'WiFi', 'IEEE 802.11 b/g/n, AP/STA modes'),
                                _buildPeripheralItem('🔵', 'Bluetooth', 'Classic + BLE, HID support'),
                                _buildPeripheralItem('📊', 'ADC', '12-bit, multiple channels for sensors'),
                                _buildPeripheralItem('⚡', 'PWM', 'LED brightness, motor speed control'),
                                _buildPeripheralItem('💬', 'UART', 'Serial communication with sensors'),
                                _buildPeripheralItem('🔄', 'I2C/SPI', 'High-speed sensor protocols'),
                                _buildPeripheralItem('⏰', 'Timers', 'Precise timing, interrupts'),
                                _buildPeripheralItem('🎵', 'DAC', 'Audio output, analog signals'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // What are Drivers?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'What are Drivers?',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D)),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFE38C2D), width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Software that controls hardware',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                SizedBox(height: 15),
                                _buildDriverLayer('🧠 Application Layer', 'Your code: "turn on LED"', Colors.blue),
                                Icon(Icons.keyboard_arrow_down, size: 30, color: Colors.white70),
                                _buildDriverLayer('🔧 Driver Layer', 'HAL: "set GPIO5 to HIGH"', Colors.orange),
                                Icon(Icons.keyboard_arrow_down, size: 30, color: Colors.white70),
                                _buildDriverLayer('⚙️ Hardware Layer', 'Register: GPIO_OUT |= (1<<5)', Colors.red),
                                SizedBox(height: 15),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE38C2D).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Color(0xFFE38C2D)),
                                  ),
                                  child: Text(
                                    'HAL = Hardware Abstraction Layer\nHides complex register operations!',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverImplementationSlide() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Driver Implementation in Rust 🦀⚙️',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 30),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Driver Structure
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ESP-HAL Driver Structure',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6B8EFF)),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFF6B8EFF), width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rust Driver Example - LED',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  SizedBox(height: 15),
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '''use esp_hal::gpio::{Io, Level, Output};

// Driver initialization
let io = Io::new(peripherals.GPIO, peripherals.IO_MUX);
let mut led = Output::new(io.pins.gpio2, Level::Low);

// Driver methods
led.set_high();  // Turn on
led.set_low();   // Turn off
led.toggle();    // Switch state''',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'FiraCode',
                                        color: Colors.green.shade300,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFF6B8EFF), width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Key Rust Driver Benefits:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                  SizedBox(height: 8),
                                  _buildBulletPoint('✅ Type Safety - Can\'t use wrong pin types'),
                                  _buildBulletPoint('✅ Zero Cost - Compiles to direct register access'),
                                  _buildBulletPoint('✅ Memory Safe - No dangling pointers'),
                                  _buildBulletPoint('✅ Trait System - Generic driver interfaces'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 40),
                      // Common Drivers
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Common ESP-HAL Drivers',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D)),
                            ),
                            SizedBox(height: 20),
                            _buildDriverCard('GPIO', 'Digital I/O pins', 'Output::new(), Input::new()', Colors.green),
                            _buildDriverCard('ADC', 'Analog readings', 'Adc::new(), read()', Colors.blue),
                            _buildDriverCard('PWM (LEDC)', 'Variable output', 'Ledc::new(), set_duty()', Colors.purple),
                            _buildDriverCard('UART', 'Serial communication', 'Uart::new(), write(), read()', Colors.red),
                            _buildDriverCard('I2C', 'Sensor communication', 'I2c::new(), write_read()', Colors.orange),
                            _buildDriverCard('SPI', 'High-speed data', 'Spi::new(), transfer()', Colors.teal),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Color(0xFFE38C2D).withOpacity(0.3), Color(0xFFBC8C61).withOpacity(0.3)],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFFE38C2D), width: 1.5),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.lightbulb, color: Color(0xFFE38C2D), size: 30),
                                  SizedBox(height: 8),
                                  Text(
                                    'Each driver handles the complex register manipulation so you don\'t have to!',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Driver Structure
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ESP-HAL Driver Structure',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6B8EFF)),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFF6B8EFF), width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rust Driver Example - LED',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '''use esp_hal::gpio::{Io, Level, Output};

// Driver initialization
let io = Io::new(peripherals.GPIO, peripherals.IO_MUX);
let mut led = Output::new(io.pins.gpio2, Level::Low);

// Driver methods
led.set_high();  // Turn on
led.set_low();   // Turn off
led.toggle();    // Switch state''',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'FiraCode',
                                      color: Colors.green.shade300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFF6B8EFF), width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Key Rust Driver Benefits:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                SizedBox(height: 8),
                                _buildBulletPoint('✅ Type Safety - Can\'t use wrong pin types'),
                                _buildBulletPoint('✅ Zero Cost - Compiles to direct register access'),
                                _buildBulletPoint('✅ Memory Safe - No dangling pointers'),
                                _buildBulletPoint('✅ Trait System - Generic driver interfaces'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // Common Drivers
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Common ESP-HAL Drivers',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D)),
                          ),
                          SizedBox(height: 20),
                          _buildDriverCard('GPIO', 'Digital I/O pins', 'Output::new(), Input::new()', Colors.green),
                          _buildDriverCard('ADC', 'Analog readings', 'Adc::new(), read()', Colors.blue),
                          _buildDriverCard('PWM (LEDC)', 'Variable output', 'Ledc::new(), set_duty()', Colors.purple),
                          _buildDriverCard('UART', 'Serial communication', 'Uart::new(), write(), read()', Colors.red),
                          _buildDriverCard('I2C', 'Sensor communication', 'I2c::new(), write_read()', Colors.orange),
                          _buildDriverCard('SPI', 'High-speed data', 'Spi::new(), transfer()', Colors.teal),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFE38C2D).withOpacity(0.3), Color(0xFFBC8C61).withOpacity(0.3)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFE38C2D), width: 1.5),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.lightbulb, color: Color(0xFFE38C2D), size: 30),
                                SizedBox(height: 8),
                                Text(
                                  'Each driver handles the complex register manipulation so you don\'t have to!',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetupLoopSlide() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Setup vs Loop Functions 🔄',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 30),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Arduino Style vs Rust
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Arduino Style (C++)',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue.shade300),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue.shade300, width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'void setup() {',
                                    style: TextStyle(fontSize: 14, fontFamily: 'FiraCode', color: Colors.blue.shade300),
                                  ),
                                  Text(
                                    '  // Run once at startup\n  pinMode(LED_PIN, OUTPUT);\n  Serial.begin(115200);\n}',
                                    style: TextStyle(fontSize: 14, fontFamily: 'FiraCode', color: Colors.white),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'void loop() {',
                                    style: TextStyle(fontSize: 14, fontFamily: 'FiraCode', color: Colors.green.shade300),
                                  ),
                                  Text(
                                    '  // Runs forever\n  digitalWrite(LED_PIN, HIGH);\n  delay(1000);\n  digitalWrite(LED_PIN, LOW);\n  delay(1000);\n}',
                                    style: TextStyle(fontSize: 14, fontFamily: 'FiraCode', color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue.shade300, width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Arduino Pattern:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                  SizedBox(height: 8),
                                  _buildBulletPoint('setup() - Initialize hardware once'),
                                  _buildBulletPoint('loop() - Main program, runs forever'),
                                  _buildBulletPoint('Simple but less flexible'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 40),
                      // Rust Style
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rust ESP-HAL Style',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D)),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFFE38C2D), width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '#[entry]\nfn main() -> ! {',
                                    style: TextStyle(fontSize: 14, fontFamily: 'FiraCode', color: Color(0xFFE38C2D)),
                                  ),
                                  Text(
                                    '  // Setup phase\n  let peripherals = Peripherals::take();\n  let clocks = ClockControl::max(..).freeze();\n  let io = Io::new(..);\n  let mut led = Output::new(io.pins.gpio2, Level::Low);',
                                    style: TextStyle(fontSize: 12, fontFamily: 'FiraCode', color: Colors.white),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '  loop {',
                                    style: TextStyle(fontSize: 14, fontFamily: 'FiraCode', color: Colors.green.shade300),
                                  ),
                                  Text(
                                    '    // Main program\n    led.set_high();\n    delay.delay_ms(1000u32);\n    led.set_low();\n    delay.delay_ms(1000u32);\n  }\n}',
                                    style: TextStyle(fontSize: 12, fontFamily: 'FiraCode', color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFFE38C2D), width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Rust Pattern:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                  SizedBox(height: 8),
                                  _buildBulletPoint('All in main() function'),
                                  _buildBulletPoint('Setup at top, loop at bottom'),
                                  _buildBulletPoint('Type-safe, memory-safe'),
                                  _buildBulletPoint('More control over resources'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Arduino Style vs Rust
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Arduino Style (C++)',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue.shade300),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue.shade300, width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'void setup() {',
                                  style: TextStyle(fontSize: 14, fontFamily: 'FiraCode', color: Colors.blue.shade300),
                                ),
                                Text(
                                  '  // Run once at startup\n  pinMode(LED_PIN, OUTPUT);\n  Serial.begin(115200);\n}',
                                  style: TextStyle(fontSize: 14, fontFamily: 'FiraCode', color: Colors.white),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'void loop() {',
                                  style: TextStyle(fontSize: 14, fontFamily: 'FiraCode', color: Colors.green.shade300),
                                ),
                                Text(
                                  '  // Runs forever\n  digitalWrite(LED_PIN, HIGH);\n  delay(1000);\n  digitalWrite(LED_PIN, LOW);\n  delay(1000);\n}',
                                  style: TextStyle(fontSize: 14, fontFamily: 'FiraCode', color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue.shade300, width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Arduino Pattern:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                SizedBox(height: 8),
                                _buildBulletPoint('setup() - Initialize hardware once'),
                                _buildBulletPoint('loop() - Main program, runs forever'),
                                _buildBulletPoint('Simple but less flexible'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // Rust Style
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rust ESP-HAL Style',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D)),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFE38C2D), width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '#[entry]\nfn main() -> ! {',
                                  style: TextStyle(fontSize: 14, fontFamily: 'FiraCode', color: Color(0xFFE38C2D)),
                                ),
                                Text(
                                  '  // Setup phase\n  let peripherals = Peripherals::take();\n  let clocks = ClockControl::max(..).freeze();\n  let io = Io::new(..);\n  let mut led = Output::new(io.pins.gpio2, Level::Low);',
                                  style: TextStyle(fontSize: 12, fontFamily: 'FiraCode', color: Colors.white),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '  loop {',
                                  style: TextStyle(fontSize: 14, fontFamily: 'FiraCode', color: Colors.green.shade300),
                                ),
                                Text(
                                  '    // Main program\n    led.set_high();\n    delay.delay_ms(1000u32);\n    led.set_low();\n    delay.delay_ms(1000u32);\n  }\n}',
                                  style: TextStyle(fontSize: 12, fontFamily: 'FiraCode', color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFE38C2D), width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Rust Pattern:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                SizedBox(height: 8),
                                _buildBulletPoint('All in main() function'),
                                _buildBulletPoint('Setup at top, loop at bottom'),
                                _buildBulletPoint('Type-safe, memory-safe'),
                                _buildBulletPoint('More control over resources'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 30),
            // Key Differences
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFBC8C61).withOpacity(0.2), Color(0xFFE38C2D).withOpacity(0.2)]),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFFBC8C61), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🔍 Key Differences',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 15),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        return Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildComparisonItem('Entry Point', 'Arduino: setup()+loop()', 'Rust: main() with loop {}'),
                                  _buildComparisonItem('Memory', 'Arduino: Manual management', 'Rust: Ownership system'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildComparisonItem('Type Safety', 'Arduino: Runtime errors', 'Rust: Compile-time checks'),
                                  _buildComparisonItem('Performance', 'Arduino: Good', 'Rust: Zero-cost abstractions'),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildComparisonItem('Entry Point', 'Arduino: setup()+loop()', 'Rust: main() with loop {}'),
                            _buildComparisonItem('Memory', 'Arduino: Manual management', 'Rust: Ownership system'),
                            _buildComparisonItem('Type Safety', 'Arduino: Runtime errors', 'Rust: Compile-time checks'),
                            _buildComparisonItem('Performance', 'Arduino: Good', 'Rust: Zero-cost abstractions'),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSlide() {
    return Container(
      padding: EdgeInsets.all(24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🦀', style: TextStyle(fontSize: 100)),
            SizedBox(height: 40),
            Text(
              'Embedded Systems with Rust ESP-HAL',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Text(
              'IEEE University of Nairobi',
              style: TextStyle(fontSize: 28, color: Color(0xFFE38C2D)),
            ),
            SizedBox(height: 20),
            Text(
              'ESP32 Workshop - 2:30 PM to 5:00 PM',
              style: TextStyle(fontSize: 20, color: Colors.white70),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE38C2D), Color(0xFFBC8C61)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Instructor: ANDREW MUCHANGI',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmbeddedSystemsSlide() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'What Are Embedded Systems?',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 30),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column - Definition
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Definition',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6B8EFF)),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Computer systems designed to perform specific tasks, embedded within larger devices',
                              style: TextStyle(fontSize: 18, color: Colors.white70),
                            ),
                            SizedBox(height: 30),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFF6B8EFF), width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Key Characteristics:',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  SizedBox(height: 10),
                                  _buildBulletPoint('Real-time operation'),
                                  _buildBulletPoint('Resource constraints'),
                                  _buildBulletPoint('Direct hardware interaction'),
                                  _buildBulletPoint('Single-purpose design'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 40),
                      // Right Column - Examples
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Examples',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D)),
                            ),
                            SizedBox(height: 20),
                            _buildExampleCard('🚗', 'Car Engine Control Units'),
                            _buildExampleCard('📱', 'Smart Phone Components'),
                            _buildExampleCard('🏠', 'Home Automation'),
                            _buildExampleCard('🎮', 'Gaming Controllers'),
                            _buildExampleCard('⌚', 'Smartwatches'),
                            _buildExampleCard('🛰️', 'Satellite Systems'),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Column - Definition
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Definition',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6B8EFF)),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Computer systems designed to perform specific tasks, embedded within larger devices',
                            style: TextStyle(fontSize: 18, color: Colors.white70),
                          ),
                          SizedBox(height: 30),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFF6B8EFF), width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Key Characteristics:',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                SizedBox(height: 10),
                                _buildBulletPoint('Real-time operation'),
                                _buildBulletPoint('Resource constraints'),
                                _buildBulletPoint('Direct hardware interaction'),
                                _buildBulletPoint('Single-purpose design'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // Right Column - Examples
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Examples',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D)),
                          ),
                          SizedBox(height: 20),
                          _buildExampleCard('🚗', 'Car Engine Control Units'),
                          _buildExampleCard('📱', 'Smart Phone Components'),
                          _buildExampleCard('🏠', 'Home Automation'),
                          _buildExampleCard('🎮', 'Gaming Controllers'),
                          _buildExampleCard('⌚', 'Smartwatches'),
                          _buildExampleCard('🛰️', 'Satellite Systems'),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHardwareConceptsSlide() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hardware Concepts - GPIO & Registers',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 30),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left - GPIO
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GPIO (General Purpose I/O)',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFBC8C61)),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFFBC8C61), width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Digital pins that can be:', style: TextStyle(fontSize: 18, color: Colors.white)),
                                  SizedBox(height: 10),
                                  _buildBulletPoint('INPUT: Read sensor data'),
                                  _buildBulletPoint('OUTPUT: Control LEDs, motors'),
                                  _buildBulletPoint('ANALOG: Read voltage levels'),
                                  _buildBulletPoint('PWM: Control brightness, speed'),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFFE38C2D), width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Voltage Levels',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D)),
                                  ),
                                  SizedBox(height: 10),
                                  Text('ESP32: 3.3V logic', style: TextStyle(fontSize: 16, color: Colors.white70)),
                                  Text('HIGH = 3.3V, LOW = 0V', style: TextStyle(fontSize: 16, color: Colors.white70)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 40),
                      // Right - Registers
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Registers = Memory Arrays',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red.shade300),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade300, width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'GPIO Register (8-bit example):',
                                    style: TextStyle(fontSize: 16, fontFamily: 'FiraCode', color: Colors.white),
                                  ),
                                  SizedBox(height: 15),
                                  // 8-bit register visualization
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: List.generate(8, (index) {
                                      bool isActive = index == 2 || index == 5; // GPIO2 and GPIO5 active
                                      return Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: isActive ? Colors.green.shade300 : Color(0xFF2D2E32),
                                          border: Border.all(color: Colors.white),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Center(
                                          child: Text(
                                            isActive ? '1' : '0',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Bit 2: GPIO2 (HIGH), Bit 5: GPIO5 (HIGH)',
                                    style: TextStyle(fontSize: 12, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade300, width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Key Concept:',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    'Ports are just arrays of bits you control with bitwise operations!',
                                    style: TextStyle(fontSize: 16, color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left - GPIO
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'GPIO (General Purpose I/O)',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFBC8C61)),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFBC8C61), width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Digital pins that can be:', style: TextStyle(fontSize: 18, color: Colors.white)),
                                SizedBox(height: 10),
                                _buildBulletPoint('INPUT: Read sensor data'),
                                _buildBulletPoint('OUTPUT: Control LEDs, motors'),
                                _buildBulletPoint('ANALOG: Read voltage levels'),
                                _buildBulletPoint('PWM: Control brightness, speed'),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFE38C2D), width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Voltage Levels',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D)),
                                ),
                                SizedBox(height: 10),
                                Text('ESP32: 3.3V logic', style: TextStyle(fontSize: 16, color: Colors.white70)),
                                Text('HIGH = 3.3V, LOW = 0V', style: TextStyle(fontSize: 16, color: Colors.white70)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // Right - Registers
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Registers = Memory Arrays',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red.shade300),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade300, width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'GPIO Register (8-bit example):',
                                  style: TextStyle(fontSize: 16, fontFamily: 'FiraCode', color: Colors.white),
                                ),
                                SizedBox(height: 15),
                                // 8-bit register visualization
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: List.generate(8, (index) {
                                    bool isActive = index == 2 || index == 5; // GPIO2 and GPIO5 active
                                    return Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: isActive ? Colors.green.shade300 : Color(0xFF2D2E32),
                                        border: Border.all(color: Colors.white),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Center(
                                        child: Text(
                                          isActive ? '1' : '0',
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Bit 2: GPIO2 (HIGH), Bit 5: GPIO5 (HIGH)',
                                  style: TextStyle(fontSize: 12, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade300, width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Key Concept:',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Ports are just arrays of bits you control with bitwise operations!',
                                  style: TextStyle(fontSize: 16, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBitwiseSlide() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bitwise Operations - The Magic Behind GPIO',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 30),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left - Operations
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Common Operations',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6B8EFF)),
                            ),
                            SizedBox(height: 20),
                            // Set Bit
                            Container(
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFF6B8EFF), width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Set Bit (Turn ON GPIO)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                  SizedBox(height: 8),
                                  Text('register |= (1 << pin)', style: TextStyle(fontSize: 16, fontFamily: 'FiraCode', color: Color(0xFF6B8EFF))),
                                  Text('Example: Set GPIO5', style: TextStyle(fontSize: 14, color: Colors.white70)),
                                  Text('0b00000000 |= (1 << 5) = 0b00100000', style: TextStyle(fontSize: 14, fontFamily: 'FiraCode', color: Colors.white)),
                                ],
                              ),
                            ),
                            // Clear Bit
                            Container(
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.red.shade300, width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Clear Bit (Turn OFF GPIO)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                  SizedBox(height: 8),
                                  Text('register &= ~(1 << pin)', style: TextStyle(fontSize: 16, fontFamily: 'FiraCode', color: Colors.red.shade300)),
                                  Text('Example: Clear GPIO5', style: TextStyle(fontSize: 14, color: Colors.white70)),
                                  Text('0b00100000 &= ~(1 << 5) = 0b00000000', style: TextStyle(fontSize: 14, fontFamily: 'FiraCode', color: Colors.white)),
                                ],
                              ),
                            ),
                            // Read Bit
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green.shade300, width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Read Bit (Check GPIO)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                  SizedBox(height: 8),
                                  Text('bit = (register >> pin) & 1', style: TextStyle(fontSize: 16, fontFamily: 'FiraCode', color: Colors.green.shade300)),
                                  Text('Returns 1 if HIGH, 0 if LOW', style: TextStyle(fontSize: 14, color: Colors.white70)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 40),
                      // Right - Interactive Demo
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Interactive Demo',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D)),
                            ),
                            SizedBox(height: 20),
                            Text('Click bits to toggle GPIO pins:', style: TextStyle(fontSize: 16, color: Colors.white)),
                            SizedBox(height: 20),
                            // Interactive 8-bit register
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(8, (index) {
                                bool isActive = (registerValue >> index) & 1 == 1;
                                return GestureDetector(
                                  onTap: () => toggleBit(index),
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: isActive ? Colors.green.shade400 : Color(0xFF2D2E32),
                                      border: Border.all(color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: isActive
                                          ? [
                                              BoxShadow(
                                                color: Colors.green.withOpacity(0.5),
                                                blurRadius: 10,
                                                spreadRadius: 2,
                                              )
                                            ]
                                          : [],
                                    ),
                                    child: Center(
                                      child: Text(
                                        isActive ? '1' : '0',
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(8, (index) {
                                return Text(
                                  'GPIO$index',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70),
                                );
                              }),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFFE38C2D), width: 1.5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Current Register Value:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                  SizedBox(height: 8),
                                  Text('Binary: ${registerValue.toRadixString(2).padLeft(8, '0')}', 
                                       style: TextStyle(fontSize: 16, fontFamily: 'FiraCode', color: Colors.white)),
                                  Text('Decimal: $registerValue', style: TextStyle(fontSize: 16, fontFamily: 'FiraCode', color: Colors.white)),
                                  Text('Hex: 0x${registerValue.toRadixString(16).toUpperCase().padLeft(2, '0')}', 
                                       style: TextStyle(fontSize: 16, fontFamily: 'FiraCode', color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left - Operations
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Common Operations',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6B8EFF)),
                          ),
                          SizedBox(height: 20),
                          // Set Bit
                          Container(
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFF6B8EFF), width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Set Bit (Turn ON GPIO)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                SizedBox(height: 8),
                                Text('register |= (1 << pin)', style: TextStyle(fontSize: 16, fontFamily: 'FiraCode', color: Color(0xFF6B8EFF))),
                                Text('Example: Set GPIO5', style: TextStyle(fontSize: 14, color: Colors.white70)),
                                Text('0b00000000 |= (1 << 5) = 0b00100000', style: TextStyle(fontSize: 14, fontFamily: 'FiraCode', color: Colors.white)),
                              ],
                            ),
                          ),
                          // Clear Bit
                          Container(
                            padding: EdgeInsets.all(16),
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.red.shade300, width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Clear Bit (Turn OFF GPIO)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                SizedBox(height: 8),
                                Text('register &= ~(1 << pin)', style: TextStyle(fontSize: 16, fontFamily: 'FiraCode', color: Colors.red.shade300)),
                                Text('Example: Clear GPIO5', style: TextStyle(fontSize: 14, color: Colors.white70)),
                                Text('0b00100000 &= ~(1 << 5) = 0b00000000', style: TextStyle(fontSize: 14, fontFamily: 'FiraCode', color: Colors.white)),
                              ],
                            ),
                          ),
                          // Read Bit
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade300, width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Read Bit (Check GPIO)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                SizedBox(height: 8),
                                Text('bit = (register >> pin) & 1', style: TextStyle(fontSize: 16, fontFamily: 'FiraCode', color: Colors.green.shade300)),
                                Text('Returns 1 if HIGH, 0 if LOW', style: TextStyle(fontSize: 14, color: Colors.white70)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // Right - Interactive Demo
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Interactive Demo',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D)),
                          ),
                          SizedBox(height: 20),
                          Text('Click bits to toggle GPIO pins:', style: TextStyle(fontSize: 16, color: Colors.white)),
                          SizedBox(height: 20),
                          // Interactive 8-bit register
                          Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            children: List.generate(8, (index) {
                              bool isActive = (registerValue >> index) & 1 == 1;
                              return GestureDetector(
                                onTap: () => toggleBit(index),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  width: 50,
                                  height: 50,
                                  margin: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: isActive ? Colors.green.shade400 : Color(0xFF2D2E32),
                                    border: Border.all(color: Colors.white, width: 2),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: isActive
                                        ? [
                                            BoxShadow(
                                              color: Colors.green.withOpacity(0.5),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                            )
                                          ]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Text(
                                      isActive ? '1' : '0',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 20),
                          Wrap(
                            alignment: WrapAlignment.spaceEvenly,
                            children: List.generate(8, (index) {
                              return Container(
                                width: 50,
                                child: Text(
                                  'GPIO$index',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFE38C2D), width: 1.5),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Current Register Value:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                SizedBox(height: 8),
                                Text('Binary: ${registerValue.toRadixString(2).padLeft(8, '0')}', 
                                     style: TextStyle(fontSize: 16, fontFamily: 'FiraCode', color: Colors.white)),
                                Text('Decimal: $registerValue', style: TextStyle(fontSize: 16, fontFamily: 'FiraCode', color: Colors.white)),
                                Text('Hex: 0x${registerValue.toRadixString(16).toUpperCase().padLeft(2, '0')}', 
                                     style: TextStyle(fontSize: 16, fontFamily: 'FiraCode', color: Colors.white)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildESPComparisonSlide() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ESP32-C6 vs ESP32 WROOM32',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 30),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ESP32-C6
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Color(0xFF2D2E32),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Color(0xFF6B8EFF), width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.memory, color: Color(0xFF6B8EFF), size: 30),
                                  SizedBox(width: 10),
                                  Text(
                                    'ESP32-C6',
                                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF6B8EFF)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              _buildSpecItem('CPU', 'RISC-V 32-bit @ 160MHz'),
                              _buildSpecItem('Architecture', 'RISC-V'),
                              _buildSpecItem('RAM', '512KB SRAM'),
                              _buildSpecItem('Flash', '4MB'),
                              _buildSpecItem('GPIO Pins', '30 pins'),
                              _buildSpecItem('ADC', '12-bit, 7 channels'),
                              _buildSpecItem('Connectivity', 'WiFi 6, Bluetooth 5'),
                              _buildSpecItem('Special', '802.15.4 (Zigbee/Thread)'),
                              _buildSpecItem('Power', 'Ultra low power'),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.green),
                                ),
                                child: Text(
                                  'Best for: IoT, low-power applications, mesh networks',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green.shade300),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 40),
                      // ESP32 WROOM32
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Color(0xFF2D2E32),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Color(0xFFE38C2D), width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.developer_board, color: Color(0xFFE38C2D), size: 30),
                                  SizedBox(width: 10),
                                  Text(
                                    'ESP32 WROOM32',
                                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D)),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              _buildSpecItem('CPU', 'Xtensa 32-bit Dual Core @ 240MHz'),
                              _buildSpecItem('Architecture', 'Xtensa LX6'),
                              _buildSpecItem('RAM', '520KB SRAM'),
                              _buildSpecItem('Flash', '4MB'),
                              _buildSpecItem('GPIO Pins', '34 pins'),
                              _buildSpecItem('ADC', '12-bit, 18 channels'),
                              _buildSpecItem('Connectivity', 'WiFi 4, Bluetooth Classic + LE'),
                              _buildSpecItem('Special', 'Dual core, more peripherals'),
                              _buildSpecItem('Power', 'Higher performance'),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue),
                                ),
                                child: Text(
                                  'Best for: High-performance apps, complex processing, multimedia',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue.shade300),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ESP32-C6
                      Container(
                        padding: EdgeInsets.all(24),
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Color(0xFF2D2E32),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xFF6B8EFF), width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.memory, color: Color(0xFF6B8EFF), size: 30),
                                SizedBox(width: 10),
                                Text(
                                  'ESP32-C6',
                                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF6B8EFF)),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            _buildSpecItem('CPU', 'RISC-V 32-bit @ 160MHz'),
                            _buildSpecItem('Architecture', 'RISC-V'),
                            _buildSpecItem('RAM', '512KB SRAM'),
                            _buildSpecItem('Flash', '4MB'),
                            _buildSpecItem('GPIO Pins', '30 pins'),
                            _buildSpecItem('ADC', '12-bit, 7 channels'),
                            _buildSpecItem('Connectivity', 'WiFi 6, Bluetooth 5'),
                            _buildSpecItem('Special', '802.15.4 (Zigbee/Thread)'),
                            _buildSpecItem('Power', 'Ultra low power'),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green),
                              ),
                              child: Text(
                                'Best for: IoT, low-power applications, mesh networks',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green.shade300),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // ESP32 WROOM32
                      Container(
                        padding: EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Color(0xFF2D2E32),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Color(0xFFE38C2D), width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.developer_board, color: Color(0xFFE38C2D), size: 30),
                                SizedBox(width: 10),
                                Text(
                                  'ESP32 WROOM32',
                                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D)),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            _buildSpecItem('CPU', 'Xtensa 32-bit Dual Core @ 240MHz'),
                            _buildSpecItem('Architecture', 'Xtensa LX6'),
                            _buildSpecItem('RAM', '520KB SRAM'),
                            _buildSpecItem('Flash', '4MB'),
                            _buildSpecItem('GPIO Pins', '34 pins'),
                            _buildSpecItem('ADC', '12-bit, 18 channels'),
                            _buildSpecItem('Connectivity', 'WiFi 4, Bluetooth Classic + LE'),
                            _buildSpecItem('Special', 'Dual core, more peripherals'),
                            _buildSpecItem('Power', 'Higher performance'),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue),
                              ),
                              child: Text(
                                'Best for: High-performance apps, complex processing, multimedia',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blue.shade300),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinoutSlide() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'GPIO Pinout & Safe Pins',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 30),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ESP32-C6 Pinout
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'ESP32-C6 Safe Pins',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6B8EFF)),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFF6B8EFF), width: 1.5),
                              ),
                              child: Column(
                                children: [
                                  _buildPinRow('GPIO0-7', 'General purpose, safe for outputs', Colors.green),
                                  _buildPinRow('GPIO8', 'Built-in LED (usually)', Colors.yellow),
                                  _buildPinRow('GPIO9', 'Boot button (input only)', Colors.red),
                                  _buildPinRow('GPIO18-21', 'Safe for most applications', Colors.green),
                                  SizedBox(height: 15),
                                  Text(
                                    'Avoid: GPIO12-17 (SPI Flash)',
                                    style: TextStyle(fontSize: 14, color: Colors.red.shade300, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 40),
                      // ESP32 WROOM32 Pinout
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'ESP32 WROOM32 Safe Pins',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D)),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Color(0xFFE38C2D), width: 1.5),
                              ),
                              child: Column(
                                children: [
                                  _buildPinRow('GPIO0', 'Boot mode, has pullup', Colors.yellow),
                                  _buildPinRow('GPIO2', 'Built-in LED, safe output', Colors.green),
                                  _buildPinRow('GPIO4, 5', 'Safe for any purpose', Colors.green),
                                  _buildPinRow('GPIO12-15', 'Safe, but check boot state', Colors.yellow),
                                  _buildPinRow('GPIO18-19', 'Safe for outputs', Colors.green),
                                  _buildPinRow('GPIO21-23', 'Safe, commonly used', Colors.green),
                                  SizedBox(height: 15),
                                  Text(
                                    'Avoid: GPIO6-11 (SPI Flash)',
                                    style: TextStyle(fontSize: 14, color: Colors.red.shade300, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ESP32-C6 Pinout
                      Column(
                        children: [
                          Text(
                            'ESP32-C6 Safe Pins',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6B8EFF)),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFF6B8EFF), width: 1.5),
                            ),
                            child: Column(
                              children: [
                                _buildPinRow('GPIO0-7', 'General purpose, safe for outputs', Colors.green),
                                _buildPinRow('GPIO8', 'Built-in LED (usually)', Colors.yellow),
                                _buildPinRow('GPIO9', 'Boot button (input only)', Colors.red),
                                _buildPinRow('GPIO18-21', 'Safe for most applications', Colors.green),
                                SizedBox(height: 15),
                                Text(
                                  'Avoid: GPIO12-17 (SPI Flash)',
                                  style: TextStyle(fontSize: 14, color: Colors.red.shade300, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // ESP32 WROOM32 Pinout
                      Column(
                        children: [
                          Text(
                            'ESP32 WROOM32 Safe Pins',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFE38C2D)),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFFE38C2D), width: 1.5),
                            ),
                            child: Column(
                              children: [
                                _buildPinRow('GPIO0', 'Boot mode, has pullup', Colors.yellow),
                                _buildPinRow('GPIO2', 'Built-in LED, safe output', Colors.green),
                                _buildPinRow('GPIO4, 5', 'Safe for any purpose', Colors.green),
                                _buildPinRow('GPIO12-15', 'Safe, but check boot state', Colors.yellow),
                                _buildPinRow('GPIO18-19', 'Safe for outputs', Colors.green),
                                _buildPinRow('GPIO21-23', 'Safe, commonly used', Colors.green),
                                SizedBox(height: 15),
                                Text(
                                  'Avoid: GPIO6-11 (SPI Flash)',
                                  style: TextStyle(fontSize: 14, color: Colors.red.shade300, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 30),
            // Circuit Tips
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFBC8C61).withOpacity(0.2), Color(0xFFE38C2D).withOpacity(0.2)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFFBC8C61), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '⚡ Circuit Safety Tips',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 15),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        return Row(
                          children: [
                            Expanded(child: _buildSafetyTip('💡 Always use 220Ω resistors with LEDs')),
                            Expanded(child: _buildSafetyTip('⚡ Max 12mA per GPIO pin')),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            _buildSafetyTip('💡 Always use 220Ω resistors with LEDs'),
                            _buildSafetyTip('⚡ Max 12mA per GPIO pin'),
                          ],
                        );
                      }
                    },
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth > 600) {
                        return Row(
                          children: [
                            Expanded(child: _buildSafetyTip('🔌 ESP32 = 3.3V logic (NOT 5V!)')),
                            Expanded(child: _buildSafetyTip('🔒 Use internal pull-ups for buttons')),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            _buildSafetyTip('🔌 ESP32 = 3.3V logic (NOT 5V!)'),
                            _buildSafetyTip('🔒 Use internal pull-ups for buttons'),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRustProjectsSlide() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why Rust for Embedded? 🦀',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 30),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Benefits
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rust Benefits',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade300),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Color(0xFF2D2E32),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.green.shade300, width: 1.5),
                              ),
                              child: Column(
                                children: [
                                  _buildBenefitItem('🔒', 'Memory Safety', 'No buffer overflows, no dangling pointers'),
                                  _buildBenefitItem('⚡', 'Zero-cost Abstractions', 'High-level code, low-level performance'),
                                  _buildBenefitItem('🐛', 'Fearless Concurrency', 'Thread-safe code by design'),
                                  _buildBenefitItem('📏', 'Small Binary Size', 'Perfect for resource-constrained devices'),
                                  _buildBenefitItem('🔧', 'Great Tooling', 'Cargo, rustfmt, clippy built-in'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 40),
                      // ESP-HAL Projects
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ESP-HAL Project Ideas',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6B8EFF)),
                            ),
                            SizedBox(height: 20),
                            _buildProjectCard('🌡️', 'Temperature Monitor', 'Read sensors, display on web dashboard'),
                            _buildProjectCard('🏠', 'Smart Home Hub', 'Control lights, read sensors, WiFi connected'),
                            _buildProjectCard('📊', 'Data Logger', 'Store sensor readings to SD card or cloud'),
                            _buildProjectCard('🚗', 'Vehicle Tracker', 'GPS + WiFi location tracking'),
                            _buildProjectCard('🎮', 'Game Controller', 'Bluetooth HID device with buttons'),
                            _buildProjectCard('🔊', 'Audio Player', 'Stream music over WiFi, control with web UI'),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Benefits
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rust Benefits',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade300),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFF2D2E32),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade300, width: 1.5),
                            ),
                            child: Column(
                              children: [
                                _buildBenefitItem('🔒', 'Memory Safety', 'No buffer overflows, no dangling pointers'),
                                _buildBenefitItem('⚡', 'Zero-cost Abstractions', 'High-level code, low-level performance'),
                                _buildBenefitItem('🐛', 'Fearless Concurrency', 'Thread-safe code by design'),
                                _buildBenefitItem('📏', 'Small Binary Size', 'Perfect for resource-constrained devices'),
                                _buildBenefitItem('🔧', 'Great Tooling', 'Cargo, rustfmt, clippy built-in'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      // ESP-HAL Projects
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ESP-HAL Project Ideas',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF6B8EFF)),
                          ),
                          SizedBox(height: 20),
                          _buildProjectCard('🌡️', 'Temperature Monitor', 'Read sensors, display on web dashboard'),
                          _buildProjectCard('🏠', 'Smart Home Hub', 'Control lights, read sensors, WiFi connected'),
                          _buildProjectCard('📊', 'Data Logger', 'Store sensor readings to SD card or cloud'),
                          _buildProjectCard('🚗', 'Vehicle Tracker', 'GPS + WiFi location tracking'),
                          _buildProjectCard('🎮', 'Game Controller', 'Bluetooth HID device with buttons'),
                          _buildProjectCard('🔊', 'Audio Player', 'Stream music over WiFi, control with web UI'),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: 30),
            // Code Example
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF2D2E32),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFFBC8C61), width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rust ESP-HAL Setup (espup)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '''# Install espup toolchain manager
cargo install espup

# Install ESP Rust toolchain
espup install

# Source environment (or restart terminal)
source ~/export-esp.sh

# Install flash tool
cargo install espflash

# Create new project
cargo generate esp-rs/esp-template
# Select your chip: ESP32-C6 or ESP32

# Flash and monitor
cargo espflash flash --monitor''',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'FiraCode',
                        color: Colors.green.shade300,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionPlanSlide() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Session Plan 📅',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            SizedBox(height: 30),
            Column(
              children: [
                _buildTimeSlot(
                  '2:30 - 3:00 PM',
                  'Theory & Slides',
                  ['ESP32-C6 vs WROOM32 comparison', 'Pinout walkthrough', 'Development environment setup'],
                  Color(0xFF6B8EFF),
                  Icons.school,
                ),
                SizedBox(height: 20),
                _buildTimeSlot(
                  '3:00 - 5:00 PM',
                  'External Hardware',
                  ['Built-in LED blink (GPIO 2 for most ESP32)', 'Upload process, serial monitor basics','Physical LED on breadboard (GPIO pins)', 'Multiple LED control'],
                  Colors.green.shade300,
                  Icons.code,
                )
              ],
            ),
            SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFBC8C61).withOpacity(0.2), Color(0xFFE38C2D).withOpacity(0.2)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Color(0xFFBC8C61), width: 1.5),
              ),
              child: Column(
                children: [
                  Icon(Icons.emoji_events, size: 50, color: Color(0xFFE38C2D)),
                  SizedBox(height: 15),
                  Text(
                    'Ready to build some amazing embedded projects with Rust? Let\'s go! 🚀',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1F23),
      body: Column(
        children: [
          // Header with navigation
          Container(
            height: 80,
            color: Color(0xFF2D2E32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'ESP32 Rust Workshop - IEEE UoN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: currentSlide > 0 ? () {
                        _pageController.previousPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      } : null,
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Color(0xFFBC8C61).withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${currentSlide + 1} / $totalSlides',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    IconButton(
                      onPressed: currentSlide < totalSlides - 1 ? () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      } : null,
                      icon: Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Main content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: [
                // Slide 1: Title
                _buildTitleSlide(),
                
                // Slide 2: What are Embedded Systems
                _buildEmbeddedSystemsSlide(),
                
                // Slide 3: Hardware Concepts
                _buildHardwareConceptsSlide(),
                
                // Slide 4: Bitwise Operations
                _buildBitwiseSlide(),
                
                // Slide 5: ESP32-C6 vs WROOM32
                _buildESPComparisonSlide(),
                
                // Slide 6: Pinout Diagrams
                _buildPinoutSlide(),
                
                // Slide 7: Rust ESP-HAL Projects
                _buildRustProjectsSlide(),
                
                // Slide 8: Session Plan
                _buildSessionPlanSlide(),
                
                // Slide 9: Peripherals and Drivers
                _buildPeripheralsSlide(),
                
                // Slide 10: Driver Implementation in Rust
                _buildDriverImplementationSlide(),
                
                // Slide 11: Setup and Loop Functions
                _buildSetupLoopSlide(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}