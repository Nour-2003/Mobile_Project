import 'package:bloc/bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print('onCreate -- ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('onChange -- ${bloc.runtimeType}, $change');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('onError -- ${bloc.runtimeType}, $error');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print('onClose -- ${bloc.runtimeType}');
  }
}
bool themebool = false;
// {required String image,required String title,required String Date}
// Widget BuildarticleItem(article,context) {
//   var imageUrl = article['urlToImage'];
//   return InkWell(
//     onTap: () {
//       print(article['url']);
//     Navigator.push(context,
//         MaterialPageRoute(builder: (context) => WebviewScreen(url: article['url'],)));
//     },
//     child: Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Row(
//         children: [
//           Container(
//             width: 150,
//             height: 150,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(15),
//               image: DecorationImage(
//                   fit: BoxFit.cover,
//                   image: NetworkImage(
//                     imageUrl != null && imageUrl.isNotEmpty
//                         ? imageUrl
//                         : "https://st.depositphotos.com/1011646/1255/i/450/depositphotos_12553000-stock-photo-breaking-news-screen.jpg",
//                   )),
//             ),
//           ),
//           SizedBox(
//             width: 20,
//           ),
//           Expanded(
//             child: Container(
//               height: 150,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: 10,
//                   ),
//                   Expanded(
//                     child: Text(
//                       '${article['title']}',
//                       maxLines: 4,
//                       overflow: TextOverflow.ellipsis,
//                       style:Theme.of(context).textTheme.bodyMedium,
//                     ),
//                   ),
//                   Text(
//                     '${article['publishedAt']}',
//                     style: TextStyle(color: Colors.grey, fontSize: 16),
//                   )
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }
// Widget articleBuilder(list,context,{isSearch = false})
// {
//   return ConditionalBuilder(
//     condition: list.length > 0 ,
//     builder: (context) => ListView.separated(
//       physics: BouncingScrollPhysics(),
//       itemBuilder: (context, index) {
//         return BuildarticleItem(list[index],context);
//       },
//       separatorBuilder: (context, index) => Divider(
//         thickness: 1,
//         color: Colors.grey,
//       ),
//       itemCount: list.length,
//     ),
//     fallback: (context) => isSearch?Container():Center(child: CircularProgressIndicator()),
//   );
// }
Widget defaultTextFormField({
  required TextEditingController textController,
  required String label,
  required TextInputType type,
  Function? ontap,
  Function? onChange,
  required final String? Function(String?)? Validator,
  Function? onSubmit,
  bool isClickable = true, // Default value set to true
  Icon? prefixIcon,
  IconButton? suffixIcon,
  bool obscureText = false, // Default value set to false
}) =>
    TextFormField(
      controller: textController,
      onChanged: onChange as void Function(String)?,
      onTap: ontap as void Function()?, // Assuming onTap takes no arguments
      validator: Validator,
      enabled: isClickable,
      keyboardType: type,

      obscureText: obscureText, // No null check needed as default value is provided
      onFieldSubmitted: onSubmit as void Function(String)?,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 2.0, // Set border width here
          ),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );

Color defaultcolor = Color(0xFF00B96D);