import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MainHomeScreen2 extends StatefulWidget {
  const MainHomeScreen2({super.key});

  @override
  State<MainHomeScreen2> createState() => _MainHomeScreen2State();
}

class _MainHomeScreen2State extends State<MainHomeScreen2> {
  double Temperature = 0;
  double WindsPEED = 0;
  double ReeLFEEL = 0;
  int Humidity = 0;
  int UVINDEX = 0;
  String WEATHERTEXT = "";

  List hourlyData = [];
  List dailyData = [];

  bool loading = true;

  // 🌤 Weather Text
  String getWeatherText(int code) {
    if (code == 0) return "Clear ☀";
    if (code <= 3) return "Cloudy ☁";
    if (code <= 48) return "Fog 🌫";
    if (code <= 67) return "Rain 🌧";
    if (code <= 77) return "Snow ❄";
    return "Unknown";
  }

  // 🌐 API CALL
  Future<void> fetchWeather() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.open-meteo.com/v1/forecast?latitude=31.52&longitude=74.35'
          '&current_weather=true'
          '&hourly=temperature_2m,weathercode'
          '&daily=weathercode,temperature_2m_max,temperature_2m_min'
          '&timezone=auto',
        ),
      );

      final data = jsonDecode(response.body);

      // Current
      Temperature = data['current_weather']['temperature'];
      WindsPEED = data['current_weather']['windspeed'];
      int code = data['current_weather']['weathercode'];

      // Hourly
      hourlyData = List.generate(12, (index) {
        return {
          "time": data['hourly']['time'][index],
          "temp": data['hourly']['temperature_2m'][index],
        };
      });

      // Daily
      dailyData = List.generate(7, (index) {
        return {
          "date": data['daily']['time'][index],
          "max": data['daily']['temperature_2m_max'][index],
          "min": data['daily']['temperature_2m_min'][index],
        };
      });

      setState(() {
        WEATHERTEXT = getWeatherText(code);
        ReeLFEEL = Temperature;
        loading = false;
      });
    } catch (e) {
      print(e);
      setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          )
        : Scaffold(
            body: RefreshIndicator(
              onRefresh: fetchWeather,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF81D4FA), Color(0xFF0288D1)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        /// 📍 Location
                        const Text(
                          "Lahore, Pakistan",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),

                        const SizedBox(height: 20),

                        /// 🌤 Current Weather
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text("Now"),
                                    Text(
                                      "$Temperature°",
                                      style: const TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("RealFeel: $ReeLFEEL°"),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(WEATHERTEXT),
                                    Text("Wind: $WindsPEED km/h"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// ⏰ 12 HOURS
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text("Next 12 Hours",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 90,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: hourlyData.length,
                                    itemBuilder: (context, index) {
                                      final item = hourlyData[index];
                                      return Container(
                                        width: 80,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(item['time']
                                                .substring(11, 16)),
                                            const Icon(Icons.cloud),
                                            Text("${item['temp']}°"),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// 📅 7 DAYS
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const Text("Next 7 Days",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10),
                                SizedBox(
                                  height: 90,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: dailyData.length,
                                    itemBuilder: (context, index) {
                                      final item = dailyData[index];
                                      return Container(
                                        width: 90,
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(item['date']
                                                .substring(5, 10)),
                                            const Icon(Icons.cloud),
                                            Text(
                                                "${item['max']}° / ${item['min']}°"),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}