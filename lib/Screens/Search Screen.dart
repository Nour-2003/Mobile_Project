import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../Cubit/Shop/Shop Cubit.dart';
import '../Cubit/Shop/Shop States.dart';
import '../Shared/Constants.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final textController = TextEditingController();
  final SpeechToText speech = SpeechToText();
  bool speechEnabled = false;
  String lastWords = "";

  @override
  void initState() {
    super.initState();
    initSpeech();
    // Initialize the search with an empty string to show all products
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<ShopCubit>(context).searchProducts('');
    });
  }

  void initSpeech() async {
    speechEnabled = await speech.initialize();
    setState(() {});
  }

  void startListening(ShopCubit cubit) async {
    if (speechEnabled) {
      await speech.listen(onResult: onSpeechResult);
      setState(() {});
    }
  }

  void stopListening() async {
    await speech.stop();
    setState(() {
      lastWords = '';
    });
  }

  void onSpeechResult(result) {
    setState(() {
      lastWords = result.recognizedWords.trim(); // Get recognized speech
      textController.text = lastWords; // Update the text field with the speech result
      // Trigger search with the speech input
      BlocProvider.of<ShopCubit>(context).searchProducts(lastWords);
    });
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShopCubit()
        ..loadProducts(
            ShopCubit.get(context).productModel.products), // Load products here
      child: BlocBuilder<ShopCubit, ShopStates>(
        builder: (context, state) {
          var cubit = ShopCubit.get(context);

          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text('Search Page'),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: defaultTextFormField(
                            textController: textController,
                            label: 'Search',
                            type: TextInputType.text,
                            prefixIcon: Icon(CupertinoIcons.search),
                            Validator: (value) {
                              if (value!.isEmpty) {
                                return 'Search must not be empty';
                              }
                              return null;
                            },
                            onSubmit: (value) {
                              cubit.searchProducts(value);
                            },
                            onChange: (value) {
                              cubit.searchProducts(value);
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            color: defaultcolor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              speech.isListening
                                  ? Icons.mic
                                  : Icons.mic_off_sharp,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (speechEnabled) {
                                if (speech.isListening) {
                                  stopListening();
                                } else {
                                  startListening(cubit);
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    state is ShopSearchState || state is ShopProductsLoadedState
                        ? cubit.filteredProducts.isEmpty
                        ? Center(
                      child: Text(
                        'No Products Found',
                        style: GoogleFonts.montserrat(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    )
                        : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: GridView.count(
                        shrinkWrap: true,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 0.57,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        children: List.generate(
                            cubit.filteredProducts.length, (index) {
                          var product = cubit.filteredProducts[index];
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  child: Image(
                                    image: NetworkImage(product.image),
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${product.title}",
                                        maxLines: 2,
                                        style: GoogleFonts.montserrat(
                                            fontSize: 14, fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "${product.category}",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "\$${product.price}",
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blue),
                                            ),
                                            Material(
                                              color: Colors.transparent,
                                              borderRadius: BorderRadius.circular(20),
                                              child: InkWell(
                                                onTap: () {},
                                                borderRadius: BorderRadius.circular(20),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(5),
                                                  child: Icon(
                                                    Icons.favorite_border,
                                                    color: Colors.grey[600],
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: Row(
                                          children: [
                                            Row(
                                              children: List.generate(
                                                5, // Assuming a 5-star rating system
                                                    (starIndex) => Icon(
                                                  starIndex < product.rating.rate
                                                      ? Icons.star
                                                      : Icons.star_border,
                                                  color: Colors.amber,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              "${product.rating.rate.toStringAsFixed(1)}", // Display numerical rating
                                              style: GoogleFonts.montserrat(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    )
                        : CircularProgressIndicator(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
