import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:wether_app/screens/City-selection%20_screen.dart';

class MainHomeScreen extends StatefulWidget {
  final String? initialCity;
  final String? initialCountry;
  final String? initialState;

  const MainHomeScreen({
    super.key,
    this.initialCity,
    this.initialCountry,
    this.initialState,
  });

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen>
    with TickerProviderStateMixin {
  final String apiKey = "84546b7cf4b94931bb370506262903";
  late String city;
  late String country;
  late String state;

  double Temperature = 0;
  double ReeLFEEL = 0;
  int Humidity = 0;
  double WindsPEED = 0;
  String WEATHERTEXT = "";
  String WEATHERICON = "";
  bool loading = true;

  List hourlyForecast = [];
  List dailyForecast = [];

  // Animation Controllers
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _rotateController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _rotateAnimation;

  Future<void> getWeather() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.weatherapi.com/v1/forecast.json?key=$apiKey&q=$city&days=7&aqi=no&alerts=no',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          Temperature = (data['current']['temp_c'] as num).toDouble();
          ReeLFEEL = (data['current']['feelslike_c'] as num).toDouble();
          Humidity = data['current']['humidity'] as int;
          WindsPEED = (data['current']['wind_kph'] as num).toDouble();
          WEATHERTEXT = data['current']['condition']['text'] as String;
          WEATHERICON = data['current']['condition']['icon'] as String;
        });

        final nowHour = DateTime.now().hour;
        List hours = data['forecast']['forecastday'][0]['hour'];
        List next12 = [];
        for (int i = 0; i < 12; i++) {
          int hourIndex = (nowHour + i) % 24;
          next12.add(hours[hourIndex]);
        }

        setState(() {
          hourlyForecast = next12;
          dailyForecast = data['forecast']['forecastday'];
          loading = false;
        });
      } else {
        print("Failed to fetch weather data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }

  @override
  void initState() {
    super.initState();

    city = (widget.initialCity ?? "Lahore").trim().replaceAll(" ", "+");
    country = widget.initialCountry ?? "Pakistan";
    state = widget.initialState ?? "Punjab";

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _rotateController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
    );
    _rotateAnimation = Tween<double>(begin: 0.0, end: 6.28).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.linear),
    );

    getWeather();
    _fadeController.forward();
    _scaleController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 1500),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: loading
                ? [Color(0xFF81D4FA), Color(0xFF0288D1)]
                : [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: loading
                ? _buildLoading()
                : FadeTransition(
                    opacity: _fadeAnimation,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildCityHeader(),
                          const SizedBox(height: 20),
                          _buildCurrentWeather(),
                          const SizedBox(height: 30),
                          _buildHourlyForecast(),
                          const SizedBox(height: 30),
                          _buildDailyForecast(),
                          const SizedBox(height: 30),
                          _buildActionButtons(),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(seconds: 2),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.5 + (value * 0.5),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            "Loading weather data...",
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCityHeader() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(0.4),
          border: Border.all(color: Colors.white, width: 2.5),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "📍 Current Location",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$country, $state",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    city.replaceAll("+", " ").toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CitySelectionScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0288D1),
                elevation: 10,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.location_on, size: 24),
              label: const Text(
                "Change",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentWeather() {
    return ScaleTransition(
      scale: _scaleAnimation,
      // ✅ FIX: ClipRRect added to contain BackdropFilter blur within this card only
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.25),
                Colors.white.withOpacity(0.1)
              ],
            ),
            border:
                Border.all(color: Colors.white.withOpacity(0.3), width: 2),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Now",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "$Temperature°C",
                            style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      RotationTransition(
                        turns: _rotateAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Image.network(
                            "https:$WEATHERICON",
                            scale: 0.5,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.cloud,
                                  size: 60, color: Colors.white);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    WEATHERTEXT,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.95),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHourlyForecast() {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "⏰ Next 12 Hours",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.95),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount:
                  hourlyForecast.isEmpty ? 0 : hourlyForecast.length,
              itemBuilder: (context, index) {
                final hourData = hourlyForecast[index];
                final hour = DateTime.parse(hourData['time']).hour;
                final temp = (hourData['temp_c'] as num).toDouble();
                final icon = hourData['condition']['icon'];
                return _HourlyWeatherCard(
                    hour: hour,
                    temperature: temp,
                    icon: icon,
                    index: index);
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyForecast() {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "📅 7-Day Forecast",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.95),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: dailyForecast.isEmpty ? 0 : dailyForecast.length,
              itemBuilder: (context, index) {
                final dayData = dailyForecast[index];
                final date = dayData['date'];
                final maxtemp =
                    (dayData['day']['maxtemp_c'] as num).toDouble();
                final mintemp =
                    (dayData['day']['mintemp_c'] as num).toDouble();
                final icon = dayData['day']['condition']['icon'];
                return _DailyWeatherCard(
                    date: date,
                    maxTemp: maxtemp,
                    minTemp: mintemp,
                    icon: icon,
                    index: index);
              },
              separatorBuilder: (context, index) =>
                  const SizedBox(width: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return SlideTransition(
      position: _slideAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: _AnimatedButton(
              label: "🔗 WeatherAPI",
              onPressed: () async {
                final urlString = "https://www.weatherapi.com";
                try {
                  if (await canLaunchUrl(Uri.parse(urlString))) {
                    await launchUrl(Uri.parse(urlString),
                        mode: LaunchMode.externalApplication);
                  }
                } catch (e) {
                  print("Error opening URL: $e");
                }
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _AnimatedButton(
              label: "📊 More Details",
              onPressed: () async {
                final urlString =
                    "https://www.weatherapi.com/weather/q/$city";
                try {
                  if (await canLaunchUrl(Uri.parse(urlString))) {
                    await launchUrl(Uri.parse(urlString),
                        mode: LaunchMode.externalApplication);
                  }
                } catch (e) {
                  print("Error opening URL: $e");
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated Button Widget
class _AnimatedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _AnimatedButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white.withOpacity(0.25),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Hourly Weather Card
class _HourlyWeatherCard extends StatelessWidget {
  final int hour;
  final double temperature;
  final String icon;
  final int index;

  const _HourlyWeatherCard(
      {required this.hour,
      required this.temperature,
      required this.icon,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.2),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$hour:00", style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 8),
          Image.network("https:$icon", width: 40, height: 40),
          const SizedBox(height: 8),
          Text("${temperature.toStringAsFixed(0)}°C",
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

/// Daily Weather Card
class _DailyWeatherCard extends StatelessWidget {
  final String date;
  final double maxTemp;
  final double minTemp;
  final String icon;
  final int index;

  const _DailyWeatherCard(
      {required this.date,
      required this.maxTemp,
      required this.minTemp,
      required this.icon,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.2),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(date, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 8),
          Image.network("https:$icon", width: 40, height: 40),
          const SizedBox(height: 8),
          Text("Max: ${maxTemp.toStringAsFixed(0)}°C",
              style: const TextStyle(color: Colors.white)),
          Text("Min: ${minTemp.toStringAsFixed(0)}°C",
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}