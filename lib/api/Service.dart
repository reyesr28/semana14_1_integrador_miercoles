import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Post.dart';

class Service{

  static Future<Post> onePost() async{

    final response=await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts/1"));

    if(response.statusCode==200){
      return Post.fromJson(json.decode(response.body));
    }else{
      throw Exception('Error de consumo de Api');
    }

  }


  static Future<Post> consultaPost(String id) async{

    final response=await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts/${id}"));

    if(response.statusCode==200){
      return Post.fromJson(json.decode(response.body));
    }else{
      throw Exception('Error de consumo de Api');
    }

  }


}