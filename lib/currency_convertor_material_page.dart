import 'dart:ui';
import 'package:currency_convertor/getbg.dart';
import 'package:currency_convertor/getbg2.dart';
import 'package:currency_convertor/options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<double> fetchExchangeRate(Map<String, String> currency) async {
  Map<String, String> selected = currency;
  final String country = selected['text'].toString();
  const String apikey = 'b1a0d4250202fe1a1dd11726';
  final response = await http.get(
    Uri.parse('https://v6.exchangerate-api.com/v6/$apikey/latest/$country'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    double rate = data['conversion_rates']['INR'];
    return rate;
  } else {
    throw Exception('Failed to fetch exchange rate');
  }
}

class CurrencyConvertorMaterialPage extends StatefulWidget {
  const CurrencyConvertorMaterialPage({super.key});

  @override
  State<CurrencyConvertorMaterialPage> createState() =>
      _CurrencyConvertorMaterialPageState();
}

class _CurrencyConvertorMaterialPageState
    extends State<CurrencyConvertorMaterialPage> {
  bool isReversed = false;
  Map<String, String> selectedValue = options[0];
  final TextEditingController amountcontroller = TextEditingController();
  final TextEditingController resultController = TextEditingController();
  double? liverate, reverse;
  bool isConverting = false;

  @override
  void initState() {
    super.initState();
    loadliveRate();
  }

  void loadliveRate() async {
    try {
      final rate = await fetchExchangeRate(selectedValue);
      setState(() {
        liverate = rate;
        reverse = 1 / rate;
      });
    } catch (e) {
      setState(() {
        liverate = null;
        reverse = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double rate = 0.0;
    final border2 = OutlineInputBorder(
      borderSide: BorderSide(
        color: const Color.fromARGB(255, 2, 77, 4),
        width: 2,
        strokeAlign: BorderSide.strokeAlignOutside,
      ),
      borderRadius: BorderRadius.circular(10),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(194, 255, 255, 255),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'CURRENCY CONVERTOR',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                    isReversed == false
                        ? AssetImage(getbg(selectedValue['text'].toString()))
                        : AssetImage(getbg2(selectedValue['text'].toString())),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  const Color.fromARGB(182, 0, 0, 0),
                  BlendMode.color,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              color: const Color.fromARGB(136, 0, 0, 0),
              height: 350,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isReversed == false
                        ? Text(
                          'Convert ${selectedValue['text'].toString()} to INR',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(255, 255, 255, 1),
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(2, 2),
                                blurRadius: 2.0,
                              ),
                            ],
                          ),
                        )
                        : Text(
                          'Convert INR to ${selectedValue['text'].toString()}',
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(255, 255, 255, 1),
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: Offset(2, 2),
                                blurRadius: 2.0,
                              ),
                            ],
                          ),
                        ),
                    const SizedBox(height: 15),
                    Container(
                      width: 250,
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: DropdownButton(
                          menuMaxHeight: 250,
                          focusColor: Colors.white,
                          enableFeedback: true,
                          dropdownColor: const Color.fromARGB(
                            255,
                            255,
                            255,
                            255,
                          ),
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                          ),
                          value: selectedValue,
                          items:
                              options.map<
                                DropdownMenuItem<Map<String, String>>
                              >((Map<String, String> value) {
                                bool isSelected =
                                    selectedValue['text'] == value['text'];
                                return DropdownMenuItem<Map<String, String>>(
                                  value: value,
                                  child: Text(
                                    value['title'].toString(),
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (Map<String, String>? newValue) {
                            setState(() {
                              selectedValue = newValue!;
                              amountcontroller.clear();
                              resultController.clear();
                              loadliveRate();
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: amountcontroller,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  isReversed == false
                                      ? 'Enter ${selectedValue['text']}'
                                      : 'Enter INR',
                              hintStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              suffixIcon:
                                  isReversed == false
                                      ? Icon(Icons.monetization_on)
                                      : Padding(
                                        padding: EdgeInsets.all(
                                          13.5,
                                        ), // Optional, to center nicely
                                        child: SvgPicture.asset(
                                          'assets/icons/Rupee.svg',
                                          width: 20,
                                          height: 20,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                              suffixIconColor: Colors.black,
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: border2,
                              enabledBorder: border2,
                            ),
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            onSubmitted: (value) async {
                              final amount = double.tryParse(
                                amountcontroller.text,
                              );
                              if (amount == null) return;

                              setState(() {
                                isConverting = true;
                              });

                              try {
                                rate = await fetchExchangeRate(selectedValue);
                                double reversed = 1 / rate;
                                final result =
                                    isReversed == false
                                        ? amount * rate
                                        : amount * reversed;
                                resultController.text =
                                    isReversed == false
                                        ? '${result.toStringAsFixed(2)} INR'
                                        : '${result.toStringAsFixed(2)} ${selectedValue['text'].toString()}';
                              } catch (e) {
                                resultController.text = 'Error fetching rate';
                              }

                              setState(() {
                                isConverting = false;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              isReversed = !isReversed;
                              amountcontroller.clear();
                              resultController.clear();
                            });
                          },
                          icon: Icon(
                            Icons.change_circle,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: resultController,
                            readOnly: true,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  isReversed == true
                                      ? '${selectedValue['text']}'
                                      : 'INR',
                              hintStyle: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              suffixIcon:
                                  isReversed == false
                                      ? Padding(
                                        padding: EdgeInsets.all(13.5),
                                        child: SvgPicture.asset(
                                          'assets/icons/Rupee.svg',
                                          width: 20,
                                          height: 20,
                                          fit: BoxFit.contain,
                                        ),
                                      )
                                      : Icon(Icons.monetization_on),
                              suffixIconColor: Colors.black,
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: border2,
                              enabledBorder: border2,
                            ),
                            keyboardType: TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ButtonStyle(
                        fixedSize: WidgetStatePropertyAll(Size(120, 40)),
                        backgroundColor: WidgetStatePropertyAll(
                          const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      child:
                          isConverting
                              ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                'Convert',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                      onPressed: () async {
                        final amount = double.tryParse(amountcontroller.text);
                        if (amount == null) return;

                        setState(() {
                          isConverting = true;
                        });

                        try {
                          rate = await fetchExchangeRate(selectedValue);
                          final result = amount * rate;
                          resultController.text =
                              isReversed == false
                                  ? '${result.toStringAsFixed(2)} INR'
                                  : '${result.toStringAsFixed(2)} ${selectedValue['text'].toString()}';
                        } catch (e) {
                          resultController.text = 'Error fetching rate';
                        }

                        setState(() {
                          isConverting = false;
                        });
                      },
                    ),
                    const SizedBox(height: 15),
                    if (liverate != null && reverse != null)
                      isReversed == false
                          ? Text(
                            'Live Exchange Rate: 1 ${selectedValue['text'].toString()} = ${liverate!.toStringAsFixed(2)} INR',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                          : Text(
                            'Live Exchange Rate: 1 INR = ${reverse!.toStringAsFixed(4)}  ${selectedValue['text'].toString()}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                    else
                      Text(
                        'Fetching live exchange rate...',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
